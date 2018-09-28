RSpec.describe Auth do
  shared_examples 'cannot be hacked' do
    it 'returns false for blank user, pass' do
      expect(subject.call('','')).to be false
    end
    it 'returns false for user, bad pass' do
      expect(subject.call('user', Faker::Lorem.word)).to be false
    end

    it 'returns false for user, pass hash (if appropriate)' do
      unless entry.nil?
        expect(subject.call('user', entry.split(':')[2])).to be false
      end
    end
  end

  describe '.ok?' do
    let(:entry) { nil }
    around do |example|
      Dir.mktmpdir 'squiddo-test' do |dir|
        described_class.passwd_file = File.join(dir, 'auth')
        example.run
      end
    end

    subject { described_class.method(:ok?) }

    context 'with no file' do
      it 'does not allow login with the user:password' do
        expect { subject.call('user', 'password') }.to raise_error(Errno::ENOENT)
      end
    end

    context 'with an empty file' do
      before do
        File.open(described_class.passwd_file, 'w') do |f|
        end
      end

      it_behaves_like 'cannot be hacked', ''
      it 'does not allow login with the user:password' do
        expect(subject.call('user', 'password')).to be false
      end
    end

    context 'with several wrongo entries' do
      before do
        File.open(described_class.passwd_file, 'w') do |f|
          3.times do
            user = Faker::Lorem.word
            salt = Faker::Lorem.word
            pass = Faker::Lorem.word
            hash = Digest::SHA2.new(256).hexdigest "#{salt}:#{pass}"
            f.write("#{user}:#{salt}:#{hash}\n")
          end
        end
      end

      it_behaves_like 'cannot be hacked', ''
      it 'does not allow login with the user:password' do
        expect(subject.call('user', 'password')).to be false
      end
    end

    context 'with a user entry' do
      let(:salt) { Faker::Lorem.word }
      let(:entry) { "user:#{salt}:#{Digest::SHA2.new(256).hexdigest "#{salt}:password"}" }

      before do
        File.open(described_class.passwd_file, 'w') do |f|
          3.times do
            user = Faker::Lorem.word
            salt = Faker::Lorem.word
            pass = Faker::Lorem.word
            hash = Digest::SHA2.new(256).hexdigest "#{salt}:#{pass}"
            f.write("#{user}:#{salt}:#{hash}\n")
          end

          f.write("#{entry}\n")
        end
      end

      it_behaves_like 'cannot be hacked'
      it 'allows login with the correct details' do
        expect(subject.call('user', 'password')).to be true
      end
    end
  end

  describe '#check_pass' do
    let(:sum) { Digest::SHA2.new(256).hexdigest "#{salt}:securepassword" }
    let(:salt) { Faker::Lorem.word }
    subject { described_class.new('hamlet').check_pass(sum, salt, entered) }

    context 'with real password' do
      let(:entered) { 'securepassword' }
      it { is_expected.to be true }
    end

    context 'with any other password' do
      let(:entered) { Faker::Lorem.word }
      it { is_expected.to be false }
    end
  end

  describe '#any_line?' do
    let(:data) { "hello\ntest\ni_am_testing" }
    let(:file) { Class.new do
      def initialize(data)
        @data = data
      end
      def each_line
        @data.split("\n").each do |line|
          yield line
        end
      end
    end.new(data) }
    subject { described_class.new(file) }

    it 'returns true when a line matches' do
      expect(subject.any_line? do |l|
        l == 'hello'
      end).to be true

      expect(subject.any_line? do |l|
        l == 'test'
      end).to be true

      expect(subject.any_line? do |l|
        l == 'i_am_testing'
      end).to be true
    end

    it 'returns false when a line does not match' do
      expect(subject.any_line? do |l|
        l == 'hammo'
      end).to be false
    end

    it 'next works as expected' do
      expect(subject.any_line? do |l|
        next unless l == 'i_am_testing'
        true
      end).to be true

      expect(subject.any_line? do |l|
        next unless l == 'hammo'
        true
      end).to be false
    end
  end
end

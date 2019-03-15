require 'spongiform/services/domainlist'

RSpec.describe Spongiform::Server::Services::DomainList do
  subject { described_class.new }

  describe '#domainslist' do
    context 'when no domains' do
      it 'is empty string' do
        expect(subject.domainlist).to be_empty
      end
    end

    context 'with 5 domains' do
      let!(:domains) { FactoryBot.create_list(:domain, 5) }

      it 'is 5 domains long' do
        expect(subject.domainlist.split("\n").count).to eq 5
      end

      it 'has every domain' do
        domains.each do |domain|
          expect(subject.domainlist).to match(/^#{domain.domain}$/)
        end
      end
    end
  end

  describe '#write!' do
    let(:dir) { Dir.mktmpdir 'domainlist' }
    let(:filename) { File.join dir, 'domainlist' }

    after do
      FileUtils.rm_rf dir
    end

    context 'when there is a load of allowed domains' do
      let(:domains) { FactoryBot.create_list(:domain, 5) }

      before do
        domains # just making sure them domains exist
        subject.write!(filename)
      end


      it 'writes the complete list of domains to the file' do
        file_contents = IO.read(filename)
        
        domains.each do |domain|
          expect(file_contents).to match(/^#{domain.domain}$/)
        end
      end
    end
  end
end

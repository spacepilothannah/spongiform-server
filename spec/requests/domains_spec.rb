RSpec.describe App, roda: :app do
  describe 'GET /domains' do
    subject { get '/domains/' }
  end

  fdescribe 'POST /domains/:domain' do
    let(:domain) { 'example.com' }
    subject { post "/domains/#{domain}", headers: { 'Content-Type': 'application/json' }, body: { allowed: false } }

    it { is_expected.to be_successful }

    it 'creates the domain' do
      expect { subject }.to change { Domain.count }.by(1)
    end

    it 'returns the domain' do
      expect(subject.body).to eq domain: domain, allowed: false
    end
  end
end

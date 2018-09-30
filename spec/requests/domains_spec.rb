RSpec.describe App::Domains, roda: :app do
  let(:auth) { true }

  before do
    basic_authorize('test-user', 'test-password') if auth
  end

  let(:allowed_domains) { FactoryBot.create_list(:domain, 3) }

  before do
    allowed_domains
  end

  describe 'GET /domains' do
    subject { get '/' }
    let(:json) { JSON.parse(subject.body) }

    it_behaves_like 'a successful api request'

    it { is_expected.to be_successful }
    its(:content_type) { is_expected.to eq 'application/json' }
    it 'contains all domains' do
      allowed_domains.each do |d|
	expect(json.any? { |js_domain| d.domain == js_domain['domain'] }).to be true 
      end
    end
    its(:status) { is_expected.to eq 200 }
  end

  describe 'POST /domains/:domain' do
    let(:domain) { 'example.com' }
    let(:args) { { domain: domain } }
    let(:json) { JSON.parse(subject.body) }
    subject { post "/#{domain}", headers: { 'Content-Type': 'application/json' }, body: args }

    context 'domain already exists' do
      let(:args) { { domain: domain } }

      before do
	FactoryBot.create(:domain, domain: 'example.com')
      end

      it_behaves_like 'a successful api request'

      it 'does not add a new row' do
	expect { subject }.to change { Domain.count }.by(0)
      end

      it 'returns the domain' do
	expect(json['domain']).to eq domain
      end
    end

    context 'domain is new' do
      let(:args) { { domain: domain } }
      it_behaves_like 'a successful api request'

      it 'creates the domain' do
	expect { subject }.to change { Domain.count }.by(1)
	expect(Domain.last.domain).to eq domain
      end
    end
  end

  describe 'DELETE /domains/:domain' do
    let(:domain) { 'example.com' }

    subject { delete "/#{domain}" }

    before do
      FactoryBot.create_list(:domain, 4)
    end
     
    context 'when domain exists' do
      before do
	FactoryBot.create(:domain, domain: domain)
      end

      it 'deletes the domain' do
	subject
	expect(Domain.where(domain: domain).count).to eq 0
      end

      it 'deletes something' do
	expect { subject }.to change { Domain.count }.by(-1)
      end
    end

    context 'when domain does not exist' do
      it 'does not delete anything' do
	expect { subject }.to change { Domain.count }.by(0)
      end
    end
  end
end

RSpec.describe App::Requests, roda: :app do
  let(:auth) { true }
  before do
      basic_authorize('test', 'test') if auth
  end

 describe 'GET /' do
    subject { get '/'  }
    let(:allowed_requests) { FactoryBot.create_list(:request, 4, :allowed) }
    let(:denied_requests) { FactoryBot.create_list(:request, 4, :denied) }
    let(:pending_requests) { FactoryBot.create_list(:request, 4) }
    let(:json) { JSON.parse(subject.body) }

    before do
      allowed_requests
      denied_requests
      pending_requests
    end

    context 'when not filtering requests' do
	it_behaves_like 'a successful api request'

	it 'returns all requests' do
	  expect(json.count).to eq 12
	end
    end

    context 'when filtering denied requests' do
	subject { get '/?allowed=false' }
	it_behaves_like 'a successful api request'

	it 'returns only denied requests' do
	  expect(json.count).to eq 4
	  expect(json[0]['denied_at']).not_to be nil
	  expect(json[1]['denied_at']).not_to be nil
	  expect(json[2]['denied_at']).not_to be nil
	  expect(json[3]['denied_at']).not_to be nil
	end
    end

    context 'when filtering allowed requests' do
	subject { get '/?allowed=true' }
	it_behaves_like 'a successful api request'

	it 'returns only allowed requests' do
	  expect(json.count).to eq 4
	  expect(json[0]['allowed_at']).not_to be nil
	  expect(json[1]['allowed_at']).not_to be nil
	  expect(json[2]['allowed_at']).not_to be nil
	  expect(json[3]['allowed_at']).not_to be nil
	end
    end

    context 'when filtering pending requests' do
	subject { get '/?pending=true' }
	it_behaves_like 'a successful api request'

	it 'returns only allowed requests' do
	  expect(json.cont).to eq 4
	  expect(json[0]['allowed_at']).to be nil
	  expect(json[1]['allowed_at']).to be nil
	  expect(json[2]['allowed_at']).to be nil
	  expect(json[3]['allowed_at']).to be nil
	  expect(json[0]['denied_at']).to be nil
	  expect(json[1]['denied_at']).to be nil
	  expect(json[2]['denied_at']).to be nil
	  expect(json[3]['denied_at']).to be nil
	end
    end
  end

  fdescribe 'POST /' do
    let(:url) { Faker::Internet.url }
    let(:auth) { false }
    subject { post '/', url: url }


    context 'when url is specified' do
      it { is_expected.to be_successful }
      its(:content_type) { is_expected.to eq 'text/html' }

      it 'should create a request' do
	expect { subject }.to change { Request.count }.by(1)
      end

      it 'created request is pending' do
	subject
	expect(Request.last.pending?).to be true
      end

      context 'when url is a duplicate of an already pending request' do
	before do
	  FactoryBot.create(:request, url: url)
	end

	it { is_expected.not_to be_successful }
	it { expect { subject }.to change { Request.count }.by(0) }
	its(:content_type) { is_expected.to eq 'text/html' }
      end
    end

    context 'when url is not specified' do
      subject { post '/' }

      it { is_expected.not_to be_successful }
      its(:status) { is_expected.to eq 400 }
      it { expect { subject }.to change { Request.count }.by(0) }
      its(:content_type) { is_expected.to eq 'text/html' }
    end
  end

  describe 'GET /not_on_whitelist' do
    let(:auth) { false }
    it { is_expected.to be_successful }
    its(:content_type) { is_expected.to eq 'text/html' }
  end

  describe 'PUT /:id' do
    it_behaves_like 'a successful api request'
  end
end

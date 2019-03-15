require 'spongiform/wsapi/requests'

RSpec.describe Spongiform::Requests, roda: :app do
  let(:auth) { true }

  before do
    basic_authorize('test-user', 'test-password') if auth
  end

  describe 'GET /' do
    subject { get '/' }
    let(:allowed_requests) { FactoryBot.create_list(:request, 4, :allowed) }
    let(:denied_requests) { FactoryBot.create_list(:request, 4, :denied) }
    let(:pending_requests) { FactoryBot.create_list(:request, 4, :pending) }
    let(:unpending_requests) { FactoryBot.create_list(:request, 4) }
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
	expect(json.count).to eq 4
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

  describe 'POST /' do
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
	let(:old_request) { FactoryBot.create(:request, :pending, url: url) }

	before do
	  old_request
	end

	it { is_expected.to be_successful }
	it { expect { subject }.to change { Request.count }.by(0) }
	its(:content_type) { is_expected.to eq 'text/html' }
	its(:body) { is_expected.to match /href=['"]\/requests\/#{old_request.id}["']/ }
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
    subject { get '/not_on_whitelist' }
    it { is_expected.to be_successful }
    its(:content_type) { is_expected.to eq 'text/html' }

    context 'when url is specified' do
      let(:url) { 'http://example.com/test/?fortified=false&blammo=%2Fgef' }
      subject { get "/not_on_whitelist?url=#{ERB::Util.url_encode(url)}" }

      it { is_expected.to be_successful }
      it 'creates a Request' do
	expect {subject }.to change { Request.count }.by(1)
      end
    end
  end

  describe 'PUT /:id' do
    let(:id) { 45 }
    let(:allow) { true }
    subject { put "/#{id}", allow: allow }

    context 'when the request does not exist' do
      [{allow: true}, {allow: false}, {}].each do |params|
	context "when allow is #{params[:allow].inspect}" do
	  subject { put "/#{id}", params }

	  it { is_expected.not_to be_successful }

	  it 'creates no domains' do
	    expect { subject }.to change { Domain.count }.by(0)
	  end

	  it 'does not create a request' do
	    subject
	    expect(Request.where(id: id)).to be_empty
	  end
	end
      end
    end

    context 'when the request exists' do
      let(:request) { FactoryBot.create(:request, url: 'https://example.com/4544/dsfsd/sdf?beef=no', id: 45) }
      before do
	request
      end

      context 'when allowing the request' do
	it_behaves_like 'a successful api request'

	context 'when the domain does not already exist' do
	  it 'creates a new Domain' do
	    expect { subject }.to change { Domain.count }.by(1)
	  end

	  it 'sets allowed_at' do
	    subject
	    expect(request.reload.allowed_at).not_to be_nil
	  end
	end

	context 'when the domain already exists' do
	  before do 
	    FactoryBot.create(:domain, domain: 'example.com')
	  end

	  it { is_expected.to be_successful }

	  it 'does not create a new domain' do
	    expect { subject }.to change { Domain.count }.by(0)
	  end

	  it 'sets allowed_at' do
	    expect(request.reload.allowed_at).to be_nil
	    subject
	    expect(request.reload.allowed_at).not_to be_nil
	  end
	end
      end

      context 'when denying the request' do
	let(:allow) { false }
	it_behaves_like 'a successful api request'

	context 'when the domain exists' do
	  before do 
	    FactoryBot.create(:domain, domain: 'example.com')
	  end

	  it { is_expected.to be_successful }
	  it 'sets denied_at' do
	    expect(request.reload.denied_at).to be_nil
	    subject
	    expect(request.reload.denied_at).not_to be_nil
	  end
	  it 'deletes the domain' do
	    subject
	    expect(Domain.where(domain: 'example.com').count).to eq 0
	  end
	end
	context 'when the domain does not exist' do

	end
      end

      context 'when not specifying whether to allow the request' do
	subject { put "/#{id}" }
	it { is_expected.not_to be_successful }
      end
    end
  end
end

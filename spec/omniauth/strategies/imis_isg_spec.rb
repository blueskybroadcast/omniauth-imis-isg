require 'multi_json'

RSpec.describe OmniAuth::Strategies::ImisIsg do
  let(:request) { double }
  let(:user_info) { response_fixture('user_info') }

  subject { described_class.new('app_id', 'secret') }

  describe '#options' do
    describe '#name' do
      it { expect(subject.options.name).to eq 'imis_isg' }
    end

    describe '#client_options' do
      describe '#login_page_url' do
        it { expect(subject.options.client_options.login_page_url).to eq 'MUST_BE_PROVIDED' }
      end
    end

    describe '#app_options' do
      describe '#app_event_id' do
        it { expect(subject.options.app_options.app_event_id).to be_nil }
      end
    end
  end

  describe '#info' do
    before do
      allow(subject).to receive(:request).and_return(request)
      allow(request).to receive(:params).and_return(to_json(MultiJson.dump(user_info)))
    end

    context 'uid' do
      it 'returns uid' do
        expect(subject.info[:uid]).to eq '1234'
      end
    end

    context 'first_name' do
      it 'returns first_name' do
        expect(subject.info[:first_name]).to eq 'Bender'
      end
    end

    context 'last_name' do
      it 'returns last_name' do
        expect(subject.info[:last_name]).to eq 'Rodriguez'
      end
    end

    context 'email' do
      it 'returns email' do
        expect(subject.info[:email]).to eq 'bender@planet.express'
      end
    end

    context 'username' do
      it 'returns username' do
        expect(subject.info[:username]).to eq 'bendergetsbetter'
      end
    end

    context 'access_code' do
      it 'returns access_code' do
        expect(subject.info[:access_code]).to eq 'RUBY'
      end
    end
  end
end

def response_fixture(filename)
  to_json(IO.read("spec/fixtures/#{filename}.json"))
end

def to_json(raw)
  MultiJson.load(raw)
end

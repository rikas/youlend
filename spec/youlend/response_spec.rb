# frozen_string_literal: true

require 'ostruct'

RSpec.describe Youlend::Response do
  subject(:response) { described_class.new(http_response) }

  let(:status) { 200 }
  let(:http_response) { OpenStruct.new(body: { success: true }, status: status) }

  describe '#body' do
    it 'returns the body from the given http response' do
      expect(response.body).to eq(success: true)
    end
  end

  describe '#status' do
    [201, 404, 500].each do |status|
      context "when the http response has status #{status}" do
        let(:status) { status }

        it "returns #{status}" do
          expect(response.status).to eq(status)
        end
      end
    end
  end

  describe '#success?' do
    context 'when the http success? is true' do
      let(:http_response) { OpenStruct.new(success?: true) }

      it 'returns true' do
        expect(response).to be_success
      end
    end

    context 'when the http success? is false' do
      let(:http_response) { OpenStruct.new(success?: false) }

      it 'returns false' do
        expect(response).not_to be_success
      end
    end
  end

  describe '#unauthorized?' do
    context 'when the status is 401' do
      let(:status) { 401 }

      it 'returns true' do
        expect(response).to be_unauthorized
      end
    end

    context 'when the status is not 401' do
      let(:status) { 203 }

      it 'returns false' do
        expect(response).not_to be_unauthorized
      end
    end
  end

  describe '#token_expired?' do
    context 'when the auth header has "token is expired"' do
      let(:http_response) do
        OpenStruct.new(headers: { 'www-authenticate' => 'token is expired' })
      end

      it 'returns true' do
        expect(response).to be_token_expired
      end
    end

    context 'when the auth header is not present' do
      let(:http_response) do
        OpenStruct.new(headers: { 'other-header' => 'token is expired' })
      end

      it 'returns false' do
        expect(response).not_to be_token_expired
      end
    end

    context 'when the auth header has something else' do
      let(:http_response) do
        OpenStruct.new(headers: { 'www-authenticate' => 'token is ok:)' })
      end

      it 'returns false' do
        expect(response).not_to be_token_expired
      end
    end
  end
end

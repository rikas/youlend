# frozen_string_literal: true

RSpec.describe Youlend::Auth do
  describe '#request_token' do
    it 'raises an error if the credentials are not correct' do
      VCR.use_cassette('auth_incorrect') do
        allow(Youlend.configuration).to receive(:client_id).and_return('test')

        expect { described_class.request_token }.to raise_exception('Unauthorized')
      end
    end

    it 'returns a token for prequalification if the client_id and client_secret are correct' do
      VCR.use_cassette('auth_prequalification_correct') do
        token = described_class.request_token

        expect(token).to start_with('eyJ')
      end
    end

    it 'sets the audience token in the configuration object' do
      VCR.use_cassette('auth_prequalification_correct') do
        Youlend.configuration.tokens[:prequalification] = ''

        token = described_class.request_token

        expect(Youlend.configuration.tokens[:prequalification]).to eq(token)
      end
    end

    it 'returns a different token depending on the audience' do
      VCR.use_cassette('auth_prequalification_correct') do
        described_class.request_token
      end

      VCR.use_cassette('auth_onboarding_correct') do
        described_class.request_token(:onboarding)
      end

      token1 = Youlend.configuration.tokens[:prequalification]
      token2 = Youlend.configuration.tokens[:onboarding]

      expect(token1).not_to eq(token2)
    end

    it 'raises "Invalid Audience" if the audience is invalid' do
      expect { described_class.request_token(:whatever) }.to raise_exception('Invalid Audience')
    end
  end
end

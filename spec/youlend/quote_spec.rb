# frozen_string_literal: true

require 'youlend/merchant_generator'

RSpec.describe Youlend::Quote do
  describe '.pre_qualification' do
    context 'when the data is correct' do
      it 'returns the data as expected' do
        VCR.use_cassette('prequalification_correct') do
          params = Youlend::MerchantGenerator.generate
          params[:companyName] = 'Test company'
          response = described_class.pre_qualification(params)

          expect(response).to be_success
          expect(response.body[:companyName]).to eq('Test company')
        end
      end
    end

    context 'when the data is incorrect' do
      it 'returns errors for each field' do
        VCR.use_cassette('prequalification_incorrect') do
          params = Youlend::MerchantGenerator.generate
          params[:companyType] = 'not_correct'

          response = described_class.pre_qualification(params)

          expect(response).not_to be_success
          expect(response.body[:CompanyType].first).to match('The company type is invalid.')
        end
      end
    end

    context 'when the pre qualification is rejected' do
      it 'returns an error message' do
        VCR.use_cassette('prequalification_rejection') do
          data = File.open(File.join(__dir__, '../data/rejection.json')).read
          params = MultiJson.load(data, symbolize_keys: true)

          response = described_class.pre_qualification(params)

          expect(response).not_to be_success
          expect(response.body[:error]).not_to be_nil
          expect(response.body[:error_description]).to match('Loan was rejected')
        end
      end
    end
  end
end

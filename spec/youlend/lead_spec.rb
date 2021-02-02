# frozen_string_literal: true

require 'youlend/lead_generator'

RSpec.describe Youlend::Lead do
  describe '.create' do
    context 'when the data is correct' do
      it 'returns the data as expected' do
        VCR.use_cassette('lead_create_correct') do
          lead_params = Youlend::LeadGenerator.generate

          response = described_class.create(lead_params)

          expect(response).to be_success
          expect(response.body[:leadId]).not_to be_nil
        end
      end
    end

    context 'when the data is incorrect' do
      it 'returns errors for each field' do
        VCR.use_cassette('lead_create_incorrect') do
          lead_params = Youlend::LeadGenerator.generate
          lead_params[:companyType] = 'incorrect'

          response = described_class.create(lead_params)

          expect(response).not_to be_success
          expect(response.body[:CompanyType].first).to start_with('The company type is invalid.')
        end
      end
    end
  end
end

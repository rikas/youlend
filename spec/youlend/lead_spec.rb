# frozen_string_literal: true

require 'youlend/params_generators/lead'

RSpec.describe Youlend::Lead do
  describe '.create' do
    context 'when the data is correct' do
      it 'returns the data as expected' do
        VCR.use_cassette('lead_create_correct') do
          lead_params = Youlend::ParamsGenerators::Lead.generate

          response = described_class.create(lead_params)

          expect(response).to be_success
          expect(response.body[:leadId]).not_to be_nil
        end
      end
    end

    context 'when the data is incorrect' do
      it 'returns errors for each field' do
        VCR.use_cassette('lead_create_incorrect') do
          lead_params = Youlend::ParamsGenerators::Lead.generate
          lead_params[:companyType] = 'incorrect'

          response = described_class.create(lead_params)

          expect(response).not_to be_success
          expect(response.body[:'$.companyType']).not_to be_empty
        end
      end
    end
  end

  describe '.update' do
    context 'when the data is correct' do
      it 'updates the data' do
        lead_params = Youlend::ParamsGenerators::Lead.generate
        lead_id = nil

        VCR.use_cassette('lead_create_correct') do
          response = described_class.create(lead_params)

          lead_id = response.body[:leadId]
        end

        VCR.use_cassette('lead_update_correct') do
          response = described_class.update(lead_id, lead_params)

          expect(response).to be_success
          expect(response.body).to be_empty
        end
      end
    end
  end

  describe '.details' do
    context 'when not submitted' do
      it 'returns details' do
        VCR.use_cassette('lead_details_incomplete') do
          response = described_class.details('fd984430-4042-4f32-afb2-35700d1564b2')

          expect(response).to be_success
          expect(response.body[:onboardingState]).to eq('stage1incomplete')
        end
      end
    end

    context 'when submitted' do
      it 'returns details' do
        VCR.use_cassette('lead_details_submitted') do
          response = described_class.details('0f9b892f-3816-4afe-a582-1ce0ea708fdb')

          expect(response).to be_success
          expect(response.body[:onboardingState]).to eq('stage1submitted')
        end
      end
    end
  end
end

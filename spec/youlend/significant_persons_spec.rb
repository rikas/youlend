# frozen_string_literal: true

require 'youlend/params_generators/significant_persons'

RSpec.describe Youlend::SignificantPersons do
  describe '.create' do
    context 'when the data is correct' do
      it 'returns the data as expected' do
        VCR.use_cassette('significant_persons_create_correct') do
          params = Youlend::ParamsGenerators::SignificantPersons.generate

          response = described_class.create('620fb657-cff2-4e21-98d8-457b7c17b9bc', params)

          expect(response).to be_success
          expect(response.body[:significantPersonIds]).not_to be_empty
        end
      end
    end

    context 'when the data is incorrect' do
      it 'returns errors for each field' do
        VCR.use_cassette('significant_persons_create_incorrect') do
          params = Youlend::ParamsGenerators::SignificantPersons.generate
          params[:significantPersons][0][:firstName] = ''

          response = described_class.create('620fb657-cff2-4e21-98d8-457b7c17b9bc', params)

          expect(response).not_to be_success
          expect(response.body[:'SignificantPersons[0].FirstName'].first)
            .to include('must not be empty')
        end
      end
    end
  end
end

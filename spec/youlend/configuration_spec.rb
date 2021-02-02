# frozen_string_literal: true

RSpec.describe Youlend::Configuration do
  before do
    stub_const('Rails', OpenStruct.new(env: :development))
  end

  describe '#api_domain' do
    let(:config) { described_class.new }

    it 'returns the right domain for the dev environment' do
      config.env = :development

      expect(config.api_domain).to match(/staging/)
    end

    it 'returns the right domain for the production environment' do
      config.env = :production

      expect(config.api_domain).not_to match(/staging/)
    end

    context 'when in a Rails app' do
      it 'returns the right domain for the dev environment' do
        Rails.env = :development

        expect(config.api_domain).to match(/staging/)
      end

      it 'returns the right domain for the production environment' do
        Rails.env = :production

        expect(config.api_domain).not_to match(/staging/)
      end
    end
  end

  describe '#debug?' do
    let(:config) { described_class.new }

    it 'defaults to false' do
      expect(config).not_to be_debug
    end

    it 'returns true if debug is se to true' do
      config.debug = true

      expect(config).to be_debug
    end

    it 'returns false if debug is set to false' do
      config.debug = false

      expect(config).not_to be_debug
    end
  end
end

# frozen_string_literal: true

RSpec.describe Youlend::PathSanitizer do
  describe '.sanitize' do
    it 'removes any leading /' do
      expect(described_class.sanitize('/test')).not_to start_with('/')
    end

    it 'adds an ending /' do
      expect(described_class.sanitize('test')).to end_with('/')
    end

    it 'does not add an ending / if it already exists' do
      expect(described_class.sanitize('test/')).to eq('test/')
    end

    it 'does not mess with / in the middle of the path' do
      expect(described_class.sanitize('/this/is/a/test/')).to eq('this/is/a/test/')
    end
  end
end

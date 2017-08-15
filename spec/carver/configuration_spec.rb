# frozen_string_literal: true
describe Carver::Configuration do
  describe '.initialize' do
    subject { described_class.new }

    it 'sets default configuration values' do
      expect(subject.instance_variable_get(:@targets)).to eq(%w(controllers jobs))
      expect(subject.instance_variable_get(:@log_results)).to eq(false)
      expect(subject.instance_variable_get(:@output_file)).to eq('./carver/results.json')
    end
  end
end

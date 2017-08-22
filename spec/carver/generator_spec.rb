# frozen_string_literal: true
describe Carver::Generator do
  describe '.create_html_from' do
    subject { described_class.new(results, output_file).create_html }
    let(:output_file) { './profiling/results.html' }
    let(:results) { {
        'Api::V1::ExamplesController#index' => [
            { 'total_allocated_memsize' => 21000, 'total_retained_memsize' => 1500 },
            { 'total_allocated_memsize' => 22150, 'total_retained_memsize' => 1450 }
        ],
        'Api::V1::HerpController#index' => [
            { 'total_allocated_memsize' => 21000, 'total_retained_memsize' => 1500 },
            { 'total_allocated_memsize' => 22150, 'total_retained_memsize' => 1450 }
        ],
        'ExamplesJob#perform' => [
            { 'total_allocated_memsize' => 5700, 'total_retained_memsize' => 800 }
        ] } }

    it 'creates html from results' do
      expect(File).to receive(:open).with(output_file, 'w')
      subject
    end
  end
end

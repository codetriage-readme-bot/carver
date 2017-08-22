# frozen_string_literal: true
describe Carver::Generator do
  let(:output_file) { './profiling/results.html' }
  let(:results) { {
      'Api::V1::ExamplesController#index' => [
          { total_allocated_memsize: 21000, total_retained_memsize: 1500 },
          { total_allocated_memsize: 22150, total_retained_memsize: 1450 }
      ],
      'Api::V1::HerpController#index' => [
          { total_allocated_memsize: 33000, total_retained_memsize: 1500 },
          { total_allocated_memsize: 25000, total_retained_memsize: 1450 }
      ],
      'ExamplesJob#perform' => [
          { total_allocated_memsize: 5700, total_retained_memsize: 800 }
      ] } }

  describe '.initialize' do
    subject { described_class.new(results, output_file) }

    it 'orders results' do
      expect(subject.instance_variable_get(:@controller_results).keys).to eq(%w(Api::V1::HerpController#index Api::V1::ExamplesController#index))

      subject.instance_variable_get(:@controller_results).each do |_, value|
        expect(value.first[:total_allocated_memsize]).to be > value.second[:total_allocated_memsize]
      end
    end
  end

  describe '#create_html' do
    subject { described_class.new(results, output_file).create_html }

    it 'creates html from results' do
      expect(File).to receive(:open).with(output_file, 'w')
      subject
    end
  end
end

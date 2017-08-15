# frozen_string_literal: true
describe Carver::Presenter do
  describe '#log' do
    subject { described_class.new(results.new, path, action, parent).log }
    let(:path) { 'api/v1/examples' }
    let(:action) { 'index' }
    let(:parent) { 'ApplicationController' }
    let(:results) do
      Struct.new('ProfilerResults') do
        def total_allocated_memsize
          21000
        end

        def total_retained_memsize
          1500
        end
      end
    end

    it 'logs profiling results' do
      expect(Rails.logger).to receive(:info).with('[Carver] source=Api::V1::ExamplesController#index type=controller total_allocated_memsize=21000 total_retained_memsize=1500')
      subject
    end
  end
end

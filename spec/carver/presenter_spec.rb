# frozen_string_literal: true
describe Carver::Presenter do
  let!(:results) do
    return Struct.const_get('ProfilerResults') if Struct::const_defined?('ProfilerResults')

    Struct.new('ProfilerResults') do
      def total_allocated_memsize
        21000
      end

      def total_retained_memsize
        1500
      end
    end
  end

  describe '#log' do
    subject { described_class.new(results.new, path, action, parent).log }

    context 'when profiled entity is a controller' do
      let(:path) { 'api/v1/examples' }
      let(:action) { 'index' }
      let(:parent) { 'ApplicationController' }

      it 'logs profiling results' do
        expect(Rails.logger).to receive(:info).with('[Carver] source=Api::V1::ExamplesController#index type=controller total_allocated_memsize=21000 total_retained_memsize=1500')
        subject
      end
    end

    context 'when profiled entity is a job' do
      let(:path) { 'ExampleJob' }
      let(:action) { 'perform' }
      let(:parent) { 'ApplicationJob' }

      it 'logs profiling results' do
        expect(Rails.logger).to receive(:info).with('[Carver] source=ExampleJob#perform type=job total_allocated_memsize=21000 total_retained_memsize=1500')
        subject
      end
    end
  end
end

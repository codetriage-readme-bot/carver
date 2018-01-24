# frozen_string_literal: true
describe Carver::Profiler do
  class ExamplesController < ActionController::Base
    def index
      something = 5 + 2*10
      something**2
    end
  end

  before { Carver.configuration.enabled = true }

  describe '.profile_memory' do
    subject { described_class.profile_memory(path, action, parent) { ExamplesController.new.index } }
    let(:path) { 'api/v1/examples' }
    let(:action) { 'index' }
    let(:parent) { 'ApplicationController' }

    it 'profiles method and logs results' do
      Carver.configuration.log_results = true
      expect(Rails.logger).to receive(:info).with('[Carver] source=Api::V1::ExamplesController#index type=controller total_allocated_memsize=0.00034 total_retained_memsize=0.00015')
      subject
    end

    it 'adds results to current report if enabled' do
      Carver.configuration.log_results = false
      Carver.clear_results
      subject
      expect(Carver.current_results).to eq({ 'Api::V1::ExamplesController#index' => [{ total_allocated_memsize: 0.00034, total_retained_memsize: 0.00015 }] })
    end
  end
end

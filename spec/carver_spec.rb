# frozen_string_literal: true
describe Carver do
  describe '.define_around_action' do
    subject { described_class.define_around_action }
    before { allow(Rails).to receive(:load).and_return(true) }

    context 'when ApplicationController is not defined' do
      let!(:klass) {  }
      it { expect { subject }.to raise_error('ApplicationController not defined') }
    end

    context 'when ApplicationController is defined' do
      let!(:klass) { class ApplicationController < ActionController::Base; end }

      it 'defines around_action with memory profiler' do
        subject
        around_filters = ApplicationController._process_action_callbacks.select { |f| f.kind == :around }.map(&:filter)
        expect(around_filters).to include(:profile_controller_actions)
      end
    end
  end

  describe '.define_around_perform' do
    subject { described_class.define_around_perform }
    before { allow(Rails).to receive(:load).and_return(true) }

    context 'when ApplicationJob is not defined' do
      let!(:klass) {  }
      it { expect { subject }.to raise_error('ApplicationJob not defined') }
    end

    context 'when ApplicationJob is defined' do
      let!(:klass) { class ApplicationJob < ActiveJob::Base; end }

      it 'defines around_perform with memory profiler' do
        subject
        around_filters = ApplicationJob._perform_callbacks.select { |f| f.kind == :around }.map(&:filter)
        expect(around_filters).to include(:profile_job_performs)
      end
    end
  end
end

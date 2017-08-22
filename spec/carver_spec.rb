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
        expect(around_filters).to_not be_empty
      end
    end
  end

  describe '.add_to_results' do
    before { described_class.clear_results }

    it 'creates initial array or appends results' do
      described_class.add_to_results(:key_1, { memory: 123 })
      expect(described_class.current_results[:key_1]).to eq([{ memory: 123 }])
      described_class.add_to_results(:key_1, { memory: 321 })
      expect(described_class.current_results[:key_1]).to eq([{ memory: 123 }, { memory: 321 }])
    end
  end

  describe '.clear_results' do
    subject { described_class.clear_results }
    before { described_class.clear_results }

    it 're-initializes the current results' do
      expect(described_class.current_results).to eq({})
      described_class.add_to_results(:key_1, { memory: 123 })
      expect(described_class.current_results[:key_1]).to eq([{ memory: 123 }])
      subject
      expect(described_class.current_results).to eq({})
    end
  end

  describe '.start' do
    subject { described_class.start }

    it 'enables carver' do
      Carver.configuration.enabled = false
      Carver.start
      expect(Carver.configuration.enabled).to be_truthy
    end
  end

  describe '.stop' do
    subject { described_class.stop }

    it 'disables carver' do
      Carver.configuration.enabled = true
      Carver.stop
      expect(Carver.configuration.enabled).to be_falsey
    end
  end
end

# frozen_string_literal: true

module Carver
  class Profiler
    def self.profile_memory(path, action, parent)
      report = MemoryProfiler.report do
        yield
      end

      presenter = Presenter.new(report, path, action, parent)
      presenter.log if Carver.configuration.log_results
      presenter.add_to_results if Carver.configuration.enabled
    end
  end
end

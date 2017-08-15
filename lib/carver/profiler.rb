# frozen_string_literal: true
module Carver
  class Profiler
    def self.profile_memory(path, action, parent)
      report = MemoryProfiler.report do
        yield
      end

      Presenter.new(report, path, action, parent).log if Carver.configuration.log_results
    end
  end
end

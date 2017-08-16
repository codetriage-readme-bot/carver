# frozen_string_literal: true
module Carver
  class Profiler
    def self.profile_memory(path, action, parent)
      report = MemoryProfiler.report do
        yield
      end

      if Carver.configuration.enabled
        presenter = Presenter.new(report, path, action, parent)
        presenter.log if Carver.configuration.log_results
        presenter.add_to_results
      end
    end
  end
end

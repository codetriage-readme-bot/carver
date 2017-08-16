# frozen_string_literal: true
module Carver
  class Configuration
    attr_accessor :targets, :log_results, :output_file, :enabled

    def initialize
      @targets = %w(controllers jobs).freeze
      @log_results = false
      @output_file = './profiling/results.json'
      @enabled = Rails.env.test?
    end
  end
end

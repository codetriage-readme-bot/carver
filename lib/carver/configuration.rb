# frozen_string_literal: true
module Carver
  class Configuration
    attr_accessor :targets, :log_results, :output_file

    def initialize
      @targets = %w(controllers jobs).freeze
      @log_results = false
      @output_file = './carver/results.json'
    end
  end
end

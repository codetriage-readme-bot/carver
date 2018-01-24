# frozen_string_literal: true

module Carver
  class Configuration
    attr_accessor :log_results, :output_file, :enabled, :generate_html, :specific_targets
    attr_writer :targets

    def initialize
      @targets = %w[controllers jobs].freeze
      @log_results = false
      @output_file = './profiling/results.json'
      @enabled = Rails.env.test?
      @generate_html = true
      @specific_targets = nil
    end

    def targets
      @targets || %w[]
    end
  end
end

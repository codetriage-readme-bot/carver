# frozen_string_literal: true
require 'erb'

module Carver
  class Generator
    def initialize(results, output_path)
      @controller_results = results.select { |item| item.include?('Controller') }
      @job_results = results.select { |item| item.include?('Job') }
      @output_path = output_path
    end

    def create_html
      template = File.read("#{File.expand_path('..', __FILE__)}/templates/results.html.erb")
      html = ERB.new(template).result(binding)
      File.open(@output_path, 'w') { |f| f.write(html) }
    end
  end
end

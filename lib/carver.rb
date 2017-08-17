# frozen_string_literal: true
require 'memory_profiler'
require 'carver/version'
require 'carver/profiler'
require 'carver/configuration'
require 'carver/presenter'

module Carver
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.current_results
    @current_results ||= {}
  end

  def self.add_to_results(key, results)
    if current_results[key].nil?
      current_results[key] = [results]
    else
      current_results[key] << results
    end
  end

  def self.clear_results
    @current_results = {}
  end

  def self.start
    configuration.enabled = true
  end

  def self.stop
    configuration.enabled = false
  end

  def self.define_around_action
    Rails.send(:load, "#{Rails.root}/app/controllers/application_controller.rb")

    ApplicationController.class_eval do
      around_action :profile_controller_actions do
        Carver::Profiler.profile_memory(controller_path, action_name, 'ApplicationController') do
          yield
        end
      end
    end
  rescue LoadError, NameError
    raise 'ApplicationController not defined'
  end

  def self.define_around_perform
    Rails.send(:load, "#{Rails.root}/app/jobs/application_job.rb")

    ApplicationJob.class_eval do
      around_perform :profile_job_performs do |job|
        Carver::Profiler.profile_memory(job.name, 'perform', 'ApplicationJob') do
          yield
        end
      end
    end
  rescue LoadError, NameError
    raise 'ApplicationJob not defined'
  end

  ActiveSupport.on_load(:after_initialize, yield: true) do
    Carver.define_around_action if Carver.configuration.targets.include?('controllers')
    Carver.define_around_perform if Carver.configuration.targets.include?('jobs')
  end

  at_exit do
    if configuration.output_file && !current_results.empty?
      dir_struct = configuration.output_file.split('/')
      dir = dir_struct[0...dir_struct.size - 1].join('/')
      Dir.mkdir(dir) unless File.directory?(dir)
      File.open(configuration.output_file, 'w') { |f| f.write(current_results.to_json) }
    end
  end
end

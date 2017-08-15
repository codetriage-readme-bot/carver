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
end

# frozen_string_literal: true
require 'bundler/setup'
require 'byebug'
require 'simplecov'
require 'rails/all'
require 'carver'

SimpleCov.start
Rails.logger = STDOUT

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# frozen_string_literal: true
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carver/version'

Gem::Specification.new do |spec|
  spec.name          = 'carver'
  spec.version       = Carver::VERSION
  spec.authors       = ['Vinicius Stock']
  spec.email         = ['vinicius.stock@outlook.com']

  spec.summary       = %q{A memory profiler for Rails controllers and jobs}
  spec.description   = %q{This gem profiles memory consumption in controllers and jobs and allows logging this reports for further insights}
  spec.homepage      = 'https://github.com/vinistock/carver'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'memory_profiler', '~> 0.9'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'simplecov', '~> 0.14'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
  spec.add_development_dependency 'byebug', '~> 9.0'
  spec.add_development_dependency 'rails', '>= 4.0'
end

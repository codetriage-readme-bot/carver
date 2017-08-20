# Carver

[![Code Climate](https://codeclimate.com/github/vinistock/carver/badges/gpa.svg)](https://codeclimate.com/github/vinistock/carver/badges/gpa.svg) [![Build Status](https://travis-ci.org/vinistock/carver.svg?branch=master)](https://travis-ci.org/vinistock/carver) [![Test Coverage](https://codeclimate.com/github/vinistock/carver/badges/coverage.svg)](https://codeclimate.com/github/vinistock/carver/coverage) [![Gem Version](https://badge.fury.io/rb/carver.svg)](https://badge.fury.io/rb/carver)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'carver'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carver

## Usage

Carver profiles the memory usage of your controllers' actions and your jobs' performs.

Simply adding the gem will create hooks on your ApplicationController and your ApplicationJob that will profile the memory usage.

The profiling itself is executed by the [memory_profiler] gem.

## Configuring

The configurable parameters with their explanations and defaults are listed down below.

```ruby
Carver.configure do |config|
  config.targets = %w(controllers jobs)           # Picks the profiled entities
  config.log_results = false                      # Prints results to Rails.log
  config.enabled = Rails.env.test?                # Complete full profile for test environment
  config.output_file = './profiling/results.json' # JSON file path to write results to
end
```

The following commands can be used to get the most out of Carver.

```ruby
Carver.start           # Sets enabled to true and start saving profiling results
Carver.stop            # Sets enabled to false and stops saving profiling results (does not erase them)
Carver.current_results # Retrieve current profiling results as a hash
Carver.clear_results   # Re-initializes the current results to an empty hash. 
                       # If you have profiling enabled in a non-test environment, 
                       # it is recommended to clear the results regularly
```

If you wish to profile only specific controllers or specific jobs, first remove the entity from the "targets" configuration and then register the around filters yourself as below.
```ruby
# Carver configuration using no targets
Carver.configure do |config|
  config.targets = %w()
end

# Example controller with manual definition of the memory profiler filter
class ExamplesController < ApplicationController
  around_action :profile_controller_actions, only: %i(index) do
    Carver::Profiler.profile_memory(controller_path, action_name, 'ApplicationController') do
      yield
    end
  end
  
  def index
  end
  
  def show
  end
end

# Example job with manual definition of the memory profiler filter
class ExampleJob < ApplicationJob
  around_perform :profile_job_performs do |job|
    Carver::Profiler.profile_memory(job.name, 'perform', 'ApplicationJob') do
      yield
    end
  end
  
  def perform
  end
end
```

At the end of your test suite execution, given that carver is enabled, results will be written to profiling/results.json such as the example below.

```json
{
  "Api::V1::ExamplesController#index": [
    { "total_allocated_memsize": 21000, "total_retained_memsize": 1500 },
    { "total_allocated_memsize": 22150, "total_retained_memsize": 1450 }
  ],
  "ExamplesJob#perform": [
    { "total_allocated_memsize": 5700, "total_retained_memsize": 800 }
  ]
}
```

## Contributing

Please refer to this simple [guideline].

[memory_profiler]: https://github.com/SamSaffron/memory_profiler
[guideline]: https://github.com/vinistock/carver/blob/master/CONTRIBUTING.md

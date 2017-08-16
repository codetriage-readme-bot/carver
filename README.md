# Carver

[![Code Climate](https://codeclimate.com/github/vinistock/carver/badges/gpa.svg)](https://codeclimate.com/github/vinistock/carver/badges/gpa.svg) [![Build Status](https://travis-ci.org/vinistock/carver.svg?branch=master)](https://travis-ci.org/vinistock/carver) [![Test Coverage](https://codeclimate.com/github/vinistock/carver/badges/coverage.svg)](https://codeclimate.com/github/vinistock/carver/coverage)

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

1. Fork it ( https://github.com/vinistock/carver/fork )
2. Create your feature branch (git checkout -b my-feature)
3. Commit your changes (git commit -am 'Add my feature')
4. Push to the branch (git push origin my-feature)
5. Create a new Pull Request

[memory_profiler]: https://github.com/SamSaffron/memory_profiler

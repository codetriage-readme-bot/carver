# frozen_string_literal: true

module Carver
  class Presenter
    BYTES_TO_MB_CONSTANT = 1024**2

    def initialize(results, path, action, parent)
      @results = results
      @path = path
      @action = action
      @parent = parent
    end

    def log
      Rails.logger.info(
          "[Carver] source=#{entry_info[:name]} type=#{entry_info[:type]} total_allocated_memsize=#{allocated_memory} " \
          "total_retained_memsize=#{retained_memory}"
      )
    end

    def add_to_results
      Carver.add_to_results(
          entry_info[:name],
          { total_allocated_memsize: allocated_memory, total_retained_memsize: retained_memory }.freeze
      )
    end

    private

    def allocated_memory
      (@results.total_allocated_memsize.to_f / BYTES_TO_MB_CONSTANT).round(5)
    end

    def retained_memory
      (@results.total_retained_memsize.to_f / BYTES_TO_MB_CONSTANT).round(5)
    end

    def controller?
      @parent.downcase.include?('controller')
    end

    def entry_info
      @entry ||= entry
    end

    def entry
      if controller?
        { name: "#{@path.split('/').map(&:titleize).join('::').delete(' ')}Controller##{@action}", type: 'controller' }.freeze
      else
        { name: "#{@path}##{@action}", type: 'job' }.freeze
      end
    end
  end
end

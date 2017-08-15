# frozen_string_literal: true
module Carver
  class Presenter
    def initialize(results, path, action, parent)
      @results = results
      @path = path
      @action = action
      @parent = parent
    end

    def log
      Rails.logger.info(
          "[Carver] source=#{entry[:name]} type=#{entry[:type]} total_allocated_memsize=#{@results.total_allocated_memsize} " \
          "total_retained_memsize=#{@results.total_retained_memsize}"
      )
    end

    private

    def is_controller?
      @parent.downcase.include?('controller')
    end

    def entry
      if is_controller?
        { name: "#{@path.split('/').map(&:titleize).join('::').delete(' ')}Controller##{@action}", type: 'controller' }.freeze
      else
        { name: "#{@path}##{@action}", type: 'job' }.freeze
      end
    end
  end
end

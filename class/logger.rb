# frozen_string_literal: true

require 'rubygems'

# Class to write logs
class TimeLogger
  def initialize
    @start_time = Time.now.to_i
  end

  def print_time_ellapsed(log_extensions = null)
    end_time = Time.now.to_i
    time_ellapsed = end_time - @start_time

    log = log_extensions
    log = log.join('::') if log.is_a?(Array)

    puts format('%s: took %d seconds', log, time_ellapsed)
  end
end

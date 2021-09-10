# frozen_string_literal: true

require 'rubygems'

# Class to write logs
class TimeLogger
  def initialize
    @start_time = Time.now.to_i
  end

  def print_time_ellapsed(log_extensions = nil)
    end_time = Time.now.to_i
    time_ellapsed = end_time - @start_time

    log = ""
    if !log_extensions.nil? && !log_extensions.empty?
      log = log_extensions
      log = log.join('::') if log.is_a?(Array)
      log += ': '
    end

    puts format('%<log>stook %<time_ellapsed>d seconds', log: log, time_ellapsed: time_ellapsed)
  end
end

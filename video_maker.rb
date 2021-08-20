# frozen_string_literal: true

require 'rubygems'
require 'optparse'
require './class/imagewriter'
require './class/videowriter'
require './class/logger'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: crawler.rb [options]'

  opts.on('-l', '--length STRING', 'Length of video (format HH:mm:ss)') do |length|
    options[:length] = length
  end
  opts.on('-d', '--direction STRING', 'Length of video (format HH:mm:ss)') do |direction|
    options[:direction] = direction
  end
end.parse!

end_time = options[:length]

throw 'no length specified' unless end_time

puts format('making movie that is %s long', end_time)
time_logger = TimeLogger.new
image_writer = ImageWriter.new(options, time_logger)
video_writer = VideoWriter.new(time_logger)

image_writer.make_images

gif_file_name = image_writer.gif_file_name

# create video
video_writer.make_movie(gif_file_name)
image_writer.delete_images

time_logger.print_time_ellapsed('total')

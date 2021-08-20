# frozen_string_literal: true

require 'rubygems'
require 'fileutils'
require 'streamio-ffmpeg'

# Class to create video from gif
class VideoWriter
  def initialize(time_logger)
    @video_directory = './videos/'
    @time_logger = time_logger
    FileUtils.mkdir_p(@video_directory) unless File.exist?(@video_directory)
  end

  def make_movie(gif_file_name)
    puts 'creating movie'
    movie_name_flv = format('%smovie.flv', @video_directory)
    _make_movie(movie_name_flv, gif_file_name)

    movie_name_mp4 = format('%smovie.mp4', @video_directory)
    _make_movie(movie_name_mp4, movie_name_flv)

    _delete_file(movie_name_flv)
    @time_logger.printTimeEllapsed('movie')
  end

  private

  def _make_movie(movie_name, input_name)
    FileUtils.touch(movie_name)
    begin
      FFMPEG::Movie.new(input_name).transcode(movie_name)
    rescue StandardError
      throw StandardError
    end
  end

  def _delete_file(file_name)
    File.delete(file_name) if File.exist?(file_name)
  end
end

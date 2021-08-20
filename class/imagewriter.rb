# frozen_string_literal: true

require 'rubygems'
require 'rmagick'
require 'fileutils'

# Class make gif
class ImageWriter
  def initialize(options, time_logger)
    @end_time = options[:length]
    @direction = options[:direction]
    @color = 'black'
    @image_directory = './images/'
    @gif_file_name = format('%sgif.gif', @image_directory)
    @time_logger = time_logger

    @direction_options = {
      up: 'up',
      down: 'down'
    }

    @gif = Magick::ImageList.new
    build_now_later
    FileUtils.mkdir_p(@image_directory) unless File.exist?(@image_directory)
  end

  def make_images
    if @direction == @direction_options[:down]
      _make_images_count_down
    elsif @direction == @direction_options[:up]
      _make_images_count_up
    else
      throw format('Invalid direction. Allowed options: %s', @direction_options.values.join(', '))
    end

    @time_logger.printTimeEllapsed('image')
    _write_gif
  end

  attr_reader :gif_file_name

  def delete_images
    FileUtils.remove_dir(@image_directory) if File.directory?(@image_directory)
  end

  private

  def _write_gif
    @gif.write(@gif_file_name)
  end

  def build_now_later
    split_end_time = @end_time.split(':')
    end_hour = split_end_time[0].to_i
    end_minute = split_end_time[1].to_i
    end_second = split_end_time[2].to_i
    @now = Time.now
    @later = @now + (end_hour * 60 * 60)
    @later += (end_minute * 60)
    @later += end_second
  end

  def _make_images_count_up
    diff = @later - @now
    (0..diff.to_i).each do |second|
      _make_minute_up(second)
    end
  end

  def _make_images_count_down
    until @now.to_i == @later.to_i
      _make_minute_down(@now, @later)

      # remove a second to later
      @later -= 1
    end
    _make_minute_down(@now, @later)
  end

  def _make_minute_down(time1, time2)
    diff = time2 - time1
    current_time = _seconds_to_hms(diff)
    _make_image(current_time, @color)
  end

  def _make_minute_up(second)
    current_time = _seconds_to_hms(second)
    _make_image(current_time, @color)
  end

  def _make_image(timestamp, background_color, delay = 100)
    puts format('[%s] start', timestamp)
    file_name = format('%simage-%s.png', @image_directory, timestamp)
    canvas = Magick::Image.new(1920, 1080) { self.background_color = background_color }
    gc.draw(_draw_image(timestamp))
    canvas.write(file_name)
    puts format('[%s] image created', timestamp)

    @gif.read(file_name)
    @gif.delay = delay
    puts format('[%s] added to gif', timestamp)
    puts format('[%s] end', timestamp)
  end

  def _draw_image(timestamp)
    gc = Magick::Draw.new
    gc.pointsize(450)
    gc.fill('white')
    gc.text(75, 700, timestamp)
    gc.text_align(Magick::CenterAlign.to_i)
    gc.gravity(Magick::CenterGravity.to_i)
    # todo
    # gc.font_family('serif')

    gc
  end

  def _seconds_to_hms(sec)
    # https://stackoverflow.com/a/28909294
    format('%02d:%02d:%02d', sec / 3600, sec / 60 % 60, sec % 60)
  end
end

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
    @gif_file_name = format('%<dir>sgif.gif', dir: @image_directory)
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
      direction_options = @direction_options.values.join(', ')
      throw format('Invalid direction. Allowed options: %<options>s', options: direction_options)
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
    _make_image_and_gif(current_time)
  end

  def _make_minute_up(second)
    current_time = _seconds_to_hms(second)
    _make_image_and_gif(current_time)
  end

  def _make_image_and_gif(timestamp, delay = 100)
    file_name = format('%<dir>simage-%<timestamp>s.png', dir: @image_directory, timestamp: timestamp)
    _make_image(file_name, timestamp)
    _add_to_gif(file_name, delay, timestamp)
    puts format('[%<timestamp>s] end', timestamp: timestamp)
  end

  def _make_image(file_name, timestamp)
    puts format('[%s] start', timestamp)
    canvas = Magick::Image.new(1920, 1080) { self.background_color = @color }
    gc.draw(_draw_image(timestamp))
    canvas.write(file_name)
    puts format('[%<timestamp>s] image created', timestamp: timestamp)
  end

  def _add_to_gif(file_name, delay, timestamp)
    @gif.read(file_name)
    @gif.delay = delay
    puts format('[%<timestamp>s] added to gif', timestamp: timestamp)
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
    format('%<hour>02d:%<min>02d:%<sec>02d', hour: sec / 3600, min: sec / 60 % 60, sec: sec % 60)
  end
end

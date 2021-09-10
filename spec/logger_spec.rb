# frozen_string_literal: true

require './class/logger'

RSpec.describe TimeLogger, 'TimeLogger' do
  it 'prints logs without extension' do
    logger = TimeLogger.new
    expect do
      logger.print_time_ellapsed
    end.to output(/^took \d seconds$/).to_stdout
  end
  describe TimeLogger, 'prints logs with extension' do
    it 'string' do
      string = 'some string'
      logger = TimeLogger.new
      expect do
        logger.print_time_ellapsed(string)
      end.to output(/^#{string}: took \d seconds$/).to_stdout
    end
    it 'array' do
      array = %w[some string]
      logger = TimeLogger.new
      expect do
        logger.print_time_ellapsed(array)
      end.to output(/^some::string: took \d seconds$/).to_stdout
    end
  end
end

require_relative 'writer_base'


module Converter
  class ArrayWriter < WriterBase
    private
    def initialize(filename, separator, terminator = "\r\n")
      @filename = filename
      @file_handle = nil
      @separator = separator
      @terminator = terminator
    end

    public
    def open
      @file_handle = File.new(@filename, "w") if @file_handle.nil?
    end
    def write(data)
      @file_handle.write data.join(@separator) + @terminator.to_s
    end
    def close
      @file_handle.close if !@file_handle.nil?
    end
  end
end

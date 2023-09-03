module Converter
  class SimpleLineReader
    def initialize(filename)
      @filename = filename
      @lines = File.read(@filename).lines
    end
    def each(&block)
      @lines.each(&block)
    end
  end
end

module Converter
  class TabDelimited
    def initialize(reader)
      @reader = reader
    end
    def convert
      rows = []
      @reader.each do |line|
        rows << line.split("\t")
      end
      rows
    end
  end
end

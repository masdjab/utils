module Converter
  class Column
    attr_reader :name, :offset, :length, :type, :num_len, :dec_len
    def initialize(name, offset, length, type, num_len, dec_len)
      @name = name
      @offset = offset
      @length = length
      @type = type
      @num_len = num_len
      @dec_len = dec_len
    end
  end
end

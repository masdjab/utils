module Converter
  class FixedWidth
    private
    def initialize(reader, writer, columns, options = {})
      @reader = reader
      @writer = writer
      @columns = columns
      @options = options
    end
    def strip_content?
      @options[:strip_content]
    end
    def line_comment_markers
      @options[:line_comment_markers] || []
    end
    def comment_line?(line)
      return false if line.empty? || line_comment_markers.empty?
      !line_comment_markers.select{|m|line.index(m) == 0}.empty?
    end
    def skip_rows
      @options[:skip_rows] || 0
    end
    def format(value)
      !value.nil? && strip_content? ? value.strip : value
    end
    
    public
    def convert
      input_rownum = 0
      output_rownum = 0
      @writer.open
      @writer.write @columns.map{|c|c.name}
      @reader.each do |ln|
        if !comment_line?(ln)
          if !(ln = ln.chomp.strip).empty?
            input_rownum += 1
            if input_rownum > skip_rows
              output_rownum += 1
              cells = @columns.map{|c|format(ln[c.offset, c.length])}
              @writer.write cells
              puts cells.inspect if output_rownum <= 10
            end
          end
        end
      end
      @writer.close
    end
  end
end

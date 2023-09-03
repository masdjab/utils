module Converter
  class ColumnDefParser
    private
    def initialize(layout_file, header_map)
      # header keys: :name, :start, :end, :length, :type, :dec1, :dec2
      @layout_file = layout_file
      @header_map = header_map
    end

    public
    def parse
      header_keys = @header_map.keys
      missing_keys = [:name, :start] - header_keys
      missing_keys = missing_keys + [:end, :length] if !header_keys.include?(:end) && !header_keys.include?(:length)
      return StandardError.new("Missing header map keys: #{missing_keys.inspect}") if !missing_keys.empty?

      layout_data = File.read(@layout_file)
      layout_array = layout_data.lines.map{|x|x.chomp}.map{|x|x.split("\t")}.select{|x|!x.empty?}
      head_line = layout_array.shift
      head_index = @header_map.keys.inject({}){|h,k|h[k] = head_line.index(@header_map[k]); h}

      columns = []
      layout_array.each do |ln|
        begin
          name = ln[head_index[:name]]
          col_start = (Integer(ln[head_index[:start]]) rescue 0) - 1

          if !head_index[:length].nil?
            col_length = Integer(ln[head_index[:length]])
          elsif !head_index[:end].nil?
            col_length = Integer(ln[head_index[:end]] - ln[head_index[:start]])
          end
          
          type = head_index[:type] ? ln[head_index[:type]] : nil
          num_size = head_index[:dec1] ? (Integer(ln[head_index[:dec1]]) rescue nil) : nil
          dec_size = head_index[:dec2] ? (Integer(ln[head_index[:dec2]]) rescue nil) : nil

          columns << Converter::Column.new(name, col_start, col_length, type, num_size, dec_size)
        rescue StandardError => e
          puts "Error when parsing columns: #{e}"
          return e
        end
      end

      puts "Column Names: #{columns.map{|c|"'#{c.name}'"}.join(", ")}"

      columns
    end
  end
end

module Converter
  class ColumnDefParser
    private
    def initialize(layout_file, header_map)
      @layout_file = layout_file
      @header_map = header_map
    end

    public
    def parse
      layout_data = File.read(@layout_file)
      layout_array = layout_data.lines.map{|x|x.chomp}.map{|x|x.split("\t")}.select{|x|!x.empty?}
      head_line = layout_array.shift
      head_index = @header_map.keys.inject({}){|h,k|h[k] = head_line.index(@header_map[k]); h}

      columns = []
      layout_array.each do |ln|
        begin
          columns << Converter::Column.new(
            ln[head_index[:name]], 
            Integer(ln[head_index[:start]]) - 1, 
            Integer(ln[head_index[:length]]), 
            ln[head_index[:type]], 
            (Integer(ln[head_index[:dec1]]) rescue nil), 
            (Integer(ln[head_index[:dec2]]) rescue nil), 
          )
        rescue StandardError => e
          puts "Error parsing #{ln.inspect}"
          raise e
        end
      end

      puts "Column Names: #{columns.map{|c|"'#{c.name}'"}.join(", ")}"

      columns
    end
  end
end

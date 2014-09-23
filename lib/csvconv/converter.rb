module CSVConv
  # Converter from CSV
  class Converter
    def initialize(format, options)
      @format = format
      @sep = options[:sep] || ','
      @header = options[:header]
      @text = options[:ti] || nil
    end

    def convert(input)
      @header ||= Parser.read_header(input, @sep)
      hash_array = []
      while (line = input.gets)
        hash_line = Parser.parse_line(line, @header, @sep)
        if @text && hash_line[@text] then
          hash_line[@text] = hash_line[@text].inspect
        end
        
        hash_array << hash_line   
      end
      resultYaml = Formatter.send(@format, hash_array)
      resultYaml = resultYaml.gsub("! \'\"", ">\n    ")
      resultYaml = resultYaml.gsub("\"\'", "")
      return resultYaml
    end

    def convert_stream(input, output)
      @header ||= Parser.read_header(input, @sep)
      while (line = input.gets)
        hash = Parser.parse_line(line, @header, @sep)
        output.puts Formatter.send(@format, [hash])
      end
    end
  end
end

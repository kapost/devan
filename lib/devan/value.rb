module Devan
  class Value < UploadIO
    def initialize(value, type=nil)
      type ||= 'string'
      type = "jcr-value/#{type}" unless type.include?('/')
      
      if value.is_a?(String) or value.is_a?(Array)
        @value = value
      else
        @value = ''
      end
      
      super(StringIO.new(to_s), type.downcase, nil)
    end

    def to_part(name, boundary)
      if is_array?
        parts = @value.map do |value|
          arr = []
          arr << Part.new(boundary, name, value.to_s, { 'Content-Type' => content_type })
          arr << Parts::EpiloguePart.new(boundary)
          arr
        end.flatten

        parts.pop
        parts
      else
        Part.new(boundary, name, to_s, { 'Content-Type' => content_type })
      end
    end

    def is_string?
      content_type == 'jcr-value/string'
    end

    def is_array?
      @value.is_a?(Array)
    end

    def to_s
      @value.to_s
    end
  end
end

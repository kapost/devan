module Devan
  class Value < UploadIO
    def initialize(value, type=nil)
      type ||= 'string'

      if value.is_a?(Array)
        @value = value.join("\n")
      elsif value.is_a?(Hash)
        @value = value.values.join("\n")
      else
        @value = value.to_s
      end

      super(StringIO.new(to_s), "jcr-value/#{type.downcase}", nil)
    end

    def to_part(name, boundary)
      Part.new(boundary, name, to_s, { 'Content-Type' => content_type })
    end

    def to_s
      @value
    end
  end
end

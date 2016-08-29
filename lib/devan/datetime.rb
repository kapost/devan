require 'time'

module Devan
  class DateTime < UploadIO
    JCR_DATE_MIME_TYPE = 'jcr-value/date'

    class << self
      def now
        DateTime.new(Time.now)
      end
    end

    def initialize(input)
      @_time = case input
      when Time
        input
      when String
        Time.parse(input) rescue Time.at(input.to_i)
      when Numeric
        Time.at(input)
      else
        raise ArgumentError, "Invalid #{input} DateTime"
      end

      super(StringIO.new(to_s), JCR_DATE_MIME_TYPE, nil)
    end

    def to_part(name, boundary)
      Part.new(boundary, name, to_s, { 'Content-Type' => content_type })
    end

    def to_s
      @_formatted ||= @_time.utc.iso8601.sub(/Z$/, '.000+00:00')
    end
  end
end

module Devan
  class Error < StandardError
    TAGS = %w(dcr:message h1 pre h2 title).freeze

    attr_reader :code

    def initialize(message, code=0)
      @code = code
      super(parse_error_message(message))
    end

    protected

    def parse_error_message(response)
      m = response.match(/<div id="Message">\s*(.*?)\s*<\/div>/)
      return m[1] if m and m[1].to_s.size > 0

      TAGS.each do |tag|
        msg = parse_error_from_tag(response, tag)
        return msg if msg
      end

      'Unexpected error'
    end

    def parse_error_from_tag(response, tag)
      m = response.match(/<#{tag}>\s*(.*?)\s*<\/#{tag}>/)
      m[1] if m && m[1].to_s.size > 0
    end
  end
end

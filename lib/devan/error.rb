module Devan
  class Error < StandardError
    attr_reader :code

    def initialize(message, code=0)
      @code = code
      super(parse_error_message(message))
    end

    protected

    def parse_error_message(response)
      tags = ['h1', 'dcr:message'].join('|')

      m = response.match(/(<(#{tags})>(.*?)<\/(#{tags})>)/)
      if m and m[2].to_s.size > 0
        m[2]
      else
        response
      end
    end
  end
end
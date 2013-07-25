module Devan
  class Error < StandardError
    attr_reader :code

    def initialize(message, code=0)
      @code = code
      super(parse_error_message(message))
    end

    protected

    def parse_error_message(response)
      m = response.match(/<div id="Message">\s*(.*?)\s*<\/div>/)
      if m and m[1].to_s.size > 0
        m[1]
      else
        tags = ['h1', 'dcr:message'].join('|')
        m = response.match(/(<(#{tags})>\s*(.*?)\s*<\/(#{tags})>)/)
        if m and m[3].to_s.size > 0
          m[3]
        else
          response
        end
      end
    end
  end
end

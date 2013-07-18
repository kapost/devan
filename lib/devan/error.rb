module Devan
  class Error < StandardError
    attr_reader :code

    def initialize(message, code=0)
      @code = code
      super(message)
    end
  end
end

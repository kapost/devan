module Devan
  class Binary < UploadIO
    JCR_BINARY_MIME_TYPE = 'jcr-value/binary'

    def initialize(io, filename=nil)
      super((io.is_a?(String) ? open(io) : io), JCR_BINARY_MIME_TYPE, filename)
    end
  end
end

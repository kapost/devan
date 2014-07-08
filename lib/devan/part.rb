module Devan
  class Part < Parts::ParamPart
    def initialize(*args)
      @part = build_part(*args)
      @io = StringIO.new(@part)
    end

    def build_part(boundary, name, value, headers={})
      part = ''
      part << "--#{boundary}\r\n"
      part << "Content-Disposition: form-data; name=\"#{name}\"\r\n"

      headers.each do |k, v|
        part << "#{k}: #{v}\r\n"
      end

      part << "\r\n"
      part << "#{value}\r\n"
    end
  end
end

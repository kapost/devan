require 'httparty'
require 'httmultiparty'
require 'json'
require 'cgi'
require 'uri'
require 'time'

require 'devan/version'
require 'devan/error'
require 'devan/binary'
require 'devan/datetime'
require 'devan/credentials'
require 'devan/part'
require 'devan/client'
require 'devan/node'
require 'devan/repository'

# BEGIN HACK, HACK, HACK, HACK
# FIXME: find a better way to handle this :)
module HTTMultiParty::Multipartable
  def body=(value)
    @body_parts = Array(value).map do |(k, v)| 
      if v.respond_to?(:to_part)
        v.to_part(k, boundary)
      else
        Parts::Part.new(boundary, k, v)
      end
    end

    @body_parts << Parts::EpiloguePart.new(boundary)
    set_headers_for_body
  end
end
# END HACK, HACK, HACK, HACK

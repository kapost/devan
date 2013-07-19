require 'httparty'
require 'json'
require 'cgi'
require 'uri'

module Devan
  class Client
    class HTTPClient
      include HTTParty
      headers 'User-Agent' => "Devan v#{VERSION} - Adobe CRX Client"
#      debug_output $stdout
    end

    attr_reader :url
    attr_reader :username
    attr_reader :password

    def initialize(url, username, password)
      @username = username
      @password = password

      set_url_and_path(url)
    end

    def activate(path)
      replicate(:cmd => 'Activate', :path => clean_path(path))
    end

    def deactive(path)
      replicate(:cmd => 'Deactivate', :path => clean_path(path))
    end

    def replicate(params)
      replicate_params = { :_charset => 'utf-8' }.merge!(params)
      !safe_response { http.post('/bin/replicate.json', :body => replicate_params) }.nil?
    end

    def delete(path)
      !safe_response { http.post(clean_path(path), :body => { ':operation' => 'delete' }) }.nil?
    end

    def fetch(path, depth=0)
      safe_response { http.get("#{path}.#{depth}.json") }
    end

    def store(path, properties={})
      !safe_response { http.post(path, :body => properties) }.nil?
    end

    protected

    def clean_path(path)
      path.gsub(@path, '')
    end

    def set_url_and_path(url)
      uri = URI.parse(url)
      @path = uri.path.dup
      uri.path = ''
      @url = uri.to_s
    end

    def safe_response
      response = yield

      raise Error.new(parse_error(response.body), response.code) unless response.code / 10 == 20

      if response.parsed_response.is_a? Hash
        response.parsed_response
      elsif response.body.to_s.strip[0] == '<'
        response.body
      elsif response.body.to_s.size > 0
        JSON.parse(response.body)
      else
        nil
      end
    rescue Timeout::Error => e
      raise Error.new('The operation has timed-out', 408)
    end

    def parse_error(response)
      m = response.match(/<h1>(.*?)<\/h1>/)
      if m and m[1].to_s.size > 0
        m[1]
      else
        response
      end
    end

    def http
      @http ||= begin
        client = self
        Class.new(HTTPClient) do |klass|
          klass.base_uri(client.url)
          klass.basic_auth(client.username, client.password)
        end
      end
    end
  end
end


require 'logger'
require 'faraday'
require 'faraday_middleware'

module Safelylaunch
  class HttpConnection
    attr_reader :api_token, :logger, :host, :connection

    def initialize(api_token:, logger: Logger.new(STDOUT), host: 'http://localhost:2300')
      @api_token = api_token
      @logger = logger
      @host = host

      @cache = HttpCache.new

      @connection = Faraday.new(url: host, request: { timeout: 10 }) do |conn|
        conn.response :json, content_type: %r{application/json}, parser_options: { symbolize_names: true }
        conn.response :logger, logger

        conn.adapter  Faraday.default_adapter
      end
    end

    def get(key)
      cached_data = @cache.get(key)
      
      if cached_data
        cached_data
      else
        response = connection.get('/api/v1/check', token: api_token, key: key)
        result = response.body
        @cache.put(key, result, 10)
        result
      end
    end
  end
end

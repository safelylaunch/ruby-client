require 'logger'
require 'faraday'
require 'faraday_middleware'

module Safelylaunch
  class HttpConnection
    attr_reader :api_token, :logger, :host, :connection, :cache_time

    def initialize(api_token:, logger: Logger.new(STDOUT), cache_time: nil, host: 'http://localhost:2300')
      @api_token = api_token
      @logger = logger
      @host = host
      @cache_time = cache_time

      @cache = HttpCache.new

      @connection = Faraday.new(url: host, request: { timeout: 10 }) do |conn|
        conn.response :json, content_type: %r{application/json}, parser_options: { symbolize_names: true }
        conn.response :logger, logger

        conn.adapter  Faraday.default_adapter
      end
    end

    def get(key)
      cache_time ? cached_check_toggle(key) : check_toggle(key)
    end

  private

    def cached_check_toggle(key)
      @cache.get(key) || @cache.put(key, check_toggle(key), cache_time)
    end

    def check_toggle(key)
      response = connection.get('/api/v1/check', token: api_token, key: key)
      response.body
    end
  end
end

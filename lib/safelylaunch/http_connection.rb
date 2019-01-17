require 'logger'
require 'faraday'
require 'faraday_middleware'

module Safelylaunch
  class HttpConnection
    attr_reader :api_token, :logger, :host, :connection, :cache_time

    DEFAILT_HOST = 'http://localhost:2300'

    def initialize(api_token:, **params)
      @api_token = api_token

      @logger = params[:logger] || Logger.new(STDOUT)
      @host = params[:host] || DEFAILT_HOST
      @cache_time = params[:cache_time]

      @cache = HttpCache.new
      @connection = create_connection(host, logger)
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

    def create_connection(host, logger)
      Faraday.new(url: host, request: { timeout: 10 }) do |conn|
        conn.response :json, content_type: %r{application/json}, parser_options: { symbolize_names: true }
        conn.response :logger, logger

        conn.adapter  Faraday.default_adapter
      end
    end
  end
end

# frozen_string_literal: true

module Safelylaunch
  class MockConnection
    attr_reader :api_token, :logger, :host

    DEFAILT_HOST = 'http://localhost:2300'

    def initialize(api_token:, **params)
      @api_token = api_token
      @logger = params[:logger] || Logger.new(STDOUT)
      @host = params[:host] || DEFAILT_HOST

      @toggles = params.fetch(:toggles, {})
    end

    def get(key)
      result = @toggles.fetch(key, false)
      { key: key, enable: result }
    end
  end
end

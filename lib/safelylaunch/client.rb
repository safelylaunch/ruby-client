module Safelylaunch
  class Client
    attr_reader :connection, :faraday_connection

    def initialize(connection)
      @connection = connection
      @faraday_connection = connection.call
    end

    def enable?(toggle_key)
      response = faraday_connection.get('/api/v1/check', token: @connection.api_token, key: toggle_key)
      response.body[:enable]
    end
  end
end

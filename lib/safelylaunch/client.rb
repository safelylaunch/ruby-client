# frozen_string_literal: true

module Safelylaunch
  class Client
    attr_reader :connection, :faraday_connection

    def initialize(connection)
      @connection = connection
    end

    def enable?(toggle_key)
      response = connection.get(toggle_key)
      response[:enable]
    end
  end
end

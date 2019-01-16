module Safelylaunch
  class MockConnection
    attr_reader :api_token, :logger, :host

    def initialize(api_token:, logger: Logger.new(STDOUT), host: 'http://localhost:2300')
      @api_token = api_token
      @logger = logger
      @host = host
    end

    def call
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('/api/v1/check') { |env| [200, {}, { key: "stream-toggle", enable: false }] }
      end

      Faraday.new(url: host, request: { timeout: 10 }) do |conn|
        conn.response :json, content_type: %r{application/json}, parser_options: { symbolize_names: true }
        conn.response :logger, logger

        conn.adapter  :test, stubs
      end
    end
  end
end

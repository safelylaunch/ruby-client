module Safelylaunch
  class MockConnection
    attr_reader :api_token, :logger, :host, :connection

    def initialize(api_token:, toggles: {}, logger: Logger.new(STDOUT), host: 'http://localhost:2300')
      @api_token = api_token
      @logger = logger
      @host = host
      @connection = nil
      @toggles = toggles
    end

    def get(key)
      result = @toggles.fetch(key, false)
      { key: key, enable: result }
    end
  end
end

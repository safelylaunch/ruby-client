require 'concurrent/map'

module Safelylaunch
  class HttpCache
    Value = Struct.new(:expired_time, :data)

    def initialize
      @hash = Concurrent::Map.new
    end

    def put(key, payload, expired_in)
      @hash.put_if_absent(key, Value.new(Time.new.to_i + expired_in, payload))
      payload
    end

    def get(key)
      value = @hash[key]

      if value && (Time.new.to_i < value.expired_time)
        value.data 
      else
        @hash.delete(key)
        nil
      end
    end

    # only for tests
    def keys
      @hash.keys
    end
  end
end

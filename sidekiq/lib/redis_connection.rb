module SideKiq
  class RedisConnection
    class << self
      def create(options = {})
        ConnectionPool.new(timeout: 5, size: 10) do
          build_client(options)
        end
      end

      def build_client(options)
        Redis.new(options)
      end
    end
  end
end
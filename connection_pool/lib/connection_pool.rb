class ConnectionPool
  DEFAULT_OPTIONS = {
    size: 5,
    timeout: 5
  }

  def initialize(options = {}, &block)
    options = DEFAULT_OPTIONS.merge(options)

    @size = options.fetch(:size)
    @timeout = options.fetch(:timeout)

    @create_block = block
    @created_count = 0
    @mutex = Mutex.new
    @resource = ConditionVariable.new
    @pool = []
  end

  def with
    Thread.handle_interrupt(Exception => :never) do
      conn = fetch_connection
      begin
        yield conn
      ensure
        recycle_connection
      end
    end
  end

  def fetch_connection
    Thread.current['connection'] = pop_connection_from_pool
  end

  def pop_connection_from_pool
    deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + @timeout
    @mutex.synchronize do
      loop do
        return @pool.pop if @pool.any?

        connection = try_create_connection
        return connection if connection

        to_wait = deadline - Process.clock_gettime(Process::CLOCK_MONOTONIC)
        raise "Timeout" if to_wait <= 0
        @resource.wait(@mutex, to_wait)
      end
    end
  end

  def recycle_connection
    @mutex.synchronize do
      @pool.push(Thread.current['connection'])
      Thread.current['connection'] = nil
    end
  end

  def try_create_connection
    return if @created_count >= @size

    new_connection = @create_block.call
    @created_count += 1
    new_connection
  end
end

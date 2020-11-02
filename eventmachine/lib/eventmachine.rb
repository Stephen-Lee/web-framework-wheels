module EventMachine
  autoload :Connection, 'connection'
  autoload :EvmaTcpServer, 'evma_tcp_server'
  autoload :EvmaTCPClient, 'evma_tcp_client'
  autoload :Reactor, 'reactor'
  autoload :StreamObject, 'stream_object'
  autoload :Selectable, 'selectable'

  TimerFired = 100
  ConnectionData = 101
  ConnectionAccepted = 103
  THREAD_POOL_SIZE = 20

  class << self
    def run &block
      @conns = {}
      @acceptors = {}
      @timers = {}

      add_timer(0, block)
      Reactor.instance.run
    end

    def add_timer interval, block
      s = Reactor.instance.install_oneshot_timer(interval)
      @timers[s] = block
      s
    end

    def start_server host, port, handler
      s = EvmaTcpServer.start_server(host, port)
      @acceptors[s] = [handler]
      s
    end

    def defer &block
      unless @thread_pool
        @thread_pool = []
        @thread_queue = Queue.new
        spawn_threadpool
      end

      @thread_queue << block
    end

    def spawn_threadpool
      until @thread_pool.size == THREAD_POOL_SIZE
        thread = Thread.new do
          while true
            operation = @thread_queue.pop
            result = operation.call
          end
        end
        @thread_pool << thread
      end
    end

    def send_data target, data
      selectable = Reactor.instance.get_selectable(target)
      selectable.send_data data
    end

    def close_connection target
      selectable = Reactor.instance.get_selectable(target)
      selectable.schedule_close
    end

    def event_callback conn_binding, opcode, data
      case opcode
      when TimerFired
        t = @timers.delete data
        t.call
      when ConnectionAccepted
        accep, args = @acceptors[conn_binding]
        c = accep.new data, *args
        @conns[data] = c
      when ConnectionData
        c = @conns[conn_binding]
        c.receive_data data
      end
    end
  end

  module UuidGenerator
    def self.generate
      @ix ||= 0
      @ix += 1
    end
  end
end



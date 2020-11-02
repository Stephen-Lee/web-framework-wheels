module EventMachine
  class StreamObject < Selectable
    def initialize io
      super io
      @outbound_q = []
    end

    def select_for_reading?
      !@close_scheduled
    end

    def select_for_writing?
      return false if @close_scheduled
      @outbound_q.empty?
    end

    def eventable_read
      begin
        10.times {
          data = io.read_nonblock(4096)
          EventMachine.event_callback uuid, ConnectionData, data
        }
      rescue Errno::EAGAIN, Errno::EWOULDBLOCK
      rescue Errno::ECONNRESET, Errno::ECONNREFUSED, EOFError, Errno::EPIPE, OpenSSL::SSL::SSLError
      end
    end

    def eventable_write
      while data = @outbound_q.shift do
        data = data.to_s
        io.write_nonblock data
      end
    end

    def send_data data
      unless @close_scheduled
        @outbound_q << data.to_s
      end
    end
  end
end
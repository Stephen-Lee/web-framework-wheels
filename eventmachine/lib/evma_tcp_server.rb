require 'socket'

module EventMachine
	class EvmaTcpServer < Selectable
	  class << self
	    def start_server host, port
	      sd = Socket.new( Socket::AF_INET, Socket::SOCK_STREAM, 0 )
	      sd.setsockopt( Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true )
	      sd.bind( Socket.pack_sockaddr_in( port, host ))
	      sd.listen( 50 )
	      s = EvmaTcpServer.new sd
	      s.uuid
	    end

	  end

	  def initialize io
	    super io
	  end

	  def select_for_reading?
	    true
	  end

	  def eventable_read
	    begin
	      10.times {
	        descriptor,peername = io.accept_nonblock
	        sd = EvmaTCPClient.new descriptor
	        EventMachine.event_callback uuid, ConnectionAccepted, sd.uuid
	      }
	    rescue Errno::EWOULDBLOCK, Errno::EAGAIN
	    end
	  end
	end
end
module Thin
  class Connection < EventMachine::Connection
    def post_init
      @request = Request.new
    end

    def receive_data data
      @request.parse(data)
      EventMachine.defer { post_process(pre_process) }
    end

    def pre_process
      Thin.app.call(@request.env)
    end

    def post_process(result)
      @response = Response.new
      @response.status, headers, @response.body = result

      @response.each do |chunk|
        send_data chunk
      end
    ensure
      close_connection_after_writing
    end

    def unbind
      p 'unbind'
    end
  end
end
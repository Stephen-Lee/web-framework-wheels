module EventMachine
  class Connection
    attr_accessor :signature

    def self.new(sig, *args)
      allocate.instance_eval do
        @signature = sig
        initialize(*args)
        post_init

        self
      end
    end

    def post_init
    end

    def receive_data data
    end

    def send_data data
      EventMachine.send_data @signature, data
    end

    def unbind
    end

    def close_connection_after_writing
      EventMachine.close_connection @signature
    end
  end
end
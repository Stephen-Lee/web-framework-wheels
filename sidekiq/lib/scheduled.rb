module SideKiq
  module Scheduled
    class Poller
      def initialize
      end

      def start
        while true
          sleep 1
        end
      end
    end
  end
end
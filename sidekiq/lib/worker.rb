module SideKiq
  module Worker
    attr_accessor :job_id

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def perform_async(*args)
        client_push('class' => self, 'args' => args)
      end

      def perform_in(interval, *args)
        int = interval.to_f
        now = Time.now.to_f
        ts = (int < 1_000_000_000 ? now + int : int)

        item = { 'class' => self, 'args' => args, 'at' => ts }

        item.delete('at') if ts <= now

        client_push(item)
      end

      def client_push(item)
        item['queue'] ||= 'default'
        SideKiq::Client.new.push(item)
      end
    end
  end
end

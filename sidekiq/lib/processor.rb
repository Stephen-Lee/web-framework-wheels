module SideKiq
  class Processor
    UnitOfWork = Struct.new(:queue, :job) do
    end

    def initialize
      @queues = SideKiq.config[:queues].map { |q| "queue:#{q}" }
    end

    def start
      Thread.new do
        run
      end
    end

    def run
      while true
        process_one
      end
    end

    def process_one
      job = fetch
      process(job) if job
    end

    def fetch
      work = SideKiq.redis_pool.with do |conn|
        conn.brpop(@queues)
      end
      UnitOfWork.new(*work) if work
    end

    def process work
      job = work.job
      job_hash = SideKiq.load_json(job)
      klass_str = job_hash['class']
      klass = Object.const_get(klass_str)
      p klass
      args = job_hash['args']
      worker = klass.new

      worker.perform(args)
    end
  end
end
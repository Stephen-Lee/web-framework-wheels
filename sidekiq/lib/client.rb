module SideKiq
  class Client
    def initialize
      @redis_pool = SideKiq.redis_pool
    end

    def push(item)
      normed = normalized_item(item)
      raw_push([normed])
    end

    def raw_push(payloads)
      @redis_pool.with do |conn|
        conn.multi do
          atomic_push(conn, payloads)
        end
      end
    end

    def atomic_push(conn, payloads)
      if payloads.first['at']
        conn.zadd('schedule', payloads.map do |hash|
          at = hash.delete('at').to_s
          [at, SideKiq.dump_json(hash)]
        end)
      else
        q = payloads.first['queue']
        now = Time.now.to_f
        to_push = payloads.map do |entry|
          entry['enqueued_at'] = now
          SideKiq.dump_json(entry)
        end
        conn.sadd('queues', q)
        conn.lpush("queue:#{q}", to_push)
      end
    end

    def normalized_item(item)
      item['job_id'] = SecureRandom.hex(12)
      item['created_at'] ||= Time.now.to_f
      item
    end
  end
end
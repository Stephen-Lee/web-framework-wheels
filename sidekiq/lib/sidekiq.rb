require 'connection_pool'
require 'securerandom'
require 'singleton'
require 'redis'
require 'json'
require 'set'

module SideKiq
  autoload :CLI, 'cli'
  autoload :Client, 'client'
  autoload :Launcher, 'launcher'
  autoload :Manager, 'manager'
  autoload :Processor, 'processor'
  autoload :RedisConnection, 'redis_connection'
  autoload :Scheduled, 'scheduled'
  autoload :Worker, 'worker'

  def self.redis_pool
    @redis ||= RedisConnection.create
  end

  def self.dump_json(obj)
    JSON.generate(obj)
  end

  def self.load_json(str)
    JSON.parse(str)
  end

  def self.config
    {
      queues: ['default']
    }
  end
end
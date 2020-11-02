require 'rack'
require 'eventmachine'

module Thin
  autoload :Connection, 'connection'
  autoload :Request, 'request'
  autoload :Response, 'response'

  def self.app
    @app ||= load(File.join('./', "config.ru"))
  end

  def self.load(config)
    rackup_code = File.read(config)
    eval("Rack::Builder.new {( #{rackup_code}\n )}.to_app", TOPLEVEL_BINDING, config)
  end

  def self.start
    EventMachine.run {
      EventMachine.start_server('127.0.0.1', 8099, Connection)
    }
  end
end

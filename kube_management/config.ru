class LogMiddleWare
  def initialize(app)
    @app = app
  end

  def call(env)
    p 'log!'
    return @app.call(env)
  end
end

class App
  def call(env)
    return [200, { "Content-Type" => "text/plain" }, [RequestHandler.new.dispatch(env)]]
  end
end

class RequestHandler
  def dispatch(env)
    UsersController.new.send('show')
  end
end

use LogMiddleWare
run App.new
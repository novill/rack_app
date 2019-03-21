require_relative 'worker'

class App
  def call(env)
    Worker.new(env).perform_request
  end
end

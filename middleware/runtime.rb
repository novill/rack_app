class Runtime
  def initialize(app)
    @app = app
  end

  def call(env)
    # p self.class
    start = Time.now
    status, headers, body = @app.call(env)
    headers['X-runtime'] = "%fs" % (Time.now - start)

    [status, headers, body]
  end
end
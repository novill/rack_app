require_relative 'worker'

class App
  def call(env)
     @env = env
    @query_params = Rack::Utils.parse_nested_query(@env['QUERY_STRING'])
    return [404, { 'Content-Type' => 'text/plain' }, "Not found\n"] unless check_request_params

    worker = Worker.new(@query_params['format'].split(','))

    extra_formats = worker.extra_formats

    return [400, { 'Content-Type' => 'text/plain' },  "Unknown time format #{extra_formats}\n"] unless extra_formats.empty?

    str_time = "#{worker.format_date}\n"

    [200, { 'Content-Type' => 'text/plain' }, [str_time]]
  end

  def check_request_params
    return false unless @env['REQUEST_METHOD'] == 'GET'
    return false unless @env['REQUEST_PATH'] == '/time'
    @query_params.keys == ['format']
  end
end

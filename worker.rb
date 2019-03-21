class Worker
  ALLOWED_PARAMS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def initialize(env)
    @env = env
    @status = 404
    @headers = { 'Content-Type' => 'text/plain' }
    @body = ["Not found\n"]
  end

  def perform_request
    proceed_date if check_and_prepare_params

    [@status, @headers, @body]
  end

  def check_and_prepare_params
    return false unless @env['REQUEST_METHOD'] == 'GET'
    return false unless @env['REQUEST_PATH'] == '/time'
    return false unless check_request_params

    check_formats
  end

  def check_request_params
    return if @env['QUERY_STRING'] == ''

    @query_params = Rack::Utils.parse_nested_query(@env['QUERY_STRING'])
    @query_params.keys == ['format']
  end

  def check_formats
    @query_formats = @query_params['format'].split(',')
    wrong_formats = @query_formats - ALLOWED_PARAMS.keys

    if wrong_formats.empty?
      true
    else
      @status = 400
      @body = ["Unknown time format #{wrong_formats}\n"]
      false
    end
  end

  def proceed_date
    @status = 200
    @body = [format_date]
  end

  def format_date
    format_string = @query_formats.map { |format| ALLOWED_PARAMS[format] }.join('-')
    Time.now.strftime(format_string) + "\n"
  end
end

# В отдельном резпозитории напишите минималистичное Rack приложение которое будет отвечать на
#
# URL GET /time
#
# с параметром строки запроса format и возвращать время в заданном формате.
#
# Например, GET-запрос
#
# /time?format=year%2Cmonth%2Cday
#
# вернет ответ с типом text/plain и телом 1970-01-01.
#
#
#     Доступные форматы времени: year, month, day, hour, minute, second
# Форматы передаются в параметре строки запроса format в любом порядке
# Если среди форматов времени присутствует неизвестный формат, необходимо возвращать ответ с кодом статуса 400 и телом "Unknown time format [epoch]"
# Если неизвестных форматов несколько, все они должны быть перечислены в теле ответа, например: "Unknown time format [epoch, age]"
# При запросе на любой другой URL необходимо возвращать ответ с кодом статуса 404

class App
  ALLOWED_PARAMS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }

  def call(env)
    @env = env
    @status = 404
    @headers = { 'Content-Type' => 'text/plain' }
    @body = ["Not found\n"]

    perform_request

    [@status, @headers, @body]
  end

  private

  def perform_request
    return unless @env['REQUEST_METHOD'] == 'GET'
    return unless @env['REQUEST_PATH'] == '/time'
    return unless check_params
    return unless check_formats

    @status = 200
    @body = [format_date]
  end

  def check_params
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

  def format_date
    format_string = @query_formats.map { |format| ALLOWED_PARAMS[format] }.join('-')
    Time.now.strftime(format_string) + "\n"
  end
end

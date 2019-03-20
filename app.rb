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

  def call(env)
    # p self.class
    perform_request
    [status, headers, body]
  end

  private

  def perform_request
    sleep(rand(2..3))
  end

  def status
    200
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    ["Welcome aboard!\n"]
  end
end
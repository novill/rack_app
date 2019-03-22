class Worker
  ALLOWED_PARAMS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def initialize(formats_array)
    @formats_array = formats_array
  end

  def extra_formats
    @formats_array - ALLOWED_PARAMS.keys
  end

  def format_date
    return unless extra_formats.empty?

    format_string = @formats_array.map { |format| ALLOWED_PARAMS[format] }.join('-')
    Time.now.strftime(format_string)
  end
end

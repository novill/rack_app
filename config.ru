require_relative 'middleware/logger'
require_relative 'middleware/runtime'
require_relative 'app'

use AppLogger, logdev: File.expand_path('log/app.log', __dir__)
use Runtime
run App.new

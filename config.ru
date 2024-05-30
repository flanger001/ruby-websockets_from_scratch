require "./lib/app"

use Rack::Reloader, 0
use Rack::Static, :urls => ["/assets/js", "/assets/css"], :root => "lib"
use Rack::Logger

run App::Runner

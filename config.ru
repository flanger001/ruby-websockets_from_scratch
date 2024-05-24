require "./app"

run Rack::URLMap.new(
  {
    "/ws" => App::WebSocket::Handshake.new,
    "/favicon.ico" => App::Favicon.new,
    "/" => App::Index.new
  }
)

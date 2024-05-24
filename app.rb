require "dotenv/load"
require "rack"
require "erb"
require "json"
require "digest"
require "base64"
require "io/wait"

module App
  autoload :Favicon, "./app/favicon"
  autoload :Index, "./app/index"
  autoload :WebSocket, "./app/websocket"
end

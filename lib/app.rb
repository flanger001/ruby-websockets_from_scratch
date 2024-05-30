require "dotenv/load"
require "rack"
require "erb"
require "json"
require "digest"
require "base64"
require "io/wait"

autoload :Renderer, "./lib/renderer"

module App
  autoload :WebSocket, "./lib/app/websocket"

  class << self
    def runtime
      @runtime ||= Runtime.new
    end
  end

  class Runtime
    attr_reader :sockets

    def initialize
      @sockets = []
    end
  end

  class Runner
    class << self
      def call(env)
        new(env).call
      end
    end

    attr_reader :request, :renderer

    def initialize(env)
      @request = Rack::Request.new(env)
      @renderer = Renderer.new
    end

    def call
      case @request.path
      when "/ws"
        WebSocket::Handshake.new.call(@request.env)
      when "/favicon.ico"
        [
          200,
          { "Content-Type" => "image/png" },
          [Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAFklEQVR42mNcwPD/PwMRgHFUIX0VAgDNexo3sUL33gAAAABJRU5ErkJggg==")],
        ]
      when "/"
        [
          200,
          { "Content-Type" => "text/html" },
          [@renderer.render("index.html.erb")]
        ]
      else
        [404, {}, ["Not found"]]
      end
    end
  end
end

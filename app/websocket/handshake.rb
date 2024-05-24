module App
  module WebSocket
    class Handshake
      WEBSOCKET_MAGIC_STRING = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"

      def call(env)
        [
          101,
          {
            "Sec-WebSocket-Accept" => handshake(env["HTTP_SEC_WEBSOCKET_KEY"]),
            "Connection" => "Upgrade",
            "Upgrade" => "websocket",
            "rack.hijack" => Connection.new
          },
          []
        ]
      end

      def handshake(sec_websocket_key)
        sha1 = Digest::SHA1.new
        sha1 << sec_websocket_key
        sha1 << WEBSOCKET_MAGIC_STRING
        sha1.base64digest
      end
    end
  end
end

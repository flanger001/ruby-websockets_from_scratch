class WebSocketHandshakeTest < Minitest::Test
  def test_it_works
    app = App::WebSocket::Handshake.new
    sec_websocket_key = "dGhlIHNhbXBsZSBub25jZQ=="
    assert_equal("s3pPLMBiTxaQ9kYGzzhZRbK+xOo=", app.handshake(sec_websocket_key))
  end
end

class WebSocketConnectionTest < Minitest::Test
  # NB: The `data` variables are excerpts of byte arrays
  def setup
    @conn = App::WebSocket::Connection.new
  end

  def test_it_works1
    data = [129, 131, 19, 153, 235, 4, 106, 252, 152]
    result = @conn.extract_payload_size(data)
    assert_equal(1, result.length_start)
    assert_equal(1, result.length_end)
    assert_equal(3, result.length_total)
  end

  def test_it_works2
    data = [129, 254, 2, 101, 156, 212, 91, 32, 213, 160, 123, 73, 239, 244, 58, 0]
    result = @conn.extract_payload_size(data)
    assert_equal(2, result.length_start)
    assert_equal(3, result.length_end)
    assert_equal(613, result.length_total)
  end

  def test_it_works3
    data = [129, 255, 0, 0, 0, 0, 0, 1, 18, 97, 188, 17, 52]
    result = @conn.extract_payload_size(data)
    assert_equal(2, result.length_start)
    assert_equal(9, result.length_end)
    assert_equal(70241, result.length_total)
  end
end

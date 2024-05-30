module App
  module WebSocket
    class Connection
      FRAMES = {
        :continuation => 0x0,
        :text => 0x1,
        :binary => 0x2,
        :close => 0x8,
        :ping => 0x9,
        :pong => 0xA,
      }

      def call(socket)
        App.runtime.sockets.push(socket)
        puts "Total connections: #{App.runtime.sockets.length}"
        send_message(socket, "From server: Welcome!")

        loop do
          break if socket.closed?
          close_connection = false
          assemble_message = true
          full_client_message = []

          while assemble_message
            if socket.ready? && socket.nread > 0
              data = socket.recv(socket.nread).bytes

              fin_op = data[0]
              # puts "FIN, RSV, and OPCODES: #{"%08b" % fin_op}"
              # Keep building the message if our first bit is a continuation frame
              assemble_message = fin_op[0][7] ^ FRAMES[:continuation] == 0

              # Close the connection if we receive an 0x8 opcode
              close_connection = fin_op & FRAMES[:close] != 0
              break if close_connection

              # Break if the mask bit is not set
              break if data[1][7] & 0x1 == 0

              # Get message length
              payload_size = extract_payload_size(data)
              puts "Received #{payload_size.length_total} bytes"

              client_message = "#{extract_address(socket)} - #{extract_client_message(data, payload_size.length_end + 1)}"
              full_client_message << client_message
            end
          end

          if full_client_message.any?
            full_client_message = full_client_message.join
            puts "Full client message: #{full_client_message}"

            App.runtime.sockets.each do |s|
              unless s.closed?
                send_message(s, "Greetings to you, too.") if full_client_message.match?(/greetings/i)
                send_message(s, full_client_message)
              end
            end

            if full_client_message.match?(/close connection/i)
              send_message(socket, "Closing connection!")
              send_control_frame(socket, 0x8)
              socket.close
            end
          end

          if close_connection
            puts "Closing connection"
            socket.close
          end
        end

        if socket.closed?
          puts "Socket closed"
        else
          socket.close
        end

        App.runtime.sockets.delete(socket)
      end

      def send_message(socket, message)
        socket.sendmsg(build_message(message), 0)
      end
      def send_control_frame(socket, opcode)
        socket.sendmsg(control_frame(opcode), 0)
      end

      def extract_address(socket)
        "#{socket.peeraddr[2]}:#{socket.peeraddr[1]}"
      end

      def build_message(message)
        [0b10000001, message.size, message].pack("CCA#{message.size}")
      end

      def control_frame(opcode)
        [0b10000000 | opcode, 2].pack("CC")
      end

      def extract_payload_size(data)
        payload_size_start = 1
        payload_size_length = 1
        payload_size = data[payload_size_start, payload_size_length][0] & 0b01111111

        # Payload size is 8 bit integer if the value is less than or equal to 125
        if payload_size > 125
          if payload_size == 126
            # Payload is 16 bit integer
            payload_size_start = 2
            payload_size_length = 2
          elsif payload_size == 127
            # Payload is 64 bit integer
            payload_size_start = 2
            payload_size_length = 8
          end

          payload_size = data[payload_size_start, payload_size_length].
            each_with_index.
            reduce(0) { |sum, (byte, idx)| sum += (byte << (payload_size_length - 1 - idx) * 8) }
        end

        PayloadSize.new(payload_size_start, payload_size_start + payload_size_length - 1, payload_size)
      end

      def extract_client_message(data, mask_start)
        mask = data[mask_start, 4]
        data[(mask_start + 4)..].
          map.
          with_index { |c, i| c ^ mask[i % 4] }.
          pack("C*")
      end
    end

    PayloadSize = Struct.new(:length_start, :length_end, :length_total)
  end
end

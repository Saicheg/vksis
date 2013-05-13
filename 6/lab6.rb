require 'pry'
Dir[File.expand_path('../*.rb', __FILE__)].each { |f| require f }

Thread.abort_on_exception = true

stations = Array.new(4) { |i| Station.new(i, rand(1..8)) }
stations << MonitoringStation.new

# Thread.new do
#   loop do
#     sleep 1
#     source = stations.sample
#     dest = stations.sample
#     next if source.is_a?(MonitoringStation) || dest.is_a?(MonitoringStation)
#     source.new_message(dest.address, "1111")
#   end
# end

@frame = Frame.new


Shoes.app title: "TokenRing", width: 800, height: 600 do

  stations.each_with_index do |station|
    flow width: 200, height: 300 do
      border black, strokewidth: 1

      flow width: 200, height: 50, margin_top: 10, margin_right: 5, margin_left: 5 do
        para "Address: #{station.address}"
      end

      flow width: 200, height: 50, margin_right: 5, margin_left: 5 do
        self.instance_variable_set("@message_line_#{station.address}", edit_line(width: 100))
        self.instance_variable_set("@source_line_#{station.address}", edit_line(width: 30))
        button 'Send', width: 50 do
          # text = @message_line.text
          # Thread.new { send text }
          # @message_line.text = ''
        end
      end

      @info = flow width: 180, height: 50, scroll: true, margin: 20 do
        border gainsboro, strokewidth: 1
      end

      @messages = flow width: 180, height: 100, scroll: true, margin:20 do
        border ghostwhite, strokewidth: 1
      end

    end
  end

  Thread.new do

  end

  Thread.new do
    stations.cycle do |station|
      @frame = station.receive(@frame)
      sleep 0.1
    end
  end

  # Thread.new do
  #   local_server = Cod.tcp_server("localhost:#{PORT}")
  #   loop do
  #     (mode, message), server_channel = local_server.get_ext

  #     # p "Client #{PORT} received: [mode] #{mode} [message] #{message}"
  #     case mode
  #     when 'append'
  #       @messages.para message
  #       server_channel.put Time.now
  #     else
  #       server_channel.put 'Unknown request!'
  #     end
  #   end
  # end
end

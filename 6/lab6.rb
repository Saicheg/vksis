require 'digest/crc32'
require 'pry'
$debug = true
Dir[File.expand_path('../src/*.rb', __FILE__)].each { |f| require f }

Thread.abort_on_exception = true

stations = Array.new(4) { |i| Station.new(i, rand(1..8)) }
all_stations = [] << stations << MonitoringStation.new
all_stations.flatten!

$frame = Frame.new
#
# Thread.new do
#   loop do
#     sleep 1
#     source = stations.sample
#     dest = stations.sample
#     source.new_message(dest.address, "1111")
#   end
# end

# Frames
Thread.new do
  all_stations.cycle do |station|
    $frame = station.receive($frame)
    sleep 0.1
  end
end

Shoes.app title: "TokenRing", width: 800, height: 600 do

  stations.each_with_index do |station|
    flow width: 200, height: 300 do
      border black, strokewidth: 1

      flow width: 200, height: 50, margin_top: 10, margin_right: 5, margin_left: 5 do
        para "Address: #{station.address} and priority #{station.priority}"
      end

      flow width: 200, height: 50, margin_right: 5, margin_left: 5 do
        self.instance_variable_set("@message_line_#{station.address}", edit_line(width: 100))
        self.instance_variable_set("@source_line_#{station.address}", edit_line(width: 30))
        button 'Send', width: 50 do
          text = self.instance_variable_get("@message_line_#{station.address}")
          address =  self.instance_variable_get("@source_line_#{station.address}")
          station.new_message(address.text.to_i, text.text)
          text.text = ''
          address.text = ''
        end
      end

      # @info = flow width: 180, height: 50, scroll: true, margin: 20 do
      #   border gainsboro, strokewidth: 1
      # end

      self.instance_variable_set("@messages_#{station.address}", flow(width: 196, height: 190, margin: 2) { border(ghostwhite, strokewidth: 1) })
    end
  end

  # Update messages
  Thread.new do
    stations.cycle do |station|
      messages = self.instance_variable_get("@messages_#{station.address}")
      messages.para("#{station.received.pop}\n") unless station.received.empty?
      sleep 0.01
    end
  end

end

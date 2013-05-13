require 'pry'
require_relative 'frame'
require_relative 'station'
require_relative 'monitoring_station'

Thread.abort_on_exception = true

stations = Array.new(4) { |i| Station.new(i, rand(1..8)) }
stations << MonitoringStation.new

Thread.new do
  loop do
    sleep 1
    source = stations.sample
    dest = stations.sample
    next if source.is_a?(MonitoringStation) || dest.is_a?(MonitoringStation)
    source.new_message(dest.address, "1111")
  end
end

@frame = Frame.new

stations.cycle do |station|
  @frame = station.receive(@frame)
  sleep 0.1
end


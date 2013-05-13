require 'pry'
require_relative 'frame'
require_relative 'station'

Thread.abort_on_exception=true

stations = Array.new(7) { |i| Station.new(i, i % 2) }

stations.each_with_index do |station, i|
  if i+1 == stations.count
    station.neighbor = stations.first
  else
    station.neighbor = stations[i+1]
  end
end


Thread.new do
  loop do
    source = stations.sample
    dest = stations.sample
    # puts "\nData generated for #{source.address} with #{dest.address}"
    source.new_message(dest.address, "1111")
    sleep rand(1..5)
  end
end

@frame = Frame.new

stations.cycle do |station|
  @frame = station.receive(@frame)
  sleep 1
end


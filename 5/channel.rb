require 'cod'
require 'shoes'

PORT = 10000 + rand(20000)
$channel = Cod.tcp('localhost:44456')
$ip = rand(256)
$channel.interact ['connect', PORT]

def channel_busy?
  Array.new(2).map do
    sleep 0.25
    mode, busy = $channel.interact ['busy?', PORT]
    p busy.class
    break [false] if busy.is_a?(Array)
    sleep 0.25
    busy
  end.any?
end

Shoes.app title: "Client", width: 260 do
  $info = flow width: 260, height: 230, scroll: true

  Thread.new do
    loop do
      puts "Channel: #{channel_busy?}"
      $channel.interact ["status", nil]
      # if channel_busy?
      #   $info.para "busy\n" if busy
      # else
      #   $info.para "free\n" if busy
      # end
      sleep 1
    end
  end
end

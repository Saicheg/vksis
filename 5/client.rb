# require 'pry'
require 'cod'
require 'shoes'

PORT = 10000 + rand(20000)
$channel = Cod.tcp('localhost:44599')
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

def wait
  time = rand(2000) / 1000.0
  $info.para "[BUSY] Waiting for #{time} msec\n"
  sleep time
end

def send(message)
  # p "Sending #{message}"
  message = message.split ''
  while !message.empty?
    while channel_busy?
      mode, busy = $channel.interact ['collision_on', PORT]
      wait
    end
    $channel.interact ['collision_off', PORT]
    $info.para "[SEND] #{message.first} was sent\n"
    $channel.interact ["send #{PORT}", message.shift]
  end
end

Shoes.app title: "Client", width: 260 do
  para 'Message      '
  @message_line = edit_line width: 260
  $info = flow width: 260, height: 230, scroll: true
  @messages = flow width: 260, height: 150, scroll: true

  button 'Send', height: 40 do
    text = @message_line.text
    Thread.new { send text }
    @message_line.text = ''
  end


  Thread.new do
    local_server = Cod.tcp_server("localhost:#{PORT}")
    loop do
      (mode, message), server_channel = local_server.get_ext

      # p "Client #{PORT} received: [mode] #{mode} [message] #{message}"
      case mode
      when 'append'
        @messages.para message
        server_channel.put Time.now
      else
        server_channel.put 'Unknown request!'
      end
    end
  end
end

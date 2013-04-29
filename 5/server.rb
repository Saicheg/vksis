require 'cod'
require 'pry'

$time_server_channel = Cod.tcp_server('localhost:44599')
$clients = []
$last_message_time = -1
$last_port = -1
$collistion = false

def busy?
  (Time.now.to_f - $last_message_time < 2)
end

def update_post_time
  $last_message_time = Time.now.to_f
end

Shoes.app title: "Server", width: 260 do
  $banner = banner "Status"
  $info = flow width: 260, height: 500, scroll: true

  Thread.new do
    loop do
      (mode, message), client_channel = $time_server_channel.get_ext
      # puts "Mode #{mode} Message #{message}"

      case mode.split.first
      when 'connect'
        p mode, message
        $clients << Cod.tcp("localhost:#{message}")
        puts "Client on port #{message} connected"
        client_channel.put Time.now
      when 'busy?'
        p message, $last_port
        if (message.to_s == $last_port.to_s)
          client_channel.put ['busy?', [true]]
        else
          client_channel.put ['busy?', busy?]
        end
      when 'send'
        $clients.each { |c| c.interact ['append', message] }
        update_post_time
        $last_port = mode.split.last
        client_channel.put Time.now
      when 'collision_on'
        $collision = true
        client_channel.put Time.now
      when 'collision_off'
        $collision = false
        client_channel.put Time.now
      when 'status'
        client_channel.put Time.now
      else
        puts 'ERROR! UNKNOWN REQUEST!'
        client_channel.put Time.now
      end
    end
  end

  Thread.new do
    loop do
      if busy?
        $banner.text = "Status: busy"
        if $collision
          $banner.text = "Status: collision"
        end
      else
        $banner.text = "Status: free"
      end
      sleep 0.1
    end
  end
end

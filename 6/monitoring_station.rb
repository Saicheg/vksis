class MonitoringStation

  def initialize
    @last_fcs = nil
  end

  def new_message(addr, data)
  end

  def receive(frame)
    puts "Monitoring station recieved #{frame.info}"
    if frame.token
      if frame.reserved != 0
        puts "Monitoring station changed priority from #{frame.priority} to #{frame.reserved}"
        frame.priority = frame.reserved
        frame.reserved = 0
        frame
      end
    else
      if @last_fcs == frame.fcs
        frame.ttl -= 1
        if frame.ttl == 0
          puts "Drop frame! " * 5
          frame = Frame.new
        end
      else
        @last_fcs = frame.fcs
      end
    end
    frame
  end
end

class Station
  attr_accessor :address, :priority, :buffer, :received

  def initialize(address, priority)
   @address = address
   @priority = priority
   @buffer = Array.new
   @received = Array.new
  end

  def receive(frame)
    puts "Station #{@address} recieved #{frame.info}" if $debug
    frame.token ? receive_token(frame) : receive_frame(frame)
  end

  def receive_token(frame)
    if frame.priority <= @priority
      return @buffer.pop if has_data?
    else
      if frame.reserved <= @priority && has_data?
        frame.reserved = @priority
      end
    end
    frame
  end

  def receive_frame(frame)
    if frame.priority < @priority
      frame
    elsif answer?(frame)
      Frame.new
    elsif message?(frame)
      @received.push(frame.data)
      frame.status = true
      frame
    else
      frame
    end
  end

  def has_data?
    !@buffer.empty?
  end

  def answer?(frame)
    frame.status == true && frame.source == @address
  end

  def message?(frame)
    frame.destination == @address
  end

  def new_message(dest, data)
    frame = Frame.new
    frame.source = @address
    frame.destination = dest
    frame.data = data
    frame.token = false
    frame.priority = @priority
    @buffer.push(frame)
  end

end

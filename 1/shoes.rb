require 'rubygems'
require 'serialport'
require 'eventmachine'
require 'pry'

Shoes.app :height => 480, :width => 640, :resizable => false, :title => 'Serial port chat' do
  background white

  stack :margin => 10 do
    @chat_messages = stack :margin => 10, :height => 400, :scroll => true do
      border black, :stokewidth => 1
    end

    flow :margin => 10 do
      para "Name:", :margin_right => 10
      @name = edit_line :width => 100, :margin_right => 3
      para "Message:", :margin_right => 10
      @message = edit_line :width => 290, :margin_right => 3
      button "Send" do
        if @name.text == ''
          alert("Name can't be blank!")
        end
        if @message.text == ''
          alert("Text can't be blank!")
        end
        add(@name.text, @message.text)
      end
    end
  end

  @sp = SerialPort.new("/dev/tty8", 9600, 8, 1, SerialPort::NONE)
  @messages = []

  Thread.new do
    EM.run do
      EM.add_timer(1) do
        add_message(@sp.sysread)
      end
    end
    # while message = @sp.gets do
      # unless @messages.include?(message.strip)
        # add_message(message)
      # end
    # end
  end

  def add(name, text)
    msg = format_msg(name,text)
    @messages << msg
    add_message(msg)
    @sp.syswrite("#{msg}\r")
  end

  def add_message(message)
    @chat_messages.append { para message, :margin => 0}
  end

  def format_msg(name, text)
    "#{name}(#{time}): #{text}"
  end

  def time
    Time.now.strftime("%H:%M:%S")
  end
end

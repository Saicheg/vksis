require 'rubygems'
require 'serialport'
require 'eventmachine'
require 'pry'

# sp = SerialPort.new "/dev/pts/7", 9600

# if ARGV.size < 4
#   STDERR.print <<EOF
#   Usage: ruby #{$0} num_port bps nbits stopb
# EOF
#   exit(1)
# end

# sp = SerialPort.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i, ARGV[3].to_i, SerialPort::NONE)

# open("/dev/pts/7", "r+") do |tty|
  # tty.sync = true
  # Thread.new do
    # while(true) do
      # tty.printf("%c", sp.getc)
      # puts sp.getc
    # end
  # end
  # while (l = gets) do
    # sp.write(l.sub("\n", "\r"))
  # end
# end

# sp.close

sp = SerialPort.new("/dev/tty8", 9600, 8, 1, SerialPort::NONE)


# open("/dev/pts/6", "w+") do |tty|
  # tty.sync = true
  # Thread.new {
    while char = sp.gets do
      puts char
      # tty.printf("%c", sp.getc)
    end
  # }
#   while (l = gets) do
#     sp.write(l.sub("\n", "\r"))
#   end
# end


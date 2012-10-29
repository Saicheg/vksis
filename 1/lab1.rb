require 'rubygems'
require 'serialport'
require 'eventmachine'

# sp = SerialPort.new "/dev/pts/8", 9600

# if ARGV.size < 4
#   STDERR.print <<EOF
#   Usage: ruby #{$0} num_port bps nbits stopb
# EOF
#   exit(1)
# end
#

sp = SerialPort.new("/dev/pts/6", 9600, 8, 1, SerialPort::NONE)

while (l = gets) do
  sp.write(l.sub("\n", "\r"))
end

# sp.close


# p = open('/dev/pts/7', 'r+')
# p.sync = true

# EM.run do
  # EM.add_timer(1) do
    # while( a =  p.gets)
      # puts a
    # end
  # end
# end

#
#  EM.add_timer(1) do
#   puts sp.read
#  end
# end

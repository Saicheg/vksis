#----------#----------#---------#---------#---------#
#   flag   #  dest    #  source #  data   #   crc   #
#----------#----------#---------#---------#---------#
#   1b         1b        1b         21b        2b      26b

FLAG = 126 # 01111110
DESTINATION = 42
SOURCE = 24

class Package
  def initialize(data, flag=FLAG, dest=DESTINATION, source=SOURCE)
    @flag = flag
    @dest = dest
    @source = source
    @data = data
  end
end

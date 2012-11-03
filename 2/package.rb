require_relative 'bit_stuffer'
#----------#----------#---------#---------#---------#
#   flag   #  dest    #  source #  data   #   crc   #
#----------#----------#---------#---------#---------#
#   1b         1b        1b         21b        2b      26b

DESTINATION = 42
SOURCE = 24

class Package

  PARAMS = %w(flag dest source)

  def self.parse(data)
    {flag: data[0..7], dest: data[8..15], source: data[16..23], data: data[24..191], crc:[192..207]}
  end

  PARAMS.each do |p|
    define_method "#{p}_bit".to_sym do
      instance_variable_get("@#{p}".to_sym).to_bit_arr
    end

    define_method "#{p}_bit_str".to_sym do
      instance_variable_get("@#{p}".to_sym).to_bit_arr.join("")
    end
  end

  def data_bit
    @data
  end

  def data_bit_str
    data_bit.join("")
  end

  def initialize(data, flag=BitStuffer::FLAG, dest=DESTINATION, source=SOURCE)
    @flag = flag
    @dest = dest
    @source = source
    @data = build_data(data)
  end

  def info
    "#{flag_bit_str} #{dest_bit_str} #{source_bit_str} #{data_bit_str} #{crc.join("")}"
  end

  def pkg_data
    [flag_bit, dest_bit, source_bit, data_bit, crc].flatten
  end

  def crc
    Array.new(16) {|i| 0}
  end

  private

  def build_data(data)
    data << 0 while data.size != 21*8
    data
  end
end

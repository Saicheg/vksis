require_relative 'bit_stuffer'
require_relative 'exceptions'
require 'digest/crc16'
#----------#----------#---------#---------#---------#
#   flag   #  dest    #  source #  data   #   crc   #
#----------#----------#---------#---------#---------#
#   1b         1b        1b         21b        2b      26b

DESTINATION = 42
SOURCE = 24

class Package

  PARAMS = %w(flag dest source)

  def self.parse(data)
    { flag:   data[0..7].to_int_arr.first,
      dest:   data[8..15].to_int_arr.first,
      source: data[16..23].to_int_arr.first,
      data:   data[24..191],
      crc:    data[192..207] }
  end

  attr_reader :flag, :dest, :source, :data

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

  def initialize(data, flag=BitStuffer::FLAG, dest=DESTINATION, source=SOURCE, crc=nil)
    @flag = flag
    @dest = dest
    @source = source
    @data = build_data(data)
    raise InvalidPackageException if crc && crc != self.crc_bit
  end

  def info
    "#{flag_bit_str} #{dest_bit_str} #{source_bit_str} #{data_bit_str} #{crc_bit.join("")}"
  end

  def pkg_data
    [flag_bit, usefull_data, crc_bit].flatten
  end

  def crc
    Digest::CRC16.digest(usefull_data.join(""))
  end

  def crc_bit
    crc.to_byte_arr
  end

  def usefull_data
    [dest_bit, source_bit, data_bit].flatten
  end

  private

  def build_data(data)
    data << 0 while data.size != 21*8
    data
  end

end

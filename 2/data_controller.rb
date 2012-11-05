require_relative 'extensions'
require_relative 'bit_stuffer'
require_relative 'package'

class DataController

  attr_reader :data

  def initialize(data)
    @data = build_data(data)
  end

  def text
    text = packages.map{|pkg| pkg.data_bit}.flatten.to_string
    text.gsub("\x00", "")
  end

  def packages
    @packages ||= data_arr.map { |data| Package.new(data[:data], data[:flag], data[:dest], data[:source], data[:crc]) }
  end

  private

  def build_data(data)
    data.map do |pkg_data|
      pkg_data[0..7] + BitStuffer.unstuff(pkg_data[8..-1])
    end
  end

  def data_arr
    @data.map{|d| Package.parse(d)}
  end
end

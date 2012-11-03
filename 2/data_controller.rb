require_relative 'extensions'
require_relative 'bit_stuffer'
require_relative 'package'

class DataController

  attr_reader :data

  def initialize(data)
    @data = build_data(data)
  end

  def text
    data_arr = @data.map{|d| Package.parse(d)[:data]}.flatten
    data_arr.to_string.gsub("\x00", "")
  end

  private

  def build_data(data)
    data.map do |pkg_data|
      pkg_data[0..7] + BitStuffer.unstuff(pkg_data[8..-1])
    end
  end
end

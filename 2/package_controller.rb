require_relative 'extensions'
require_relative 'bit_stuffer'
require_relative 'package'

class PackageController

  attr_reader :packages

  def initialize(data)
    @data = BitStuffer.stuff(data.to_byte_arr)
    @packages = build_packages
  end

  def info
    packages.each_with_index.map { |pkg, i| "Pkg##{i}: #{pkg.info}" }
  end

  private

  def build_packages
  end

end

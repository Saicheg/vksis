require_relative 'extensions'
require_relative 'bit_stuffer'
require_relative 'package'

class PackageController

  attr_reader :packages

  def initialize(data)
    @data = data.to_byte_arr
    @packages = build_packages
  end

  def info
    packages.each_with_index.map { |pkg, i| "Pkg##{i}: #{pkg.info}" }
  end

  def encoded_data
    packages.map do |pkg|
      pkg_data = pkg.pkg_data
      # encode pkg data except flag
      pkg_data[0..7] + BitStuffer.stuff(pkg_data[8..-1])
    end
  end

  private

  def build_packages
    @data.each_slice(21*8).each_with_object([]) { |slice, arr| arr << Package.new(slice) }
  end

end

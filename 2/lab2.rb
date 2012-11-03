require 'pry'
require_relative 'extensions'
require_relative 'package_controller'
require_relative 'data_controller'

text = "~Lorem ipsum ~~~dolor si~t am~et,~ ~~consectetur adipiscing elit"

puts "Text:"
puts text

pkg_controller =  PackageController.new(text)
puts "Packages: "
pkg_controller.info.each {|info| puts info }

encoded_data = pkg_controller.encoded_data
data_controller = DataController.new(encoded_data)
text_recivied = data_controller.text

puts "Recivied text:"
puts text_recivied

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

puts "Recieved text:"
puts text_recivied


puts "Test"
arr = "011111100010101000011000010011000110111101110010011001010110110100100000011010010111000001110011011101010110110100100000011001000110111101101100011011110111001000100000011100110110100101110100 001110001001101101111110 00101010 00011000 001000000110000101101101011001010111010000101100001000000110001101101111011011100111001101100101011000110111010001100101011101000111010101110010000000000000000000000000 0010110010001110"
encoded_data = arr.gsub(" ", "").split("").each_slice(26*8).map{|slice| slice[0..7] + BitStuffer.stuff(slice[8..-1])}
data_controller = DataController.new(encoded_data)
@decoded_text.text = data_controller.text

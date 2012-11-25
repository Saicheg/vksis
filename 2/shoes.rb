require 'pry'
require 'extensions'
require 'exceptions'
require 'package_controller'
require 'data_controller'
require 'bit_stuffer'

Shoes.app :height => 600, :width => 800, :resizable => false, :title => 'Packages encoding' do
  background white

  stack :margin => 10 do

    @input_text = edit_box :width => 780, :height => 150 do |e|
      text = e.text

      pkg_controller =  PackageController.new(text)
      @pkg_info.text = pkg_controller.info.join("\n")

      encoded_data = pkg_controller.encoded_data
      data_controller = DataController.new(encoded_data)
      @decoded_text.text = data_controller.text
    end

    @text_button = button "Test", :margin_left => 715, :margin_top => 3 do
      begin
        data_controller = DataController.new(test_data)
        @pkg_info.text = data_controller.packages.map{|pkg|pkg.info}.join("\n")
        @decoded_text.text = data_controller.text
      rescue Exception
        alert("Wrong package!")
      end
    end

    @pkg_info = edit_box :margin_top => 10, :height => 240, :width => 780, :scroll => true do
      border black, :stokewidth => 1
    end

    @decoded_text = edit_box :margin_top => 10, :height => 150, :width => 780, :scroll => true do
      border black, :stokewidth => 1
    end
  end

  def test_data
    input_data = @input_text.text.gsub(" ", "").split("").map(&:to_i)
    input_data.each_slice(26*8).map{|slice| slice[0..7] + BitStuffer.stuff(slice[8..-1])}
  end

end

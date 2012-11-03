require 'extensions'
require 'package_controller'
require 'data_controller'

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

    @pkg_info = edit_box :margin_top => 10, :height => 270, :width => 780, :scroll => true do
      border black, :stokewidth => 1
    end

    @decoded_text = edit_box :margin_top => 10, :height => 150, :width => 780, :scroll => true do
      border black, :stokewidth => 1
    end
  end
  def add_message(message)
    @pkg_info.append { para message, :margin => 0}
  end

end

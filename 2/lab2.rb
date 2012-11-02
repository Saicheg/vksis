require 'pry'
require_relative 'extensions'
require_relative 'package_controller'
require_relative 'data_controller'

# text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
text = "Lorem ipsum elit"

pkg_controller =  PackageController.new(text)
pkg_controller.info
packages = pkg_controller.packages

data_controller = DataController.new(packages)
text = data_controller.data

require 'pry'
require 'appium_lib'

# Class to not pollute 'Object' class with appium methods
class AppiumWorld
end

if ENV['PLATAFORM'] == 'android'
  caps = Appium.load_appium_txt file: File.expand_path('../android/appium.txt', __FILE__), verbose: true
else
  caps = Appium.load_appium_txt file: File.expand_path('../ios/appium.txt', __FILE__), verbose: true
end

Appium::Driver.new(caps)
Appium.promote_appium_methods Object

World do
  AppiumWorld.new
end
#!/usr/bin/env ruby
# coding: utf-8
# ----------------------------------------------------------------------------
#
# $1 -> configuration environment (dev or jenkins)
# $2 -> device type. Builds for 'simulator' or 'device'
#
#
# REMEMBER to fill the configuration file build_app.yml

require 'fileutils'
require 'yaml'

# When running on CI
# It is a good pratice to run pod install when executing this script
# on the CI to avoid building problems
# %x(pod install)

# Parsing the yaml configuration file
config = YAML.load_file(File.join(File.dirname(__FILE__), 'build_app.yml'))

if ARGV.length < 2
  puts 'Error: Wrong number of arguments!'
  puts 'Usage: build_app.rb environment device_type'
  puts "Available Environments: #{config.keys.join(', ')}"
  puts "Device type: 'simulator' or 'device'"
  exit 1
end

puts "Starting at #{Time.now.strftime('%H:%M:%S')}"

if config[ARGV[0]].nil?
  puts 'Error: Wrong configuration environment!'
  puts "Available Environments: #{config.keys}"
  exit 1
else
  config = config[ARGV[0]]
end

export_path = File.join(config['export_path'], ARGV[1])

# Creating the folder where the .app will be stored
FileUtils.mkdir_p export_path

# Choosing the SDK for device or simulator
sdk = ''
if ARGV[1] == 'device'
  sdk = 'iphoneos'
else
  sdk = 'iphonesimulator'
end

puts 'Building project'

system <<eos
  xcodebuild -workspace "#{config['xcworkspace']}" \
  -scheme "#{config['scheme']}" -sdk "#{sdk}" \
  -configuration "#{config['configuration']}" clean build \
  CONFIGURATION_BUILD_DIR="#{export_path}"
eos

puts "APP_BUNDLE_PATH=#{File.join(export_path, config['scheme'])}.app"

puts "End: #{Time.now.strftime('%H:%M:%S')}"
puts 'Bye!'

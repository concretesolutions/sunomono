#!/usr/bin/env ruby
# coding: utf-8
# ----------------------------------------------------------------------------
#
# $1 -> configuration environment (dev or jenkins)
#
#
# REMEMBER to fill the configuration file build_app.yml

require 'fileutils'
require 'yaml'
require 'pathname'

# When running on CI
# It is a good pratice to run pod install when executing this script
# on the CI to avoid building problems
# %x(pod install)

# Parsing the yaml configuration file
config = YAML.load_file(File.join(File.dirname(__FILE__), 'build_app.yml'))

if ARGV.length != 1
  puts 'Error: Wrong number of arguments!'
  puts 'Usage: build_app.rb environment'
  puts "Available Environments: #{config.keys.join(', ')}"
  exit 1
end

if config[ARGV[0]].nil?
  puts 'Error: Wrong configuration environment!'
  puts "Available Environments: #{config.keys.join(', ')}"
  exit 1
else
  config = config[ARGV[0]]
end

puts "Starting at #{Time.now.strftime('%H:%M:%S')}"

# Creating a folder name from the destination configuration parameter
folder_name = config['destination'].gsub('platform=', '').gsub('name=', '')
              .tr(' ', '_').tr(',', '_')
export_path = File.join(config['export_path'], folder_name)

# Removing the folder where the .app will be stored if it already exists
FileUtils.rm_r export_path if Dir.exist?(export_path)

# Creating the folder where the .app will be stored
FileUtils.mkdir_p export_path

puts 'Building project'

system <<eos
  xcodebuild -workspace "#{config['xcworkspace']}" \
  -scheme "#{config['scheme']}" -destination "#{config['destination']}" \
  -configuration "#{config['configuration']}" clean build \
  CONFIGURATION_BUILD_DIR="#{export_path}"
eos

# Getting the app folder that was created
# Listing all folders on the export path folder
folders = Pathname.new(export_path).children.select { |c| c.directory? }
# Getting the folder which ends with .app
app_pathname = folders.select { |f| f.to_s.match('.app$') }
# Getting the app folder path
app_path = app_pathname.first.to_s

# Printing the APP_BUNDLE_PATH in the terminal
puts "APP_BUNDLE_PATH=#{app_path}"

puts "End: #{Time.now.strftime('%H:%M:%S')}"
puts 'Bye!'

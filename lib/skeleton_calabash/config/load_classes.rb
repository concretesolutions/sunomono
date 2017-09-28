# Choosing the platform using two environment vars that are mandatory for
# calabash-ios console execution.
# If they are not set, then we are executing a calabash android console
# otherwise, if they are set, then we are execution calabash ios console 
if ENV['APP_BUNDLE_PATH'].nil? && ENV['DEVICE_TARGET'].nil?
  platform = 'android'
else
  platform = 'ios'
end

puts "Loading #{platform} classes..."

features_path = File.join(File.expand_path('.', Dir.pwd), 'features')

# Loading the support ruby files
Dir[File.join(features_path, 'support', '*.rb')].each do |file|
  # We can't load hook files in calabash console context
  load file unless file.include? 'hooks.rb'
end

platform_path = File.join(features_path, platform)

# Loading all ruby files in the base screen path
Dir[File.join(platform_path, '*.rb')].each do |file|
  load file
end

# Loading all screens files
Dir[File.join(platform_path, 'screens', '*.rb')].each do |screen|
  load screen
end

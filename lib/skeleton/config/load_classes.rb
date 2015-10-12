# Choosing the platform using the current context LOAD PATH
# and looking for the gems of calabash
platform = ''
$LOAD_PATH.each do |path|
  platform = 'android' if path.include? 'calabash-android'
  platform = 'ios' if path.include? 'calabash-cucumber'
end

platform_path = File.join(File.expand_path('.', Dir.pwd), 'features', platform)

# Loading all ruby files in the base screen path
Dir[File.join(platform_path, '*.rb')].each do |file|
  load file
end

# Loading all screens files
Dir[File.join(platform_path, 'screens', '*.rb')].each do |screen|
  load screen
end

def create_feature_file(name, platform = nil)
  # options used to generate the file in the template function
  opts = { name: camelize(name) }

  # If platform is not nil than the feature is OS dependent
  file_path = ''
  if platform.nil?
    file_path = File.join(FileUtils.pwd, 'features', "#{name.downcase}.feature")
    opts[:platform] = ''
  else
    file_path = File.join(
      FileUtils.pwd, 'features', platform.downcase, 'features',
      "#{name.downcase}.feature"
    )
    opts[:platform] = platform
  end

  # Thor creates a file based on the templates/feature.tt template
  template('feature', file_path, opts)
end

def create_steps_file(name, platform = nil)
  # options used to generate the file in the template function
  opts = { name: camelize(name) }

  # If platform is not nil than the step is OS dependent
  file_path = nil
  if platform.nil?
    file_path = File.join(
      FileUtils.pwd, 'features', 'step_definitions',
      "#{name.downcase}_steps.rb"
    )
    opts[:platform] = ''
  else
    file_path = File.join(
      FileUtils.pwd, 'features', platform.downcase, 'step_definitions',
      "#{name.downcase}_steps.rb"
    )
    opts[:platform] = platform
  end

  # Thor creates a file based on the templates/steps.tt template
  template('steps', file_path, opts)
end

def create_screen_file(name, platform)
  # options used to generate the file in the template function
  opts = { name: camelize(name), platform: platform }

  # Thor creates a file based on the templates/screen.tt template
  template('screen',
           File.join(
             FileUtils.pwd, 'features', platform.downcase, 'screens',
             "#{name.downcase}_screen.rb"),
           opts)
end

def camelize(string)
  camelized = ''

  string.split('_').each do |s|
    camelized += s.capitalize
  end

  camelized
end

def in_root_project_folder?
  # Looks if the user is in the root folder of the project
  if !Dir.exist?(File.join(FileUtils.pwd, 'features', 'android', 'features')) ||
     !Dir.exist?(File.join(FileUtils.pwd, 'features', 'ios', 'features'))
    puts 'Please run this command on the root folder of the project'
    exit 1
  end

  true
end

def profile_configs
  build_app_path = File.join(FileUtils.pwd, 'config', "scripts", "ios", "build_app.yml")
  YAML.load_file(build_app_path)
end

def answer_profile
  @cli.say("\n")
  @cli.choose do |menu|
    menu.prompt = "\nPlease choose your profile config?  "
    profile_configs.keys.each do |profile|
      menu.choice(profile.to_sym) { return profile }
    end
  end
end

def answer_device_ios
  @cli.say("\n")
  devices = `instruments -s devices || exit`
  device = @cli.choose do |menu|
    menu.prompt = "\nPlease choose your device? "
    devices.each_line do |line|
      menu.choice(line.strip) if /\[(.+)\]/ =~ line
    end
  end
  /\[(.+)\]/.match(device).captures.first
end

def profile_exist?(profile)
  profile_configs.keys.include?(profile)
end

def project_folder_by_xcworkspace(xcworkspace)
  filename = xcworkspace.split('/').last
  xcworkspace.chomp(filename)
end

def ios_project_build_exist?(project_build)
  File.exist?(project_build)
end

def uuid_get_type_target(uuid)
  options[:device].include?("-") ? "simulator" : "device"
end
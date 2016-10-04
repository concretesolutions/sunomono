# -*- coding: utf-8 -*-
require_relative 'zip_helpers'

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
             "#{name.downcase}_screen.rb"
           ), opts)
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

def create_zip_folder(dir)
  file_name = "#{Time.now.strftime('%Y%m%d%H%M%S')}_specs.zip"
  zf = ZipFileGenerator.new(dir, file_name)
  zf.write
  say_status(:create, file_name)
end

# Looks for special chars in the specs folder
def special_chars_in_exported_path?
  entries = `grep -inrE 'á|â|ã|é|ê|í|ó|õ|ô|ú|ç' . --exclude-dir={.git,screenshots,config,support,test_servers} --exclude='*.zip'`
  if entries.count("\n") > 0
    puts_special_chars_error_message(entries)
    exit 1
  end
end

def puts_special_chars_error_message(entries)
  puts <<-EOF
There are special chars in your specs.
This can block AWS Device Farm execution.'
Entries found:
#{entries}

To skip this validation use: '--skip-char-validation'
Exiting..."
EOF
end

# Copies all folders and files from specs that are valid in AWS context
def copy_all_project_files(dir)
  directory FileUtils.pwd, dir,
            exclude_pattern: /(.git|.DS_Store|.irb-history|.gitignore|.gitkeep|screenshot|.apk|.zip)/
  # Replacing launcher files to avoid problems with AWS Device Farm
  copy_file File.join(File.dirname(__FILE__), '..', 'aws',
                      'android', 'app_installation_hooks.rb'),
            File.join(dir, 'features', 'android',
                      'support', 'app_installation_hooks.rb'),
            force: true
  copy_file File.join(File.dirname(__FILE__), '..', 'aws',
                      'android', 'app_life_cycle_hooks.rb'),
            File.join(dir, 'features', 'android',
                      'support', 'app_life_cycle_hooks.rb'),
            force: true
  copy_file File.join(File.dirname(__FILE__), '..', 'aws',
                      'ios', '01_launch.rb'),
            File.join(dir, 'features', 'ios',
                      'support', '01_launch.rb'),
            force: true
end

def create_screen_shot_dirs(dir)
  Dir.mkdir File.join(dir, 'screenshots')
  Dir.mkdir File.join(dir, 'screenshots', 'ios')
  Dir.mkdir File.join(dir, 'screenshots', 'android')
end

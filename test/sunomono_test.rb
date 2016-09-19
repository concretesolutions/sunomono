require 'sunomono'

describe Sunomono do

  before(:all) do
    @project_name = 'Sunomono_test'

    FileUtils.rm_rf(@project_name) if Dir.exist? @project_name
  end

  after(:each) do
    FileUtils.rm_rf(@project_name)
  end

  it 'Create new project' do
    system "sunomono new '#{@project_name}'"

    expect(Dir.entries(@project_name)).to include('screenshots', 'features', 'config', 'README.md', 'Gemfile', '.gitignore')
    # Features files
    expect(Dir.entries("#{@project_name}/features")).to include('android', 'ios', 'step_definitions', 'support')
    expect(Dir.entries("#{@project_name}/features/android")).to include('android_screen_base.rb', 'features', 'screens', 'step_definitions', 'support')
    expect(Dir.entries("#{@project_name}/features/ios")).to include('ios_screen_base.rb', 'features', 'screens', 'step_definitions', 'support')
    expect(Dir.entries("#{@project_name}/features/step_definitions")).to include('base_steps.rb')
    expect(Dir.entries("#{@project_name}/features/support")).to include('env.rb', 'exceptions.rb')

    # Config files
    expect(Dir.entries("#{@project_name}/config")).to include('cucumber.yml', 'email', 'load_classes.rb', 'scripts')

    # Email files
    expect(Dir.entries("#{@project_name}/config/email")).to include('template.html')

    # Scripts files
    expect(Dir.entries("#{@project_name}/config/scripts")).to include('android', 'break_build_if_failed.sh', 'check_if_tests_failed.sh', 'ios')
    expect(Dir.entries("#{@project_name}/config/scripts/android")).to include('run_tests_all_devices.sh', 'start_emulators.sh', 'stop_emulators.sh')
    expect(Dir.entries("#{@project_name}/config/scripts/ios")).to include('.', '..', 'build_app.rb', 'build_app.yml', 'devices.txt', 'run_tests_all_devices.sh')
  end

  it 'Create new project using alias command' do
    system "suno new '#{@project_name}'"

    expect(Dir.entries(@project_name)).to include('screenshots', 'features', 'config', 'README.md', 'Gemfile', '.gitignore')
    # Features files
    expect(Dir.entries("#{@project_name}/features")).to include('android', 'ios', 'step_definitions', 'support')
    expect(Dir.entries("#{@project_name}/features/android")).to include('android_screen_base.rb', 'features', 'screens', 'step_definitions', 'support')
    expect(Dir.entries("#{@project_name}/features/ios")).to include('ios_screen_base.rb', 'features', 'screens', 'step_definitions', 'support')
    expect(Dir.entries("#{@project_name}/features/step_definitions")).to include('base_steps.rb')
    expect(Dir.entries("#{@project_name}/features/support")).to include('env.rb', 'exceptions.rb')

    # Config files
    expect(Dir.entries("#{@project_name}/config")).to include('cucumber.yml', 'email', 'load_classes.rb', 'scripts')

    # Email files
    expect(Dir.entries("#{@project_name}/config/email")).to include('template.html')

    # Scripts files
    expect(Dir.entries("#{@project_name}/config/scripts")).to include('android', 'break_build_if_failed.sh', 'check_if_tests_failed.sh', 'ios')
    expect(Dir.entries("#{@project_name}/config/scripts/android")).to include('run_tests_all_devices.sh', 'start_emulators.sh', 'stop_emulators.sh')
    expect(Dir.entries("#{@project_name}/config/scripts/ios")).to include('.', '..', 'build_app.rb', 'build_app.yml', 'devices.txt', 'run_tests_all_devices.sh')
  end

  it 'Try creates new project with a invalid argument' do
    system "suno new '#{@project_name}' invalid argument"

    expect(Dir.entries(".")).not_to include("#{@project_name}")
  end

  it 'Should return the latest version of sunonomo' do
    system "sunomono version"
    version = "#{Sunomono::VERSION}"

    expect(version).to end_with('0.2.0.pre')
  end

  it 'Should return the latest version of sunonomo using alias command' do
    system "suno version"
    version = "#{Sunomono::VERSION}"

    expect(version).to end_with('0.2.0.pre')
  end

  it 'Generates an OS independent feature' do
    system "sunomono new '#{@project_name}'" if Dir.exist? @project_name
    puts Dir.pwd
    Dir.chdir(@project_name)
    puts Dir.pwd
    feature = 'test'
    puts "antes de gerar"
    system "suno generate feature '#{feature}'"
    puts "gerei"
    puts Dir.exists? 'features'
    puts @project_name

    expect(Dir.entries("#{@project_name}/features")).should include("#{feature}.feature")
    expect(Dir.entries("#{@project_name}/features/step_definitions")).to include("#{feature}_steps.rb")
    expect(Dir.entries("#{@project_name}/features/android/screens")).to include("#{feature}_screen.rb")
    expect(Dir.entries("#{@project_name}/features/ios/screens")).to include("#{feature}_screen.rb")
  end

  it 'Generates an OS independent feature with a invalid argument' do
    system "sunomono new '#{@project_name}'"
    feature = 'test'
    Dir.chdir(@project_name)
    system "suno generate feature '#{feature}' invalid_argument"

    expect(Dir.entries("#{@project_name}/features")).should_not include("#{feature}.feature")
    expect(Dir.entries("#{@project_name}/features/step_definitions")).should_not include("#{feature}_steps.rb")
    expect(Dir.entries("#{@project_name}/features/android/screens")).should_not include("#{feature}_screen.rb")
    expect(Dir.entries("#{@project_name}/features/ios/screens")).should_not include("#{feature}_screen.rb")
  end
end
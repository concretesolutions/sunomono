require 'sunomono'

describe Sunomono do

  before(:each) do
    @directory = Dir.pwd
    @project_name = 'Sunomono_test'
    @feature_name = 'sunomono'
    @appium = 'appium'
    @appium_upcase = 'APPIUM'
  end

  after(:each) do
    Dir.chdir(@directory)
    FileUtils.rm_rf(@project_name)
  end

  describe 'Sunomono gem commands to create appium based files' do
    context 'Returns project created with all files' do
      it 'Create new project using default command' do
        system "sunomono new '#{@appium}' '#{@project_name}' > /dev/null"

        expect(Dir.entries(@project_name)).
            to include('screenshots', 'features', 'config', 'README.md', 'Gemfile', '.gitignore')
        # Features files
        expect(Dir.entries("#{@project_name}/features")).
            to include('android', 'ios', 'step_definitions', 'support')
        expect(Dir.entries("#{@project_name}/features/android")).
            to include('features', 'screens', 'step_definitions', 'support')
        expect(Dir.entries("#{@project_name}/features/ios")).
            to include('features', 'screens', 'step_definitions')
        expect(Dir.entries("#{@project_name}/features/step_definitions")).
            to include('base_steps.rb')
        expect(Dir.entries("#{@project_name}/features/support")).
            to include('env.rb', 'exceptions.rb', 'android', 'ios')
        expect(Dir.entries("#{@project_name}/features/base_screen")).
            to include('base_screen.rb')

        # Config files
        expect(Dir.entries("#{@project_name}/config")).
            to include('cucumber.yml', 'email', 'scripts')

        # Email files
        expect(Dir.entries("#{@project_name}/config/email")).
            to include('template.html')

        # Scripts files
        expect(Dir.entries("#{@project_name}/config/scripts")).
            to include('android', 'break_build_if_failed.sh', 'check_if_tests_failed.sh', 'ios')
        expect(Dir.entries("#{@project_name}/config/scripts/android")).
            to include('run_tests_all_devices.sh', 'start_emulators.sh', 'stop_emulators.sh')
        expect(Dir.entries("#{@project_name}/config/scripts/ios")).
            to include('.', '..', 'build_app.rb', 'build_app.yml', 'devices.txt', 'run_tests_all_devices.sh')
      end
    end

    context 'Returns project created' do
      it 'Create new project using upcase word' do
        system "sunomono new '#{@appium_upcase}' '#{@project_name}' > /dev/null"

        expect(Dir.entries(@project_name)).
            to include('screenshots', 'features', 'config', 'README.md', 'Gemfile', '.gitignore')
      end
    end

    context 'Try creates new project with a invalid argument' do
      it 'Project will not be generated' do
        system "suno new '#{@appium}' '#{@project_name}' invalid argument  > /dev/null"

        expect(Dir.entries(".")).
            not_to include("#{@project_name}")
      end
    end

    context 'Generate Feature' do
      it 'Generates all files' do
        system "sunomono new '#{@appium}' '#{@project_name}'  > /dev/null"

        Dir.chdir(@project_name)

        system "sunomono generate calabash-feature '#{@feature_name}'  > /dev/null"

        expect(Dir.entries("features")).
            to include("#{@feature_name}.feature")
        expect(Dir.entries("features/step_definitions")).
            to include("#{@feature_name}_steps.rb")
        expect(Dir.entries("features/android/screens")).
            to include("#{@feature_name}_screen.rb")
        expect(Dir.entries("features/ios/screens")).
            to include("#{@feature_name}_screen.rb")
      end

      it 'Generates with alias command g' do
        system "suno new '#{@appium}' '#{@project_name}'  > /dev/null"

        Dir.chdir(@project_name)

        system "suno g calabash-feature '#{@feature_name}'  > /dev/null"

        expect(Dir.entries("features")).
            to include("#{@feature_name}.feature")
        expect(Dir.entries("features/step_definitions")).
            to include("#{@feature_name}_steps.rb")
        expect(Dir.entries("features/android/screens")).
            to include("#{@feature_name}_screen.rb")
        expect(Dir.entries("features/ios/screens")).
            to include("#{@feature_name}_screen.rb")
      end
    end

    context 'Try Generates a feature with a invalid argument' do
      it 'Feature will be not created' do
        system "sunomono new '#{@appium}' '#{@project_name}'  > /dev/null"

        Dir.chdir(@project_name)

        system "sunomono generate calabash-feature '#{@feature_name}' invalid_argument  > /dev/null"

        expect(Dir.entries("features")).
            not_to include("#{@feature_name}.feature")
        expect(Dir.entries("features/step_definitions")).
            not_to include("#{@feature_name}_steps.rb")
        expect(Dir.entries("features/android/screens")).
            not_to include("#{@feature_name}_screen.rb")
        expect(Dir.entries("features/ios/screens")).
            not_to include("#{@feature_name}_screen.rb")
      end

      it 'Feature will be not created using alias command suno with a invalid argument' do
        system "suno new '#{@appium}' '#{@project_name}'", :out => File::NULL

        Dir.chdir(@project_name)

        system "suno generate calabash-feature '#{@feature_name}' invalid_argument  > /dev/null"

        expect(Dir.entries("features")).
            not_to include("#{@feature_name}.feature")
        expect(Dir.entries("features/step_definitions")).
            not_to include("#{@feature_name}_steps.rb")
        expect(Dir.entries("features/android/screens")).
            not_to include("#{@feature_name}_screen.rb")
        expect(Dir.entries("features/ios/screens")).
            not_to include("#{@feature_name}_screen.rb")
      end


      it 'Feature will be not created using alias command with a invalid argument' do
        system "suno new '#{@appium}' '#{@project_name}'  > /dev/null"

        Dir.chdir(@project_name)

        system "suno g calabash-feature '#{@feature_name}' invalid_argument  > /dev/null"

        expect(Dir.entries("features")).
            not_to include("#{@feature_name}.feature")
        expect(Dir.entries("features/step_definitions")).
            not_to include("#{@feature_name}_steps.rb")
        expect(Dir.entries("features/android/screens")).
            not_to include("#{@feature_name}_screen.rb")
        expect(Dir.entries("features/ios/screens")).
            not_to include("#{@feature_name}_screen.rb")
      end
    end

    context 'Generates an OS independent step' do
      it 'Cant generates .feature and screens files' do
        system "suno new #{@appium} #{@project_name}  > /dev/null"

        Dir.chdir(@project_name)

        system "sunomono generate step #{@feature_name}  > /dev/null"

        expect(Dir.entries("features")).
            not_to include("#{@feature_name}.feature")
        expect(Dir.entries("features/android")).
            not_to include("#{@feature_name}_screen.rb")
        expect(Dir.entries("features/ios")).
            not_to include("#{@feature_name}_screen.rb")
      end
    end

    context 'Generates an OS indenpendent screen' do
      it 'Cant generates .feature and step_definition files' do
        system "suno new #{@appium} #{@project_name}  > /dev/null"

        Dir.chdir(@project_name)

        system "sunomono generate screen #{@appium} #{@feature_name}  > /dev/null"

        expect(Dir.entries("features")).
            not_to include("#{@feature_name}.feature")
        expect(Dir.entries("features/step_definitions")).
            not_to include("#{@feature_name}_steps.rb")
      end
    end

    context 'commands to generates an Android dependent files' do
      it 'Create folders to android plataform' do
        system "suno new #{@appium} #{@project_name}  > /dev/null"

        Dir.chdir(@project_name)

        system "suno generate android-feature #{@appium} #{@feature_name}  > /dev/null"

        expect(Dir.entries("features/android/features")).
            to include("#{@feature_name}.feature")
        expect(Dir.entries("features/android/step_definitions")).
            to include("#{@feature_name}_steps.rb")
        expect(Dir.entries("features/android/screens")).
            to include("#{@feature_name}_screen.rb")
      end

      it 'Create screen to android plataform' do
        system "suno new #{@appium} #{@project_name}  > /dev/null"

        Dir.chdir(@project_name)

        system "suno generate android-screen #{@appium} #{@feature_name}  > /dev/null"

        expect(Dir.entries("features/android/features")).
            not_to include("#{@feature_name}.feature")
        expect(Dir.entries("features/android/step_definitions")).
            not_to include("#{@feature_name}_steps.rb")
      end

      it 'Create step to android plataform' do
        system "suno new #{@appium} #{@project_name}  > /dev/null"

        Dir.chdir(@project_name)

        system "suno generate android-step #{@feature_name}  > /dev/null"

        expect(Dir.entries("features/android/features")).
            not_to include("#{@feature_name}.feature")
        expect(Dir.entries("features/android/screens")).
            not_to include("#{@feature_name}_screen.rb")
      end
    end

    context 'commands to generates an IOS dependent files' do
      it 'Create folders to IOS plataform' do
        system "suno new #{@appium}  #{@project_name}  > /dev/null"

        Dir.chdir(@project_name)

        system "suno generate ios-feature #{@appium} #{@feature_name}  > /dev/null"

        expect(Dir.entries("features/ios/features")).
            to include("#{@feature_name}.feature")
        expect(Dir.entries("features/ios/step_definitions")).
            to include("#{@feature_name}_steps.rb")
        expect(Dir.entries("features/ios/screens")).
            to include("#{@feature_name}_screen.rb")
      end

      it 'Create screen to IOS plataform' do
        system "suno new #{@appium} #{@project_name}  > /dev/null"

        Dir.chdir(@project_name)

        system "suno generate ios-screen #{@appium} #{@feature_name}  > /dev/null"

        expect(Dir.entries("features/ios/features")).
            not_to include("#{@feature_name}.feature")
        expect(Dir.entries("features/ios/step_definitions")).
            not_to include("#{@feature_name}_steps.rb")
      end

      it 'Create step to IOS plataform' do
        system "suno new #{@appium} #{@project_name}  > /dev/null"

        Dir.chdir(@project_name)

        system "suno generate ios-step #{@feature_name} > /dev/null"

        expect(Dir.entries("features/ios/features")).
            not_to include("#{@feature_name}.feature")
        expect(Dir.entries("features/ios/screens")).
            not_to include("#{@feature_name}_screen.rb")
      end
    end
  end
end


require 'sunomono'

describe Sunomono do

  before(:each) do
    @directory = Dir.pwd
    @project_name = 'Sunomono_test'
    @feature_name = 'sunomono'
    @calabash = 'calabash'
  end

  after(:each) do
    Dir.chdir(@directory)
    FileUtils.rm_rf(@project_name)
  end

  describe 'Sunomono gem commands to create calabash based files' do
    context 'Returns project created with all files' do
      it 'Create new project using default command' do
        system "sunomono new '#{@calabash}' '#{@project_name}' > /dev/null"

        expect(Dir.entries(@project_name)).
            to include('screenshots', 'features', 'config', 'README.md', 'Gemfile', '.gitignore')
        # Features files
        expect(Dir.entries("#{@project_name}/features")).
            to include('android', 'ios', 'step_definitions', 'support')
        expect(Dir.entries("#{@project_name}/features/android")).
            to include('android_screen_base.rb', 'features', 'screens', 'step_definitions', 'support')
        expect(Dir.entries("#{@project_name}/features/ios")).
            to include('ios_screen_base.rb', 'features', 'screens', 'step_definitions', 'support')
        expect(Dir.entries("#{@project_name}/features/step_definitions")).
            to include('base_steps.rb')
        expect(Dir.entries("#{@project_name}/features/support")).
            to include('env.rb', 'exceptions.rb')

        # Config files
        expect(Dir.entries("#{@project_name}/config")).
            to include('cucumber.yml', 'email', 'load_classes.rb', 'scripts')

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

    context 'Try creates new project with a invalid argument' do
      it 'Project will not be generated' do
        system "suno new '#{@calabash}' '#{@project_name}' invalid argument  > /dev/null"

        expect(Dir.entries(".")).
            not_to include("#{@project_name}")
      end
    end

    context 'Generate Feature' do
      it 'Generates all files' do
        system "sunomono new '#{@calabash}' '#{@project_name}'  > /dev/null"

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

      it 'Generate feature in pt' do
        system "suno new '#{@calabash}' '#{@project_name}' > /dev/null"

        Dir.chdir(@project_name)

        system "suno generate calabash-feature '#{@feature_name}' --lang=pt > /dev/null"

        expect(File.readlines("features/#{@feature_name}.feature")).
            to include("# language: pt\n", "Funcionalidade: #{@feature_name.capitalize} \n", "\n", "  Contexto:\n", "    # Insira os passos\n", "    \n", "  Cenário: Primeiro Cenario\n", "    # Insira os passos\n")
        expect(File.readlines("features/step_definitions/#{@feature_name}_steps.rb")).
            to include("######### DADO #########\n", "\n", "######### QUANDO #########\n", "\n", "######### ENTãO #########")
      end

      it 'Generate feature in en' do
        system "suno new '#{@calabash}' '#{@project_name}' > /dev/null"

        Dir.chdir(@project_name)

        system "suno generate calabash-feature '#{@feature_name}' > /dev/null"

        expect(File.readlines("features/#{@feature_name}.feature")).
            to include("# language: en\n", "Feature: #{@feature_name.capitalize} \n", "\n", "  Background:\n", "    # Insert steps\n", "    \n", "  Scenario: First Scenario\n", "    # Insert steps\n")
        expect(File.readlines("features/step_definitions/#{@feature_name}_steps.rb")).
            to include("######### GIVEN #########\n", "\n", "######### WHEN #########\n", "\n", "######### THEN #########")
      end

      it 'Generates with alias command g' do
        system "suno new '#{@calabash}' '#{@project_name}'  > /dev/null"

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
        system "sunomono new '#{@calabash}' '#{@project_name}'  > /dev/null"

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
        system "suno new '#{@calabash}' '#{@project_name}'", :out => File::NULL

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
        system "suno new '#{@calabash}' '#{@project_name}'  > /dev/null"

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
        system "suno new #{@calabash} #{@project_name}  > /dev/null"

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
        system "suno new #{@calabash} #{@project_name}  > /dev/null"

        Dir.chdir(@project_name)

        system "sunomono generate screen #{@calabash} #{@feature_name}  > /dev/null"

        expect(Dir.entries("features")).
            not_to include("#{@feature_name}.feature")
        expect(Dir.entries("features/step_definitions")).
            not_to include("#{@feature_name}_steps.rb")
      end
    end

    context 'commands to generates an Android dependent files' do
      it 'Create folders to android plataform' do
        system "suno new #{@calabash} #{@project_name}  > /dev/null"

        Dir.chdir(@project_name)

        system "suno generate android-feature #{@calabash} #{@feature_name}  > /dev/null"

        expect(Dir.entries("features/android/features")).
            to include("#{@feature_name}.feature")
        expect(Dir.entries("features/android/step_definitions")).
            to include("#{@feature_name}_steps.rb")
        expect(Dir.entries("features/android/screens")).
            to include("#{@feature_name}_screen.rb")
      end

      it 'Create screen to android plataform' do
        system "suno new #{@calabash} #{@project_name}  > /dev/null"

        Dir.chdir(@project_name)

        system "suno generate android-screen #{@calabash} #{@feature_name}  > /dev/null"

        expect(Dir.entries("features/android/features")).
            not_to include("#{@feature_name}.feature")
        expect(Dir.entries("features/android/step_definitions")).
            not_to include("#{@feature_name}_steps.rb")
      end

      it 'Create step to android plataform' do
        system "suno new #{@calabash} #{@project_name}  > /dev/null"

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
        system "suno new #{@calabash}  #{@project_name}  > /dev/null"

        Dir.chdir(@project_name)

        system "suno generate ios-feature #{@calabash} #{@feature_name}  > /dev/null"

        expect(Dir.entries("features/ios/features")).
            to include("#{@feature_name}.feature")
        expect(Dir.entries("features/ios/step_definitions")).
            to include("#{@feature_name}_steps.rb")
        expect(Dir.entries("features/ios/screens")).
            to include("#{@feature_name}_screen.rb")
      end

      it 'Create screen to IOS plataform' do
        system "suno new #{@calabash} #{@project_name}  > /dev/null"

        Dir.chdir(@project_name)

        system "suno generate ios-screen #{@calabash} #{@feature_name}  > /dev/null"

        expect(Dir.entries("features/ios/features")).
            not_to include("#{@feature_name}.feature")
        expect(Dir.entries("features/ios/step_definitions")).
            not_to include("#{@feature_name}_steps.rb")
      end

      it 'Create step to IOS plataform' do
        system "suno new #{@calabash} #{@project_name}  > /dev/null"

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


require 'sunomono'

describe Sunomono do

  before(:each) do
    @project_name = 'Sunomono_test'
  end

  after(:each) do
    FileUtils.rm_rf(@project_name)
  end

  describe 'Sunomono gem commands' do
    context 'Returns project created with all files' do
      it 'Create new project using default command' do
        system "sunomono new '#{@project_name}'", :out => File::NULL

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

      it 'Create new project using alias command' do
        system "suno new '#{@project_name}'", :out => File::NULL

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
        system "suno new '#{@project_name}' invalid argument", :out => File::NULL

        expect(Dir.entries(".")).
            not_to include("#{@project_name}")
      end
    end

    context 'Should return the latest version of sunonomo' do
      it 'Returns the latest version' do
        system "sunomono version", :out => File::NULL
        version = "#{Sunomono::VERSION}"

        expect(version).
            to end_with('0.2.0.pre')
      end


      it 'Should return the latest version of sunonomo using alias command' do
        system "suno version", :out => File::NULL
        version = "#{Sunomono::VERSION}"

        expect(version).
            to end_with('0.2.0.pre')
      end
    end

    context 'Using I18n to translate files' do
      it 'Generate an OS independent feature using I18n to portuguese language' do
        system "suno new '#{@project_name}'", :out => File::NULL

        feature_name = 'sunomono'

        Dir.chdir(@project_name)

        system "suno generate feature '#{feature_name}' --lang=pt", :out => File::NULL

        Dir.chdir('../')

        expect(File.readlines("#{@project_name}/features/#{feature_name}.feature")).
            to include("# language: pt\n", "Funcionalidade: #{feature_name.capitalize} \n", "\n", "  Contexto:\n", "    # Insira os passos\n", "    \n", "  Cenário: Primeiro Cenario\n", "    # Insira os passos\n")
        expect(File.readlines("#{@project_name}/features/step_definitions/#{feature_name}_steps.rb")).
            to include("######### DADO #########\n", "\n", "######### QUANDO #########\n", "\n", "######### ENTãO #########")
      end

      it 'Generate an OS independent feature using english language' do
        system "suno new '#{@project_name}'", :out => File::NULL

        feature_name = 'sunomono'

        Dir.chdir(@project_name)

        system "suno generate feature '#{feature_name}'", :out => File::NULL

        Dir.chdir('../')

        expect(File.readlines("#{@project_name}/features/#{feature_name}.feature")).
            to include("# language: en\n", "Feature: #{feature_name.capitalize} \n", "\n", "  Background:\n", "    # Insert steps\n", "    \n", "  Scenario: First Scenario\n", "    # Insert steps\n")
        expect(File.readlines("#{@project_name}/features/step_definitions/#{feature_name}_steps.rb")).
            to include("######### GIVEN #########\n", "\n", "######### WHEN #########\n", "\n", "######### THEN #########")
      end
    end

    context 'This command should generates an OS independent feature(all files)' do
      it 'Generates an OS independent feature' do
        system "sunomono new '#{@project_name}'", :out => File::NULL

        Dir.chdir(@project_name)

        feature_name = 'rspec_sunomono'

        system "sunomono generate feature '#{feature_name}'", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features")).
            to include('.', '..', 'android', 'ios', 'step_definitions', 'support', "#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/step_definitions")).
            to include("#{feature_name}_steps.rb")
        expect(Dir.entries("#{@project_name}/features/android/screens")).
            to include("#{feature_name}_screen.rb")
        expect(Dir.entries("#{@project_name}/features/ios/screens")).
            to include("#{feature_name}_screen.rb")
      end

      it 'Generates an OS independent feature with alias command suno' do
        system "suno new '#{@project_name}'", :out => File::NULL

        Dir.chdir(@project_name)

        feature_name = 'rspec_sunomono'

        system "suno generate feature '#{feature_name}'", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features")).
            to include('.', '..', 'android', 'ios', 'step_definitions', 'support', "#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/step_definitions")).
            to include("#{feature_name}_steps.rb")
        expect(Dir.entries("#{@project_name}/features/android/screens")).
            to include("#{feature_name}_screen.rb")
        expect(Dir.entries("#{@project_name}/features/ios/screens")).
            to include("#{feature_name}_screen.rb")
      end

      it 'Generates an OS independent feature with alias command g ' do
        system "suno new '#{@project_name}'", :out => File::NULL

        Dir.chdir(@project_name)

        feature_name = 'rspec_sunomono'

        system "suno g feature '#{feature_name}'", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features")).
            to include('.', '..', 'android', 'ios', 'step_definitions', 'support', "#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/step_definitions")).
            to include("#{feature_name}_steps.rb")
        expect(Dir.entries("#{@project_name}/features/android/screens")).
            to include("#{feature_name}_screen.rb")
        expect(Dir.entries("#{@project_name}/features/ios/screens")).
            to include("#{feature_name}_screen.rb")
      end
    end

    context 'Try Generates an OS independent feature with a invalid argument' do
      it 'Independent feature will be not created' do
        system "sunomono new '#{@project_name}'", :out => File::NULL

        feature_name = 'rspec_sunomono'

        Dir.chdir(@project_name)

        system "sunomono generate feature '#{feature_name}' invalid_argument", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features")).
            not_to include("#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/step_definitions")).
            not_to include("#{feature_name}_steps.rb")
        expect(Dir.entries("#{@project_name}/features/android/screens")).
            not_to include("#{feature_name}_screen.rb")
        expect(Dir.entries("#{@project_name}/features/ios/screens")).
            not_to include("#{feature_name}_screen.rb")
      end

      it 'Independent feature will be not created using alias command suno with a invalid argument' do
        system "suno new '#{@project_name}'", :out => File::NULL

        feature_name = 'rspec_sunomono'

        Dir.chdir(@project_name)

        system "suno generate feature '#{feature_name}' invalid_argument", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features")).
            not_to include("#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/step_definitions")).
            not_to include("#{feature_name}_steps.rb")
        expect(Dir.entries("#{@project_name}/features/android/screens")).
            not_to include("#{feature_name}_screen.rb")
        expect(Dir.entries("#{@project_name}/features/ios/screens")).
            not_to include("#{feature_name}_screen.rb")
      end


      it 'Independent feature will be not created using alias command  g with a invalid argument ' do
        system "suno new '#{@project_name}'", :out => File::NULL

        feature_name = 'rspec_sunomono'

        Dir.chdir(@project_name)

        system "suno g feature '#{feature_name}' invalid_argument", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features")).
            not_to include("#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/step_definitions")).
            not_to include("#{feature_name}_steps.rb")
        expect(Dir.entries("#{@project_name}/features/android/screens")).
            not_to include("#{feature_name}_screen.rb")
        expect(Dir.entries("#{@project_name}/features/ios/screens")).
            not_to include("#{feature_name}_screen.rb")
      end
    end

    context 'Generates an OS independent step' do
      it 'Command cant generates .feature and screens files' do
        system "suno new #{@project_name}", :out => File::NULL

        feature_name = 'sunomono'

        Dir.chdir(@project_name)

        system "sunomono generate step #{feature_name}", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features")).
            not_to include("#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/android")).
            not_to include("#{feature_name}_screen.rb")
        expect(Dir.entries("#{@project_name}/features/ios")).
            not_to include("#{feature_name}_screen.rb")
      end
    end

    context 'Generates an OS indenpendat screen' do
      it 'Comamand cant generates .feature and step_definition files ' do
        system "suno new #{@project_name}", :out => File::NULL

        feature_name = 'sunomono'

        Dir.chdir(@project_name)

        system "sunomono generate screen #{feature_name}", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features")).
            not_to include("#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/step_definitions")).
            not_to include("#{feature_name}_steps.rb")
      end
    end

    context 'commands to generates an Android dependent files' do
      it 'return created folders to android plataform' do
        system "suno new #{@project_name}", :out => File::NULL

        feature_name = 'sunomono'

        Dir.chdir(@project_name)

        system "suno g android-feature #{feature_name}", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features/android/features")).
            to include("#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/android/step_definitions")).
            to include("#{feature_name}_steps.rb")
        expect(Dir.entries("#{@project_name}/features/android/screens")).
            to include("#{feature_name}_screen.rb")
      end

      it 'return created screen to android plataform' do
        system "suno new #{@project_name}", :out => File::NULL

        feature_name = 'sunonomo'

        Dir.chdir(@project_name)

        system "suno g android-screen #{feature_name}", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features/android/features")).
            not_to include("#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/android/step_definitions")).
            not_to include("#{feature_name}_steps.rb")
      end

      it 'retrun created step to android plataform' do
        system "suno new #{@project_name}", :out => File::NULL

        feature_name = 'sunomono'

        Dir.chdir(@project_name)

        system "suno g android-step #{feature_name}", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features/android/features")).
            not_to include("#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/android/screens")).
            not_to include("#{feature_name}_screen.rb")
      end
    end

    context 'commands to generates an IOS dependent files' do
      it 'return created folders to IOS plataform' do
        system "suno new #{@project_name}", :out => File::NULL

        feature_name = 'sunomono'

        Dir.chdir(@project_name)

        system "suno g ios-feature #{feature_name}", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features/ios/features")).
            to include("#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/ios/step_definitions")).
            to include("#{feature_name}_steps.rb")
        expect(Dir.entries("#{@project_name}/features/ios/screens")).
            to include("#{feature_name}_screen.rb")
      end

      it 'return created screen to IOS plataform' do
        system "suno new #{@project_name}", :out => File::NULL

        feature_name = 'sunomono'

        Dir.chdir(@project_name)

        system "suno g ios-screen #{feature_name}", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features/ios/features")).
            not_to include("#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/ios/step_definitions")).
            not_to include("#{feature_name}_steps.rb")
      end

      it 'return created step to IOS plataform' do
        system "suno new #{@project_name}", :out => File::NULL

        feature_name = 'sunomono'

        Dir.chdir(@project_name)

        system "suno g ios-step #{feature_name}", :out => File::NULL

        Dir.chdir('../')

        expect(Dir.entries("#{@project_name}/features/ios/features")).
            not_to include("#{feature_name}.feature")
        expect(Dir.entries("#{@project_name}/features/ios/screens")).
            not_to include("#{feature_name}_screen.rb")
      end
    end
  end
end



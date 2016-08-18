require 'sunomono/version'

require 'thor'
require 'thor/group'
require 'i18n'
require 'gherkin' # Used here as a translation source
require 'json'
require 'yaml'

require_relative File.join('helpers', 'sunomono_helpers')

module Sunomono
  # Definition of all gem generators
  class Generate < Thor
    include Thor::Actions

    desc 'feature [RESOURCE_NAME]', 'Generates an OS independent feature'
    option :lang,
           banner: 'any of the gherkin supported languages',
           default: :en
    def feature(name)
      I18n.config.default_locale = options[:lang]
      in_root_project_folder?

      create_feature_file(name)
      create_steps_file name
      create_screen_file name, 'Android'
      create_screen_file name, 'IOS'
    end

    desc 'android-feature [RESOURCE_NAME]',
         'Generates an Android dependent feature'
    option :lang,
           banner: 'any of the gherkin supported languages',
           default: :en
    def android_feature(name)
      I18n.config.default_locale = options[:lang]
      in_root_project_folder?

      create_feature_file name, 'Android'
      create_steps_file name, 'Android'
      create_screen_file name, 'Android'
    end

    desc 'ios-feature [RESOURCE_NAME]', 'Generates an iOS dependent feature'
    option :lang,
           banner: 'any of the gherkin supported languages',
           default: :en
    def ios_feature(name)
      I18n.config.default_locale = options[:lang]
      in_root_project_folder?

      create_feature_file name, 'IOS'
      create_steps_file name, 'IOS'
      create_screen_file name, 'IOS'
    end

    desc 'step [RESOURCE_NAME]', 'Generates an OS independent step'
    option :lang,
           banner: 'any of the gherkin supported languages',
           default: :en
    def step(name)
      I18n.config.default_locale = options[:lang]
      in_root_project_folder?
      create_steps_file name
    end

    desc 'android-step [RESOURCE_NAME]', 'Generates an Android dependent step'
    option :lang,
           banner: 'any of the gherkin supported languages',
           default: :en
    def android_step(name)
      I18n.config.default_locale = options[:lang]
      in_root_project_folder?
      create_steps_file name, 'Android'
    end

    desc 'ios-step [RESOURCE_NAME]', 'Generates an iOS dependent step'
    option :lang,
           banner: 'any of the gherkin supported languages',
           default: :en
    def ios_step(name)
      I18n.config.default_locale = options[:lang]
      in_root_project_folder?
      create_steps_file name, 'IOS'
    end

    desc 'screen [RESOURCE_NAME]',
         'Generates the Android and iOS dependent screens'
    option :lang,
           banner: 'any of the gherkin supported languages',
           default: :en
    def screen(name)
      I18n.config.default_locale = options[:lang]
      in_root_project_folder?
      create_screen_file name, 'Android'
      create_screen_file name, 'IOS'
    end

    desc 'android-screen [RESOURCE_NAME]',
         'Generates an Android dependent screen'
    option :lang,
           banner: 'any of the gherkin supported languages',
           default: :en
    def android_screen(name)
      I18n.config.default_locale = options[:lang]
      in_root_project_folder?
      create_screen_file name, 'Android'
    end

    desc 'ios-screen [RESOURCE_NAME]', 'Generates an iOS dependent screen'
    option :lang,
           banner: 'any of the gherkin supported languages',
           default: :en
    def ios_screen(name)
      I18n.config.default_locale = options[:lang]
      in_root_project_folder?
      create_screen_file name, 'IOS'
    end

    desc 'aws-zip', 'Prepare a zip file for AWS Device Farm execution'
    option 'skip-char-validation',
           banner: 'skips the special chars validation that can cancel the zip creation',
           type: :boolean,
           lazy_default: true
    def aws_zip
      in_root_project_folder?

      special_chars_in_exported_path? unless options['skip-char-validation']

      # Temp folder that will hold the project files to be zipped
      dir = Dir.mktmpdir
      begin
        copy_all_project_files(dir)
        create_screen_shot_dirs(dir)
        # Creating zip file
        create_zip_folder(dir)
      ensure
        # remove the directory.
        FileUtils.remove_entry_secure dir
      end
    end

    def self.source_root
      File.join(File.dirname(__FILE__), '..', 'lib', 'templates')
    end
  end
end

module Sunomono
  # Definition of the generators groups
  class SunomonoRunner < Thor
    include Thor::Actions

    map '-v' => :version
    map '--version' => :version

    default_task :help

    register Sunomono::Generate, 'generate',
             'generate [GENERATOR] [RESOURCE_NAME]',
             'Generates various resources'
    register Sunomono::Generate, 'g',
             'g [GENERATOR] [RESOURCE_NAME]',
             'Generates various resources'

    desc 'new PROJECT_NAME',
         'Generates the structure of a new project that uses '\
         'Calabash in both Android and iOS apps'
    option :lang,
           banner: 'any of the gherkin supported languages',
           default: :en
    def new(name)
      I18n.config.default_locale = options[:lang]
      # Thor will be responsible to look for identical
      # files and possibles conflicts
      directory File.join(File.dirname(__FILE__),
                          '..', 'lib', 'skeleton'), name

      # Copying base steps file with localization
      template('base_steps', File.join(name, 'features', 'step_definitions',
                                       'base_steps.rb'))

      # Copying android screen base file with localization
      template('android_screen_base', File.join(name, 'features', 'android',
                                                'android_screen_base.rb'))

      # Copying ios screen base file with localization
      template('ios_screen_base',
               File.join(name, 'features', 'ios', 'ios_screen_base.rb'))
    end

    desc 'version', 'Shows the gem version'
    def version
      puts "Sunomono Version #{Sunomono::VERSION}"
    end

    def self.source_root
      File.join(File.dirname(__FILE__), '..', 'lib', 'templates')
    end

    # Overriding the initialize method to load all the
    # translations supported by the gem gherkin
    def initialize(*args)
      super
      # Loading gherkin accepted translations
      translations_file_path = File.join(
        Gem.loaded_specs['gherkin'].full_gem_path,
        'lib',
        'gherkin',
        'i18n.json'
      )
      # Parsing the JSON file
      # Removing the sequence *| and all the alternative
      # options for the gherkin translations
      translations_json = JSON.parse(
        File.read(translations_file_path)
        .gsub(/\*\|/, '')
        .gsub(/\|.*\"/, '"')
      )
      # Converting the translations to YAML and storing in a temp file
      translations_temp_file = Tempfile.new(['translations', '.yml'])
      File.write(translations_temp_file, translations_json.to_yaml)
      # Loading the translations from gherkin and from the
      # locales folder of this gem
      locales_folder_path = File.join(
        File.dirname(__FILE__),
        '..', 'lib', 'sunomono', 'locales'
      )
      I18n.load_path = Dir[
        translations_temp_file,
        File.join(locales_folder_path, '*.yml')
      ]
      I18n.backend.load_translations
      I18n.config.enforce_available_locales = true
    end
  end
end

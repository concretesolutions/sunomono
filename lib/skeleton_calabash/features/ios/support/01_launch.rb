########################################
#                                      #
#       Important Note                 #
#                                      #
#   When running calabash-ios tests at #
#   www.xamarin.com/test-cloud         #
#   the  methods invoked by            #
#   CalabashLauncher are overridden.   #
#   It will automatically ensure       #
#   running on device, installing apps #
#   etc.                               #
#                                      #
########################################

require 'calabash-cucumber/launcher'

module Calabash::Launcher
  @@launcher = nil
  def self.launcher
    @@launcher ||= Calabash::Cucumber::Launcher.new
  end

  def self.launcher=(launcher)
    @@launcher = launcher
  end
end

AfterConfiguration do
  FeatureMemory.feature = nil
end

Before do |scenario|
  launcher = Calabash::Launcher.launcher
  # Relaunch options
  options = { timeout: 3000 }

  scenario = scenario.scenario_outline if
    scenario.respond_to?(:scenario_outline)
  feature = scenario.feature

  scenario_tags = scenario.source_tag_names
  if FeatureMemory.feature != feature ||
     ENV['RESET_BETWEEN_SCENARIOS'] == '1' ||
     scenario_tags.include?('@reinstall')
    reinstall_app
    # Reset app if it is a new feature
    options[:reset] = true

    FeatureMemory.feature = feature
    FeatureMemory.invocation = 1
  else
    FeatureMemory.invocation += 1
  end

  FeatureMemory.feature = feature
  FeatureMemory.invocation = 1

  launcher.relaunch(options)
  # Avoid resetting when is not necessary
  options[:reset] = false
end

After do
  calabash_exit if launcher.quit_app_after_scenario?
end

def device?
  # Check if UUID (ENV['DEVICE_TARGET']) is from a device or a simulator
  # Getting all the simulator's UUID
  uuids = `xcrun simctl list`
  return false if uuids.include? ENV['DEVICE_TARGET']
  return true
end

def reinstall_app
  if device?
    system "echo 'Installing the app...'"
    # Trying to reinstall the app
    success = system "ios-deploy -r -b #{ENV['APP_BUNDLE_PATH']} -i #{ENV['DEVICE_TARGET']} -t 5 > /dev/null"

    # If the app is not installed the above command will throw an error
    # So we just install the app
    unless success
      success = system "ios-deploy -b #{ENV['APP_BUNDLE_PATH']} -i #{ENV['DEVICE_TARGET']} -t 5 > /dev/null"
      fail 'Error. Could not install the app.' unless
        success # If there is any error raises an exception
    end

    system "echo 'Installed.'"
    sleep(3) # Gives a time to finish the installation of the app in the device
  end
end

FeatureMemory = Struct.new(:feature, :invocation).new

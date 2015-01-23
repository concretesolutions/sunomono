########################################
#                                      #
#       Important Note                 #
#                                      #
#   When running calabash-ios tests at #
#   www.xamarin.com/test-cloud         #
#   the  methods invoked by            #
#   CalabashLauncher are overriden.    #
#   It will automatically ensure       #
#   running on device, installing apps #
#   etc.                               #
#                                      #
########################################

require 'calabash-cucumber/launcher'

# APP_BUNDLE_PATH = "~/Library/Developer/Xcode/DerivedData/??/Build/Products/Calabash-iphonesimulator/??.app"
# You may uncomment the above to overwrite the APP_BUNDLE_PATH
# However the recommended approach is to let Calabash find the app itself
# or set the environment variable APP_BUNDLE_PATH

Before('@reinstall') do |scenario|
  reinstall_app
end

Before do |scenario|
  
  # If the scenario is outline, to get the feature title we have to access a different attribute of the variable scenario,
  # so this function changes the value of the scenario variable so we don't have to do this on the verification step below 
  @scenario_is_outline = (scenario.class == Cucumber::Ast::OutlineTable::ExampleRow)
  if @scenario_is_outline 
    scenario = scenario.scenario_outline 
  end
  # Looks if is a new feature that will be executed
  if ENV['FEATURE_NAME'] != scenario.feature.title # ENV['FEATURE_NAME'] is just an aux created to store the feature name
    reinstall_app # always reinstall the app before a the execution of a new feature
    ENV['FEATURE_NAME'] = scenario.feature.title
  end 

  @calabash_launcher = Calabash::Cucumber::Launcher.new
  unless @calabash_launcher.calabash_no_launch?
    @calabash_launcher.relaunch
    @calabash_launcher.calabash_notify(self)
  end

end

After do |scenario|
  unless @calabash_launcher.calabash_no_stop?
    calabash_exit
    if @calabash_launcher.active?
      @calabash_launcher.stop
    end
  end
end

at_exit do
  launcher = Calabash::Cucumber::Launcher.new
  if launcher.simulator_target?
    launcher.simulator_launcher.stop unless launcher.calabash_no_stop?
  end
end

# Install or reinstall the app on the device
def reinstall_app

  if !is_simulator? ENV['DEVICE_TARGET']

    system "echo 'Installing the app...'"   

    # Trying to reinstall the app
    success = system "ios-deploy -r -b #{ENV['APP_BUNDLE_PATH']} -i #{ENV['DEVICE_TARGET']} -t 5 > /dev/null"

    # If the app is not installed the above command will throw an error
    # So we just install the app
    if !success
      success = system "ios-deploy -b #{ENV['APP_BUNDLE_PATH']} -i #{ENV['DEVICE_TARGET']} -t 5 > /dev/null"
      if !success # If there is any error raises an exception
        raise 'Error. Could not install the app.'
      end
    end

    system "echo 'Installed.'"

    sleep(3) # Gives to the iphone a time to finish the installation of the app
  else # If test is in a simulator

    # Shutdown all the booted simulators to avoid problems with the switch of simulatores
    # on the automated tests (like when on jenkins)
    shutdown_booted_simulators

    # APP_BUNDLE_ID must be set in order to uninstall the app from the simulator
    # You can either pass it as a parameter in the cucumber command or set it here
    #ENV["APP_BUNDLE_ID"] = "bundle_id"

    # Booting the device to avoid problems with the app installation
    %x(open -a 'iOS Simulator' --args -CurrentDeviceUDID #{ENV['DEVICE_TARGET']} > /dev/null)
    sleep(7)

    # Reinstalling the app using terminal commands
    system "echo 'Installing the app...'"
    
    # Removing the app
    %x(xcrun simctl uninstall #{ENV['DEVICE_TARGET']} #{ENV['APP_BUNDLE_ID']} > /dev/null)

    # Installing the app
    %x(xcrun simctl install #{ENV['DEVICE_TARGET']} #{ENV['APP_BUNDLE_PATH']} > /dev/null)

    system "echo 'Installed.'"

  end

end

# Checks if the UUID belongs to a Device or a Simulator
def is_simulator? uuid
  # Check if UUID is from a device or a simulator
  # Getting all the simulator's UUID
  uuids = `xcrun simctl list`
  return true if uuids.include? uuid
  return false
end

# Kill all simulators process, lists all the booted simulators and shut them down
def shutdown_booted_simulators

  # Closing all Simulators running
  %x(killall "iOS Simulator")
  
  # Listing all the booted devices
  booted_simulators = `xcrun simctl list | grep 'Booted'`

  # Getting the UUIDs
  booted_simulators.split("\n").each do |simulator|
    uuid = simulator.split("(")[1].gsub(")", "").gsub(" ","")
    # Shuting the simulator down
    %x(xcrun simctl shutdown #{uuid})
  end
    
end

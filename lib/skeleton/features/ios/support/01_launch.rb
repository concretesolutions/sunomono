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

Before do |scenario|
  @calabash_launcher = Calabash::Cucumber::Launcher.new

  @scenario_is_outline =
    (scenario.class == Cucumber::Ast::OutlineTable::ExampleRow)
  scenario = scenario.scenario_outline if @scenario_is_outline

  scenario_tags = scenario.source_tag_names
  # Resetting the app between scenarios
  # ENV['FEATURE_NAME'] is just an aux created to store the feature name
  if ENV['FEATURE_NAME'] != scenario.feature.title ||
     ENV['RESET_BETWEEN_SCENARIOS'] == '1' ||
     scenario_tags.include?('@reinstall')

    @calabash_launcher.reset_app_jail
    ENV['FEATURE_NAME'] = scenario.feature.title
  end

  unless @calabash_launcher.calabash_no_launch?
    @calabash_launcher.relaunch
    @calabash_launcher.calabash_notify(self)
  end
end

After do
  unless @calabash_launcher.calabash_no_stop?
    calabash_exit
    @calabash_launcher.stop if @calabash_launcher.active?
  end
end

at_exit do
  launcher = Calabash::Cucumber::Launcher.new
  if launcher.simulator_target?
    launcher.simulator_launcher.stop unless launcher.calabash_no_stop?
  end
end

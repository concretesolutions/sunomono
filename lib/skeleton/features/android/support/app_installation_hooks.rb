require 'calabash-android/management/app_installation'

AfterConfiguration do
  FeatureNameMemory.feature_name = nil
end

Before('@reinstall') do
  uninstall_apps
  install_app(ENV['TEST_APP_PATH'])
  install_app(ENV['APP_PATH'])
end

Before do |scenario|
  @scenario_is_outline =
    (scenario.class == Cucumber::Ast::OutlineTable::ExampleRow)
  scenario = scenario.scenario_outline if @scenario_is_outline

  feature_name = scenario.feature.title
  if FeatureNameMemory.feature_name != feature_name ||
     ENV['RESET_BETWEEN_SCENARIOS'] == '1'
    if ENV['RESET_BETWEEN_SCENARIOS'] == '1'
      log 'New scenario - reinstalling apps'
    else
      log 'First scenario in feature - reinstalling apps'
    end

    uninstall_apps
    install_app(ENV['TEST_APP_PATH'])
    install_app(ENV['APP_PATH'])

    FeatureNameMemory.feature_name = feature_name
    FeatureNameMemory.invocation = 1
  else
    FeatureNameMemory.invocation += 1
  end
end

FeatureNameMemory = Class.new
class << FeatureNameMemory
  @feature_name = nil
  attr_accessor :feature_name, :invocation
end

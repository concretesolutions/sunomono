require 'calabash-android/management/app_installation'

AfterConfiguration do |config|
  FeatureMemory.feature = nil
end

Before do |scenario|
  @scenario_is_outline = (scenario.class ==
    Cucumber::Ast::OutlineTable::ExampleRow)
  scenario = scenario.scenario_outline if @scenario_is_outlinel

  feature = scenario.feature
  if FeatureMemory.feature != feature || ENV['RESET_BETWEEN_SCENARIOS'] == '1'
    if ENV['RESET_BETWEEN_SCENARIOS'] == '1'
      log 'New scenario - reinstalling apps'
    else
      log 'First scenario in feature - reinstalling apps'
    end

    uninstall_apps
    install_app(ENV['TEST_APP_PATH'])
    install_app(ENV['APP_PATH'])
    FeatureMemory.feature = feature
    FeatureMemory.invocation = 1
  else
    FeatureMemory.invocation += 1
  end
end

FeatureMemory = Struct.new(:feature, :invocation).new

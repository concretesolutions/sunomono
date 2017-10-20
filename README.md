# Sunomono

[![Gem Version](https://badge.fury.io/rb/sunomono.svg)](https://badge.fury.io/rb/sunomono)  [![CircleCI](https://circleci.com/gh/concretesolutions/sunomono/tree/master.svg?style=svg)](https://circleci.com/gh/concretesolutions/sunomono/tree/master)

> ***The new version of [cs-bdd](https://rubygems.org/gems/cs-bdd) gem. cs-bdd was deprecated and will be yanked in the future. Always refer to sunomono from now on.***

A simple gem to generate all files needed in a project that will support calabash and appium for both Android and iOS.

iOS Build script works only with iOS SDK 9.2 or newer

Sunomono(calabash) documentation : [(link)](https://github.com/concretesolutions/sunomono/SUNOMONO_CALABASH.md)

Sunomono(appium) documentation :  [(link)](https://github.com/concretesolutions/sunomono/SUNOMONO_APPPIUM.md)

## Installation

Install it as:

    $ gem install sunomono

## Usage

In the terminal, type for help:

```
  suno
```

Or

```
  sunomono
```

To see the gem version type:

```
  suno version
```

To generate a project that support both Android and iOS features type:

```
  suno new calabash ProjectName
```

or 

```
  suno new appium Project Name
```

This command will create a folder named ProjectName in the current directory and will create all the needed files. This gem support localizations. To create a localized project, in Portuguese, type:

```
  suno new Framework(calabash or appium) ProjectName --lang=pt
```

If you use Windows, to avoid encoding problems, run the following command in cmd:

```
[HKEY_CURRENT_USER\Software\Microsoft\Command Processor] "AutoRun"="chcp 65001"
```


  > The default language is English ('en'). The elements of Gherkin such as Given, When, Then, And, Scenario will be translated to all Gherkin supported languages, but this gem has just a few translation files (see that in folder: `lib/sunomono/locales`).

  > **Sunomono doesn't support your mother language?** No problem. Fork it, create your yml translation file, uses the en.yml file as a template. Translate it and make a pull request. There are only 15 lines to be translated, this will take no time.

  > **Want to know how to name your translation yml file?** See the Gherkin supported languages [here](https://github.com/cucumber/gherkin/blob/master/lib/gherkin/i18n.json) for reference.

Once the project is created, open its folder (`cd ProjectName`) and run `bundle install`

  > Remember to fix the calabash-cucumber version on the Gemfile. When updating the calabash-cucumber gem version you need to update the Calabash framework that was embedded on your iOS code. So, my suggestion is to update it manually. [In this page](https://github.com/calabash/calabash-ios/wiki/B1-Updating-your-Calabash-iOS-version) you can find more information on how to update the Calabash framework.


There are nine generators that are responsible to create the templates for Features, Step definitions and Screens.

**The generators commands ONLY WORK in the ROOT FOLDER of the project**.

####Features

```
  suno generate feature FeatureName
```
The feature generator will create a Platform independent feature and its files. So this command will create the FeatureName.feature file inside the folder `feature`, the file FeatureName_steps.rb inside the folder `features/step_definitions`, the files FeatureName_screen.rb inside the folders `features/android/screens` and `features/ios/screens`.

To create calabash based files:

```
  suno generate calabash android-feature AndroidFeatureName
  suno generate calabash ios-feature iOSFeatureName
```

To create appium based files:

```
 suno generate appium android-feature AndroidFeatureName
 suno generate appium ios-feature iOSFeatureName

```

The aFeature and iFeature generator will create an Platform dependent feature. For example, the aFeature generator will create the AndroidFeatureName.feature file inside the folder `features/android/features`, the file AndroidFeatureName_steps.rb inside the folder `features/androd/step_definitions` and the screen file AndroidFeatureName_screen.rb inside the folder `features/android/screens`.


Don't forget about internationalization. All the generators accept the option `--lang=pt` or with some other language.

####Steps

```
  suno generate step StepName
```
The step generator will create a Platform independent step file named StepName_steps.rb in the folder `features/step_definitions`


```
  suno generate android-step AndroidStepName
```
The android-step generator will create an Android step file named AndroidStepName_steps.rb in the folder `features/android/step_definitions`


```
  suno generate ios-step iOSStepName
```
The iStep generator will create an iOS step file name iOSStepName_steps.rb in the folder `features/ios/step_definitions`



####Screens

```
  suno generate screen ScreenName
```
The screen generator will create both Platform dependent screens in the folders `features/android/screens` and `features/ios/screens`.

To create calabash based files:

```
  suno generate calabash android-screen AndroidScreenName
  suno generate calabash ios-screen iOSScreenName
```

To create appium based files:

```
  suno generate appium android-screen AndroidScreenName
  suno generate appium ios-screen iOSScreenName
```

The android-screen and ios-screen will create only the Android and iOS dependent screens respectively.

## Load Classes
**works only calabash project**
### Usage

The load classes has been living in: 

```
  features/config/load_classes.rb
```

load_classes.rb provides a easy way to test your methods under development


Use the calabash-android console mode 

````
  bundle exec calabash-android console  -p android feature/
````

or

````
  bundle exec calabash-ios console -p ios feature/
````

To load all .rb classes, run the following command on terminal

````
 load 'config/load_classes.rb'
````

Now you got all .rb files loaded, now you need instantiate the class to test your methods

```
 @foo = page(fooScreen)
```

To use the methods, just call the method and enjoy 

```
 @foo.fill_data
```


## Continuous Integration (CI)

The project contains a lot of scripts that will help you to configure you CI server.

> Documentation under development.


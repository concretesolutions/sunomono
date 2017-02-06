# Sunomono

[![Gem Version](https://badge.fury.io/rb/sunomono.svg)](https://badge.fury.io/rb/sunomono)  [![CircleCI](https://circleci.com/gh/concretesolutions/sunomono/tree/master.svg?style=svg)](https://circleci.com/gh/concretesolutions/sunomono/tree/master)

> ***The new version of [cs-bdd](https://rubygems.org/gems/cs-bdd) gem. cs-bdd was deprecated and will be yanked in the future. Always refer to sunomono from now on.***

A simple gem to generate all files needed in a project that will support calabash for both Android and iOS.

iOS Build script works only with iOS SDK 9.2 or newer

[Calabash](http://calaba.sh/) uses cucumber to support functional tests in Android and iOS and has one gem for each Platform:

  > calabash-android (for Android) [(link)](https://github.com/calabash/calabash-android)

  > calabash-cucumber (for iOS) [(link)](https://github.com/calabash/calabash-ios)

The project structure is based on [this site](http://rubygemtsl.com/2014/01/06/designing-maintainable-calabash-tests-using-screen-objects-2). The structure is based on three layers: features, steps and screens.

  1. Features: Contains all the features of the project, this features are Platform independent and will run for Android and iOS tests;
  2. Steps: Contains all the steps implementations. This steps are Platform independent and will run for Android and iOS tests;
  3. Screens: Contains all the Android and iOS screens. A screen must contain an identification, the declaration of all the elements of the screen and the declaration of its actions. This layer is Platform dependent. This occurs because, in almost every project, the identification of the elements varies between the Platforms. One example is that in Android almost all elements have an id, but in iOS the most common is to identify the elements by accessibility label. The Platform dependent screens must have the same name and same methods signatures. This will allow your steps to be unique between platforms

  > One example of this structure can be found in the generated files (see Usage) on the file base_steps.rb. This file implements some common steps to help you start your tests and show you how to uses the Platform dependent screens

  > In my experience with tests I saw some cases that we will need to test features that are Platform dependent, like screens that send SMS which will only apper in Android apps. When this happen, the generated structure has Features and Steps that are Platform dependent and can be found inside the folder `features/android` and `features/ios` of the generated project.

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
  suno new ProjectName
```

This command will create a folder named ProjectName in the current directory and will create all the needed files. This gem support localizations. To create a localized project, in Portuguese, type:

```
  suno new ProjectName --lang=pt
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


```
  suno generate android-feature AndroidFeatureName
  suno generate ios-feature iOSFeatureName
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


```
  suno generate android-screen AndroidScreenName
  suno generate ios-screen iOSScreenName
```
The android-screen and ios-screen will create only the Android and iOS dependent screens respectively.

## Continuous Integration (CI)

The project contains a lot of scripts that will help you to configure you CI server.

> Documentation under development.


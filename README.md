# CS::BDD

A simple gem to generate all the files needed to create a project that will support calabash for Android and iOS.

[Calabash](http://calaba.sh/) uses cucumber to support functional tests in Android and iOS and has one gem for each Platform:

  > calabash-android (for Android) [(link)](https://github.com/calabash/calabash-android)
  
  > calabash-cucumber (for iOS) [(link)](https://github.com/calabash/calabash-ios)

The project structure is based on [this site](http://rubygemtsl.com/2014/01/06/designing-maintainable-calabash-tests-using-screen-objects-2). This structure is based on three layers: the features, the steps and the screens.

  1. Features: Contains all the features of the project, this features are Platform independent and will run when testing both Android and iOS;
  2. Steps: Contains all the steps implementation of the features. This steps are Platform independent and will run when testing both Android and iOS;
  3. Screens: Contains all the screens definition. A screen definition must contain an identification, the declaration of all the elements of the screen and the declaration of its actions. This layer is Platform dependent. This occurs because, in almost every project, the identification of the elements of the screens varies between the Platforms. One example is that in Android almost all elements have an id, but in iOS is most common to identify the elements by accessibility label. The Platform dependent screens must has the same name and same methods. This will allow your steps to be unique between platforms

  > One example of this structure can be found in the generated files (see Usage) on the file base_steps.rb. This file implements some common steps to help you start your tests and show you how to uses the Platform dependent screens
  
  > In my experience with tests I saw some cases that we will need to test features that are Platform dependent, like screens that send SMS which will only happen in Android. For this to happen, the generated structure has Features and Steps that are Platform dependent and can be found inside the folder `features/android` and `features/ios` of the generated project.

## Installation

Install it as:

    $ gem install cs-bdd

## Usage

This gem works only in the terminal, so for help, type:

```
  cs-bdd
  cs-bdd generate
```

To see the gem version type:

```
  cs-bdd version
```

To generate a structure of one project that can support both Android and iOS features for Calabash type:

```
  cs-bdd new ProjectName
```

This command will create a folder named ProjectName in the current directory and will create all the files needed. This gem support localizations. To create a localized project, in Portuguese, type:

```
  cs-bdd new ProjectName --lang=pt
```

  > The default language is English ('en'). The elements of Gherkin such as Given, When, Than, And, Scenario will be translated to all Gherkin supported languages, but the generators accept only a little quantity of languages(see than in the folder: `lib/cs/bdd/locales`). 
  
  > **CS-BDD doesn't support your mother language?** No problem make a fork, create your yml translation file, uses the en.yml file as a template. Translate it and make a pull request. There are only 15 lines to be translated, this will take no time.
  
  > **Don't know how to identify your yml file?** See the Gherkin supported languages [here](https://github.com/cucumber/gherkin/blob/master/lib/gherkin/i18n.json).

Once the project is created, opens the folder (`cd ProjectName`). 

> **The generators commands ONLY WORK in the ROOT FOLDER of the project**.

There are nine generators that are responsible to create the templates for Features, Step definitions and Screens.

For Features you can type:

```
  cs-bdd generate feature FeatureName
  cs-bdd generate aFeature AndroidFeatureName
  cs-bdd generate iFeature iOSFeatureName
```

  > The feature generator will create a Platform independent feature and its files. So this command will create the FeatureName.feature file in the folder `feature`, the file FeatureName_steps.rb in the folder `features/step_definitions`, the the files FeatureName_screen.rb in the folders `features/android/screens` and `features/ios/screens`.

  > The aFeature and iFeature generator will create and Platform dependent feature so, for example, the aFeature generator will create the AndroidFeatureName.feature file in the folder `features/android/features`, the file AndroidFeatureName_steps.rb in the folder `features/androd/step_definitions` and the screen file AndroidFeatureName_screen.rb in the folder `features/android/screens`.

Don't forget about internationalization. All the generators accept the option `--lang=pt` or with some other language.

For Steps definitions you can type:

```
  cs-bdd generate step StepName
  cs-bdd generate aStep AndroidStepName
  cs-bdd generate iStep iOSStepName
```

  > The step generator will create a Platform independent step file named StepName_steps.rb in the folder `features/step_definitions`
  
  > The aStep generator will create an Android step file named AndroidStepName_steps.rb in the folder `features/android/step_definitions`
  
  > The iStep generator will create an iOS step file name iOSStepName_steps.rb in the folder `features/ios/step_definitions`

For Screens type:

```
  cs-bdd generate screen ScreenName
  cs-bdd generate aScreen AndroidScreenName
  cs-bdd generate iScreen iOSScreenName
```

  > The screen generator will create both Platform dependent screens in the folders `features/android/screens` and `features/ios/screens`.
  
  > The aScreen and iScreen will create only the Android and iOS dependent screens respectively.


## Contributing

1. Fork it ( https://github.com/CSOscarTanner/cs-bdd/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
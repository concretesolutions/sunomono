# Sunomono Calabash documentation

[Calabash](http://calaba.sh/) uses cucumber to support functional tests in Android and iOS and has one gem for each Platform:

  > calabash-android (for Android) [(link)](https://github.com/calabash/calabash-android)

  > calabash-cucumber (for iOS) [(link)](https://github.com/calabash/calabash-ios)

The project structure is based on [this site](http://rubygemtsl.com/2014/01/06/designing-maintainable-calabash-tests-using-screen-objects-2).The structure is based on three layers: features, steps and screens.

  1. Features: Contains all the project features,  which are Platform independent and will run for Android and iOS tests;
  2. Steps: Contains all the steps implementations. These steps are Platform independent and will run for Android and iOS tests;
  3. Screens: Contains all the Android and iOS screens. A screen must contain an identification, the declaration of all the elements of the screen and the declaration of its actions. This layer is Platform dependent. This happens because of, in almost every project, the identification of the elements varies between the Platforms. One example is that on Android most elements have an id, but on iOS  it’s common to identify the elements by accessibility label. The Platform dependent screens must have the same name and the same methods signatures. This will allow your steps to be unique between platforms

  > One example of this structure can be found in the generated files (see Usage) on the file base_steps.rb. This file implements some common steps to help you start your tests and show you how to uses the Platform dependent screens

  > In my experience with tests I saw some cases that we will need to test features that are Platform dependent, like screens that send SMS which will only apper in Android apps. When this happen, the generated structure has Features and Steps that are Platform dependent and can be found inside the folder `features/android` and `features/ios` of the generated project.



# Sunomono Appium documentation

[Appium](http://appium.io/) uses Selenium to functional tests in Android and iOS:

The project structure is based on this [project](https://github.com/gricsi/cross-platform-appium-cucumber-test-example). The structure is based on three layers: features, steps, screens and modules. 


  1. Features: Contains all the features of the project, this features are Platform independent and will run for Android and iOS tests;
  2. Steps: Contains all the steps implementations. This steps are Platform independent and will run for Android and iOS tests;
  3. Screens: Contains all the Android and iOS screens. A screen must contain an identification, the declaration of all the elements of the screen and the declaration of its actions. This layer is Platform dependent. This occurs because, in almost every project, the identification of the elements varies between the Platforms. One example is that in Android almost all elements have an id, but in iOS the most common is to identify the elements by accessibility label. The Platform dependent screens must have the same name and same methods signatures. This will allow your steps to be unique between platforms
  4. Modules: Contains all the methods commons between the features e.g(LoginScreen(android) and LoginScreen(ios) contains the elements of the screens and different methods and interaction between platforms), the module contains the method with the same behavior on platforms
  
## Appium server
  
  RakeFile contains any tips to start the appium server and run your tests
  
  
  
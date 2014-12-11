#Getting Started 

## Ruby
  
  There is a lot of ways of installing ruby, one is using RVM (http://rvm.io/rvm/install):
  
  Install RVM stable with ruby: 

  ```
  $ \curl -sSL https://get.rvm.io | bash -s stable --ruby
  ```
  
  After this, include the following lines in you `~/.bashrc` file.
  
  ```
  export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
  [[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
  ```

# Android

## Installing the Gems

  Install the following gems

  ```
  gem install calabash-common calabash-android
  ```

  **Warning!**
  
  The gem **`calabash-android`** can install the beta version of the cucumber gem.
  This gem brokes the execution of the calabash. After the installation of calabash-android, check your installed gems with the command `gem list | grep cucumber` and install the stable version of the cucumber gem (command: `gem install cucumber`) and remove the beta version (command: `gem uninstall cucumber`), if that is the case.

## Running the tests
  To run the android tests, you need to:
  
  1. Open the Android AVD
  2. Open the terminal on the tests folder
  3. Execute the command:
  
  ```
    calabash-android run features/app-QA.apk -p android
  ```
  

  > To run in a computer with more than one emulator or device, use the command:
  >
  >```
  >  ADB_DEVICE_ARG=emulator-5554 calabash-android run features/app-QA.apk -p android
  >```
  >
  >Given that 'emulator-5554' is one of the returns of the command `$ adb devices` on the terminal


  > To run on all connected devices, run the script `run_tests_all_devices.sh`, located on the `config/scripts/android` folder of the project

  > **!! IMPORTANT !!** 

  > Remember to export the WORKSPACE variable with the path of the cloned test repository
  
  > Remember to pass the APK path as the parameter of the script
  > 
  > ```
  > ./config/scripts/android/run_tests_all_devices.sh PATH_OF_APK_FILE
  >```


## Calabash Terminal

The calabash terminal allows you to run the calabash commands without being on a test context
To open the calabash terminal, you need to:

  1. Open the Android AVD
  2. Open the terminal on the tests folder
  3. Execute the command:
  
  ```
    calabash-android console features/app-QA.apk -p android
  ```
  
  4. Run the commands
  
  ```
    reinstall_apps
    start_test_server_in_background
  ```
  
  5. Run the commands you want to.

# iOS

## Installing the Gems

  Install the following gems

  ```
  gem install calabash-common calabash-cucumber
  ```
  
## Configuring the iOS project

  1. Run the command `pod install`
  2. Run the command `calabash-ios setup` and follow the instructions
  3. Make sure that the signing is a wildcard


## Running the tests
  To run the iOS tests in a device, you need to:
  
  1. Open the terminal on the tests folder
  2. Compile the project to create the .app file with the command 
  
  ```
  ./config/scripts/ios/build_app.sh xcworkspace_path TargetName-cal iphoneos8.1 ConfigurationName
  ```
  
        PS.1: TargetName-cal is the name of the target created with the command `calabash-ios setup`
        PS.2: iphoneos8.1 is the sdk for devices, for emulatores use iphonesimulator8.1
        PS.3: Configuration name can be Dev, Debug, Release, Prod or any other configuration build
        PS.4: The path to the .app file is the last output line of the above command

  3. To execute one feature, run the command
  
  ```
    APP_BUNDLE_PATH=AppFilePath DEVICE_TARGET=DeviceUUID DEVICE_ENDPOINT=CalabashServerEndpointDevice cucumber -p ios
  ```
  
  4. To execute all the features in the configured devices run the script
  
  ```
    ./config/scripts/ios/run_tests_all_devices.sh AppFilePath
  ```
  
      PS.: Remember to configure all the connected devices on the file `./config/scripts/ios/devices`.
           In this file you need to inform the device UUID, the device IP with the calabash server port and a name to identify this device on the reports. Remember to leave an empty line at the end of the file and to split the informations using pipes.

## Calabash Terminal (Device)

The calabash terminal allows you to run the calabash commands without being on a test context
To open the calabash terminal, you need to:

  1. Connect the device
  2. Open the terminal on the tests folder
  3. Execute the command:
  
  ```
    APP_BUNDLE_PATH=AppFilePath DEVICE_TARGET=DeviceUUID DEVICE_ENDPOINT=CalabashServerEndpointDevice calabash-ios console
  ```
  
  4. Run the command
  
  ```
    start_test_server_in_background
  ```
  
  5. Run the commands you want to.

## Pitfalls

  1. Always build the project with the device connected
  2. Ensure that the device is enabled to Development and the UI Automations is enabled on the Developer menu (Settings)
  3. If the device in pin locked, ensure that it is unlocked. If there is no pin, the calabash will automatically unlock the device
  4. Ensure that the device WIFI is enabled and it is accessible from the computer that is starting the tests. The calabash server works sending commands to the device by the network.
  5. Always run the target -cal on the Xcode one first time to see if the target is ok and running. The calabash-ios gem cannot print errors of execution, but Xcode can.

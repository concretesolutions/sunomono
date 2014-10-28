def print_usage
  puts <<EOF
  Usage: cs-bdd <command-name> [parameters]
  <command-name> can be one of
    new or n <project_name>
      generate a project folder structure
    generate or g <type> <name>
      generate a Feature or Step Definition or Screen file
      <type> can be one of
        feature -> Generate all files that composes an OS independenty feature
        aFeature -> Generate all files that composes an Android feature
        iFeature -> Generate all files that composes an iOS feature
        step -> Generate an OS independenty step
        aStep -> Generate a step that will be loaded only in Android
        iStep -> Generate a step that will be loaded only in iOS
        aScreen -> Generate an Android screen
        iScreen -> Generate an iOS screen
    version or v
      prints the gem version
  [parameters] can be one of

EOF
end

def create_feature_file name, platform = nil
  # Getting the contents of the example.feature file
  content = File.read( File.join( @examples_dir, "example.feature" ) )
  
  # Updating the contents with the name passed as an option
  content = content.gsub( "|Name|", name.capitalize )

  # If platform is not nil than the feature is OS dependent
  file = nil
  if platform.nil?
    content = content.gsub( "|Platform|", "") # Don't show any indication of platform inside the feature file
    file = File.join( @features_dir, "#{name.downcase}.feature" )
  else
    content = content.gsub( "|Platform|", "(#{platform} Only)") # Indicates the platform in the title of the feature
    file = File.join( @features_dir, platform.downcase, "features", "#{name.downcase}.feature" )
  end

  # Creating the feature file with the updated content
  File.open( file, 'w' ) { |file| file.puts content }
end

def create_steps_file name, platform = nil
  # Getting the contents of the example_steps.rb file
  content = File.read( File.join( @examples_dir, "example_steps.rb" ) )
  
  # If platform is not nil than the feature is OS dependent
  file = nil
  if platform.nil?
    file = File.join( @steps_dir, "#{name.downcase}_steps.rb" )
  else
    file = File.join( @features_dir, platform.downcase, "steps_definition", "#{name.downcase}.feature" )
  end

  # Creating the steps file with the default content
  File.open( file, 'w' ) { |file| file.puts content }
end

def create_screen_file name, platform
  # Getting the contents of the example_screen.rb file
  content = File.read( File.join( @examples_dir, "example_screen.rb" ) )
  
  # Updating the contents with the name passed as an option
  content = content.gsub( "|Name|", name.capitalize )
  content = content.gsub( "|Platform|", platform )
  
  # Creating the feature file with the updated content
  File.open( File.join( @features_dir, platform.downcase, "screens", "#{name.downcase}_screen.rb" ), 'w' ) { |file| file.puts content }
end
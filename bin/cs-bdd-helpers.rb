def print_usage
  puts <<EOF
  Usage: cs-bdd <command-name> [parameters] [options]
  <command-name> can be one of
    new or n
      generate a project folder structure.
    generate or g
      generate a Feature or Step Definition or Screen file
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
    file = File.join( @features_dir, "#{name.downcase}.feature" )
  else
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
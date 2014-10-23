def generate_skeleton
  if File.exists?(@project_dir)
    puts "A project directory already exists. Nothing will be done."
    exit 1
  end

  FileUtils.cp_r(@skeleton_dir, @project_dir)

  puts "Project folder created. \n"

end
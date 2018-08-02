#!/usr/bin/env ruby

# Generates a new Horos Plugin based on the files in PluginTemplate folder
# Adapted from original OsiriX plugin creator:
# # Copyright 2006 Shalev NessAiver

require 'find'

unless ARGV[0] and ARGV[1]
puts "Usage: ruby CreateNewPlugin.rb <plugin_name> <your_name>"
puts "This script will generate a new Osirix plugin with name plugin_name and files copyrighted as your_name."
Kernel.exit()
end

$plugin_name = ARGV[0]
$your_name = ARGV[1]
count = 2
while count < ARGV.size - 1
  $your_name = $your_name + " " + ARGV[count]
  count += 1
end
$cur_year = Time.now.year.to_s

`cp -R PluginTemplate ../../../#{$plugin_name}`
`mv ../../../#{$plugin_name}/MyFirstHorosPlugin ../../../#{$plugin_name}/#{$plugin_name}`

#logger = Logger.new("/Users/brizolara/Developer/HorosPluginCreator/HorosPluginCreator.log")
$stdout = File.new( '/Users/brizolara/Developer/HorosPluginCreator/HorosPluginCreator_rubyScript.log', 'w' )

# def replace_contents(file)
#   file.gsub(/PluginTemplate/, $plugin_name).gsub(/CURRENT_YEAR/, $cur_year).gsub(/YOUR_NAME/, $your_name)
# end

def replace_contents(file)
  file
    .encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    .gsub(/MyFirstHorosPlugin/, $plugin_name).gsub(/CURRENT_YEAR/, $cur_year).gsub(/YOUR_NAME/, $your_name)
end

#
# Renaming contents calling replace_contents

Find.find(Dir.pwd + "/../../../#{$plugin_name}") do |path|
  fname = File.basename(path)
  #puts "fname = #{fname}"
  puts "Modifying: #{path}"
  if FileTest.directory?(path)
    if fname[0] == ?.
      #puts "fname[0] == ?."
      Find.prune       # Don't look any further into this directory.
      next
    end
    #if fname == "Horos.framework"
    if fname.end_with? ".framework"
      puts "found #{fname}"
      Find.prune       # Don't look any further into this directory.
      next
    end
    if fname.eql? "#{$plugin_name}"   # The code is one directory deeper than the .xcodeproj
      puts "Entering sub-directory..."
      Find.find(Dir.pwd + "/../../../#{$plugin_name}/#{$plugin_name}") do |path2|
        if FileTest.directory?(path) == false
          cur_file2 = replace_contents(IO.read(path2))
          puts "replace_contents on #{cur_file2}"
          File.open(path2, "w") {|f| f.print cur_file2}
        end
      end
    end
  else
    cur_file = replace_contents(IO.read(path))
    puts "replace_contents on #{cur_file}"
    File.open(path, "w") {|f| f.print cur_file}
  end
end

#
# Renaming files

Find.find(Dir.pwd + "/../../../#{$plugin_name}") do |path|
  if (fname = File.basename(path)) =~ /MyFirstHorosPlugin/
    File.rename(path, File.dirname(path) + '/' + fname.sub(/MyFirstHorosPlugin/, $plugin_name))
  end
  if fname.eql? "#{$plugin_name}"   # The code is one directory deeper than the .xcodeproj
    Find.find(Dir.pwd + "/../../../#{$plugin_name}/#{$plugin_name}") do |path2|
      if (fname = File.basename(path)) =~ /MyFirstHorosPlugin/
        File.rename(path, File.dirname(path) + '/' + fname.sub(/MyFirstHorosPlugin/, $plugin_name))
      end
    end
  end
end

$stdout = STDOUT
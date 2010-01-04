#!/usr/bin/env ruby
main_file = IO.read("main.lua")
app_name = Dir.pwd[ /([^\/]+)\/?$/ ]
build_dir = "build"
app_dir = File.join( build_dir, "#{ app_name }Build" )
app_main_file = File.join( app_dir, "main.lua" ) 

already_required = []

puts "Merging files"
while editing = main_file[ /require\s?"/ ]
  main_file.gsub!( /(require\s?"(\w+)")/ ) do
    filename =  "#{ $2 }.lua"  

    if File.exists?( filename )
      if already_required.include?( filename )
        ""
      else
        already_required << filename
        IO.read( filename )
      end
    else
      raise "Cannot find #{ filename }"
    end
  end
end

unless File.exists?( build_dir )
  puts "Creating build/"
  Dir.mkdir( build_dir )
end

if File.exists?( app_dir )
  puts "Old build found, cleaning up..."
  Dir[ File.join( app_dir, "*" ) ].each do | file |
    puts "* removing #{ file }"
    File.delete( file )
  end

else
  Dir.mkdir( app_dir )
end

puts "* writing #{ app_main_file }"
open( app_main_file , "w+" ) do | file |
  file.write( main_file )
end

if File.exists?( "sounds" )
  puts "* copying sounds"
  `cp sounds/* #{ app_dir }/`
end

if File.exists?( "images" )
  puts "* copying images"
  `cp images/* #{ app_dir }/`
end

puts "Done"

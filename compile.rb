mainfile = IO.read("main.lua")
appname = Dir.pwd[ /([^\/]+)\/?$/ ]
builddir = "build"
appdir = File.join( builddir, "#{ appname }Build" )

already_required = []

puts "Merging files"
while editing = mainfile[ /require\s?"/ ]
  mainfile.gsub!( /(require\s?"(\w+)")/ ) do
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

unless File.exists?( builddir )
  puts "Creating build/"
  Dir.mkdir( builddir )
end

if File.exists?( appdir )
  puts "Old build found, cleaning up..."
  Dir[ File.join( appdir, "*" ) ].each do | file |
    puts "* removing #{ file }"
    File.delete( file )
  end

else
  Dir.mkdir( appdir )
end

appmainfile = File.join( appdir, "main.lua" ) 
puts "* writing #{ appmainfile }"
open( appmainfile , "w+" ) do | file |
  file.write( mainfile )
end

if File.exists?( "images" )
  puts "* copying images"
  `cp images/* #{ appdir }/`
end

puts "Done"

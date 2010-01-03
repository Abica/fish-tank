main = IO.read("main.lua")
puts main
main.gsub( /(require\s?"(\w+)")/ ) do
  filename =  "#{ $2 }.lua"  
  if File.exists?( filename )
#    IO.read( filename )
  else
    raise "Cannot find #{ filename }"
  end
end

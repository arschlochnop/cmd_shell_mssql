#directory things

#Dir.foreach('/') {|x| puts x if x != "." && x != ".."}

#find all files
#puts Dir["*"]

#puts Dir["*.txt"]

#puts Dir.open("/") { |d| d.grep //}

#Dir.open('/') { |d| d.each {|x| puts x}}

#puts Dir['*.rb']

require 'find'

#this is very good
f = File.new("rubies.txt","w")

Find.find('/') do |f|
  # print file and path to screen if filename ends in ".mp3"
  f << f if f.match(/\.rb\Z/)
end
f.close
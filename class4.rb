#file things

filename = 'a_file.txt'

puts File.file? filename
#=> false

require 'fileutils'
FileUtils.touch(filename)

puts File.file? filename
#=> true



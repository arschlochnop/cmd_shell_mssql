#write to file and read words from file

f = File.new("mytest.txt", "w")

f << "line 1 "
f << "line 2 "
f << "line 3 "
f << "line 4 "
f << "line 5 "
f << "end"
f.close

=begin
f = File.open("mytest.txt", "r")
f.each_line do |line|
  puts line
  word_arr = line.split()
  p word_arr
end
=end
word_arr = []
f = File.open("mytest.txt", "r")
f.each_line { |line| word_arr = line.split()}
p word_arr

reverse_arr = word_arr.reverse

p word_arr
p reverse_arr
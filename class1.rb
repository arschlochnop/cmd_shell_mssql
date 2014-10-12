
# my block proc stuff


p = Proc.new {|a,b| a * b}
#puts "this is Proc.new   #{p.call(2,2)}"
z = lambda {|a,b| a - b}
#puts "this is lambda #{z.call(2,3)}"

#puts "this is a short lambda #{lambda {|a,b| a * b}.call(2,4)}"

#array of procs!
lambda_array = [p,z]
#lambda_array.each {|a| puts a.call(2,3) }

def myPRoc(&b)
  puts "this is inside MyProc"
  puts b(2,3)

end

myPRoc {|a,b| a * b }

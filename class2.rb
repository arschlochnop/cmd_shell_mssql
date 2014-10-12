# hash things

def some_fx
  puts "this is some function"
  (1..10).each {|a| puts a}
end

h = {
    add: lambda {|a,b| a + b},
    del: lambda {|a,b| a - b},
    div: lambda {|a,b| a/b},
    mult: lambda {|a,b| a * b},
    mod: lambda {|a,b| a % b},
    ext: lambda {
      puts "line 1"
      puts "line 2"
    },
    fx: some_fx
}


h[:fx]
puts "add:  " + h[:add].call(2,2).to_s
puts "mod:  " + h[:mod].call(4,3).to_s
puts "mult:  " + h[:mult].call(5,5).to_s

h[:ext].call






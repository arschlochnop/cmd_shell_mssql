

a = [1,2,3,4,5,6,7]
b = [8,9,10,11,12,13,14]
c = ['one','two','three','four','five']

def writeVar (var)
  var.each  do |v|
    puts v.to_s
  end
end

semaphore = Mutex.new

threads = []

threads << Thread.new {semaphore.synchronize {writeVar(a)}}
threads << Thread.new {semaphore.synchronize{writeVar(b)}}
threads << Thread.new {semaphore.synchronize {writeVar(c)}}

threads.each { |thr| thr.join }
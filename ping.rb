require 'net/ping'

@icmp = Net::Ping::ICMP.new('192.168.0.11')
rtary = []
pingfails = 0
repeat = 3
puts 'starting to ping'
(1..repeat).each do

  if @icmp.ping
    rtary << @icmp.duration
    puts "host replied in #{@icmp.duration}"
  else
    pingfails += 1
    puts "timeout"
  end
end
avg = rtary.inject(0) {|sum, i| sum + i}/(repeat - pingfails)
puts "Average round-trip is #{avg}\n"
puts "#{pingfails} packets were droped"
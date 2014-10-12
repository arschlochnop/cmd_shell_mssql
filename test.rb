class ReadIncFile

  def initialize (filename)
    @filename = filename
    @valueArr = []
  end


  def readfile
    begin
      if File.exists?(@filename)
        file = File.open(@filename,"r")
        file.each_line do |line|
          if !line.include? ("#")
            @valueArr << line.strip!
          end
        end
      end
    rescue Exception => e
      puts e.message
    end
  end

  def writeArr
    @valueArr.each { |value| puts value}
  end
end


f= ReadIncFile.new ("cmdshell_inc")
f.readfile
f.writeArr


module Parser
  def self.lines(day, type)
    File.readlines("#{type}/#{day}.txt", chomp: true)
  end
  
  def self.read(day, type)
    File.read("#{type}/#{day}.txt")
  end
end
module Parser
  def self.lines(day, type)
    File.readlines("#{type}/#{day}.txt", chomp: true)
  end
end
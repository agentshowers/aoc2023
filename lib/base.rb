require "./lib/parser.rb"

class Base
  def initialize(type = "example")
    @input = Parser.lines(DAY, type)
  end

  def one
    puts solve_one
  end

  def two
    puts solve_two
  end
end
require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day1 < Base
  DAY = 1

  def initialize(type = "example")
    @input = Parser.lines(DAY, type)
  end

  def one
    super
  end

  def two
    super
  end

  private def solve_one
    Utils.sum(@input[0].to_i, @input[1].to_i)
  end

  private def solve_two
    Utils.sum(@input[0].to_i, @input[1].to_i)
  end
end
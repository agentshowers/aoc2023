require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day1 < Base
  DAY = 1
  NUMBERS = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

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
    sum = 0
    @input.each do |s|
      numbers = s.scan(/\d/)
      sum += numbers[0].to_i*10
      sum += numbers.last.to_i
    end
    sum
  end

  private def solve_two
    sum = 0
    @input.each do |s|
      first_idx = nil
      first_n = nil
      last_idx = nil
      last_n = nil

      NUMBERS.each_with_index do |n, i|
        l_idx = s.index(n)
        r_idx = s.rindex(n)
        if l_idx && (!first_idx || l_idx < first_idx)
          first_idx = l_idx
          first_n = i + 1
        end
        if r_idx && (!last_idx || r_idx > last_idx)
          last_idx = r_idx
          last_n = i + 1
        end
      end
      (1..9).to_a.each do |n|
        l_idx = s.index(n.to_s)
        r_idx = s.rindex(n.to_s)
        if l_idx && (!first_idx || l_idx < first_idx)
          first_idx = l_idx
          first_n = n
        end
        if r_idx && (!last_idx || r_idx > last_idx)
          last_idx = r_idx
          last_n = n
        end
      end
      real = first_n.to_i*10 + last_n.to_i
      sum += real
    end
    sum
  end
end
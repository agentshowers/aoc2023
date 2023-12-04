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
    sum = 0
    @input.each do |s|
      l, r = digits(s)
      sum += (l*10 + r)
    end
    sum
  end

  def two
    sum = 0
    @input.each do |s|
      l, r = digits(s, true)
      sum += (l*10 + r)
    end
    sum
  end

  private def digits(s, text = false)
    left, right, l_digit, r_digit = nil

    (1..9).to_a.each do |n|
      l_idx = text ? s.index(/#{n}|#{NUMBERS[n-1]}/) : s.index(n.to_s)
      r_idx = text ? s.rindex(/#{n}|#{NUMBERS[n-1]}/) : s.rindex(n.to_s)

      if l_idx && (!left || l_idx < left)
        left = l_idx
        l_digit = n
      end

      if r_idx && (!right || r_idx > right)
        right = r_idx
        r_digit = n
      end
    end
    [l_digit, r_digit]
  end

end
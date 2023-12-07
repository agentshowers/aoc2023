require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day1 < Base
  DAY = 1
  REPLACEMENTS = {
    "one" => "o1e",
    "two" => "t2o",
    "three" => "t3ree",
    "four" => "f4ur",
    "five" => "f5ve",
    "six" => "s6x",
    "seven" => "s7ven",
    "eight" => "e8ght",
    "nine" => "n9ne"
  }

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
      REPLACEMENTS.each do |k, v|
        s.gsub!(k, v)
      end
      l, r = digits(s)
      sum += (l*10 + r)
    end
    sum
  end

  private def digits(s)
    l_num = nil
    i = 0

    while !l_num
      if !l_num && s[i].match?(/[1-9]/)
        l_num = s[i].to_i
        break
      else
        i += 1
      end
    end

    r_num = nil
    i = s.length - 1

    while !r_num
      if !r_num && s[i].match?(/[1-9]/)
        r_num = s[i].to_i
        break
      else
        i -= 1
      end
    end

    [l_num, r_num]
  end

end
require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day9 < Base
  DAY = 9

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @forward_agg = 0
    @backward_agg = 0
    lines.each do |line|
      b, f = extrapolate(line.split(" ").map(&:to_i))
      @forward_agg += f
      @backward_agg += b
    end
  end

  def one
    @forward_agg
  end

  def two
    @backward_agg
  end

  def extrapolate(numbers)
    forward = 0
    backward = 0
    back_bit = 1
    stop = false

    while !stop
      stop = true
      backward += numbers[0] * back_bit
      back_bit *= -1
      (1..numbers.length-1).each do |n|
        diff = numbers[n] - numbers[n-1]
        numbers[n-1] = diff
        stop = false if diff != 0
      end
      forward += numbers.pop
    end

    [backward, forward]
  end

end

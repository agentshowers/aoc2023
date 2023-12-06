require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day6 < Base
  DAY = 6

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @times = lines[0].split(":")[1].strip.split
    @distances = lines[1].split(":")[1].strip.split
  end

  def one
    @times.map(&:to_i).zip(@distances.map(&:to_i)).inject(1) do |acc, (time, distance)|
      acc * binary_solve(time, distance)
    end
  end

  def two
    time = @times.join().to_i
    distance = @distances.join().to_i
    binary_solve(time, distance)
  end

  private def binary_solve(time, distance)
    l = 0
    r = time / 2

    return 0 if r * (time - r) <= distance

    while l < r - 1
      mid = r - (r-l)/2
      if mid * (time - mid) > distance
        r = mid
      else
        l = mid
      end
    end

    min = l * (l - mid) > distance ? l : r
    half = time / 2
    winners = (half - min) * 2
    winners + (time.even? ? 1 : 2)
  end

  private def math_solve(time, distance)
    sq = Math.sqrt(time.pow(2) - 4*distance)
    v1 = (-time - sq) / -2
    v2 = (-time + sq) / -2
    v1.ceil - v2.floor - 1
  end

end

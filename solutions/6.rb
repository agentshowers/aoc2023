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
      acc * winners(time, distance)
    end
  end

  def two
    time = @times.join().to_i
    distance = @distances.join().to_i
    winners(time, distance)
  end

  private def winners(time, distance)
    min = min_time(time, distance)
    half = time / 2
    winners = (half - min) * 2
    winners + (time.even? ? 1 : 2)
  end

  private def min_time(time, distance)
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

    l * (l - mid) > distance ? l : r
  end

end
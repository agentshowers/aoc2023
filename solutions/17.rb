require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"
require "algorithms"

class Day17 < Base
  DAY = 17

  def initialize(type = "example")
    @map = Parser.lines(DAY, type).map do |line|
      line.chars.map(&:to_i)
    end
    @n_rows = @map.length
    @n_cols = @map[0].length
  end

  def one
    solve(1, 3)
  end

  def two
    solve(4, 10)
  end

  def solve(min, max)
    @queue = Containers::PriorityQueue.new
    @queue.push("0,1,0,1", 0)
    @queue.push("1,0,1,0", 0)
    @mins = {
      "0,1,0,1" => 0,
      "1,0,1,0" => 0
    }
    @visited = {}
    @best = (2**(0.size * 8 -2) -1)

    while @queue.size > 0
      key = @queue.pop
      next if @visited[key]
      @visited[key] = true
      cur = @mins[key]
      break if cur >= @best
      x, y, x_delta, y_delta = key.split(",").map(&:to_i)
      (min - 1).times do
        cur += @map[x][y]
        x += x_delta
        y += y_delta
      end
      (max - min + 1).times do
        cur += @map[x][y]
        if x == @n_rows-1 && y == @n_cols - 1
          @best = [cur, @best].min
          break
        end
        visit(x, y, y_delta, x_delta, cur) if !oob(x + min*y_delta, y + min*x_delta)
        visit(x, y, -y_delta, -x_delta, cur) if !oob(x - min*y_delta, y - min*x_delta)

        x += x_delta
        y += y_delta
        break if oob(x, y)
      end
    end
    @best
  end

  def visit(x, y, x_delta, y_delta, cur)
    x += x_delta
    y += y_delta
    key = [x, y, x_delta, y_delta].join(",")
    if !@visited[key]
      if @mins[key]
        @mins[key] = [@mins[key], cur].min
      else
        @mins[key] = cur
      end
      @queue.push(key, -@mins[key])
    end
  end

  def oob(x, y)
    return true if x < 0 || x >= @n_rows
    return true if y < 0 || y >= @n_cols
    false
  end

end
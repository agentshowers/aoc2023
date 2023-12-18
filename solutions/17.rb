require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

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
    queue = ["0,1,0,1", "1,0,1,0"]
    mins = {
      "0,1,0,1" => 0,
      "1,0,1,0" => 0
    }
    visited = {}
    best = (2**(0.size * 8 -2) -1)
    i = 0

    while queue.length > 0
      i += 1
      puts "visited #{i} keys"
      key = queue.pop
      visited[key] = true
      cur = mins[key]
      #puts key
      break if cur >= best
      3.times do
        x, y, x_delta, y_delta = key.split(",").map(&:to_i)
        cur += @map[x][y]
        if x == @n_rows-1 && y == @n_cols - 1
          best = [cur, best].min
          break
        end
        x1 = x + y_delta
        y1 = y + x_delta
        k1 = [x1, y1, y_delta, x_delta].join(",")
        if !oob(x1, y1) && !visited[k1]
          if mins[k1]
            mins[k1] = [mins[k1], cur].min
          else
            mins[k1] = cur
          end
          queue << k1
        end

        x2 = x - y_delta
        y2 = y - x_delta
        k2 = [x2, y2, -y_delta, -x_delta].join(",")
        if !oob(x2, y2) && !visited[k2]
          if mins[k2]
            mins[k2] = [mins[k2], cur].min
          else
            mins[k2] = cur
          end
          queue << k2
        end

        x += x_delta
        y += y_delta
        break if oob(x, y)
      end

      queue = queue.uniq.sort_by { |x| mins[x] }
    end
    best
  end

  def two
    -1
    #@input[0]
  end

  def oob(x, y)
    return true if x < 0 || x >= @n_rows
    return true if y < 0 || y >= @n_cols
    false
  end

end
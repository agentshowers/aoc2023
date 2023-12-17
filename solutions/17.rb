require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day17 < Base
  DAY = 17

  def initialize(type = "example")
    @map = Parser.lines(DAY, type).map do |line|
      line.map(&:to_i)
    end
    @n_rows = @map.length
    @n_cols = @map[0].length
  end

  def one
    queue = [[0, 1, 0, 1], [1, 0, 1, 0]]
    mins = {
      [0, 1, 0, 1] => @map[0][1]
      [1, 0, 1, 0] => @map[1][0]
    }
    visited = {}
    best = (2**(0.size * 8 -2) -1)

    while queue.length > 0 
      x, y, x_delta, y_delta = queue.pop
      next if oob(x, y)
      cur = mins[[x, y, x_delta, y_delta]]
      3.times do
        break if oob(x, y)
        

        x += x_delta
        y += y_delta
        cur += @map[x][y]
      end
    end
    @input[0]
  end

  def two
    @input[0]
  end

  def oob(x, y)
    return true if x < 0 || x >= @n_rows
    return true if y < 0 || y >= @n_cols
    false
  end

end
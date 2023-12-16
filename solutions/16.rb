require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day16 < Base
  DAY = 16

  def initialize(type = "example")
    @grid = Parser.lines(DAY, type)
    @n_rows = @grid.length
    @n_cols = @grid[0].length
  end

  def one
    solve(0, -1, 0, 1)
  end

  def two
    max = 0
    (0..@n_rows-1).each do |x|
      v = solve(x, 0, 0, 1)
      max = v if v > max
      v = solve(x, @n_cols-1, 0, -1)
      max = v if v > max
    end
    (0..@n_cols-1).each do |y|
      v = solve(0, y, 1, 0)
      max = v if v > max
      v = solve(@n_rows-1, y, -1, 0)
      max = v if v > max
    end
    max
  end

  def solve(x, y, x_delta, y_delta)
    @energies = Array.new(@n_rows) { Array.new(@n_cols)  { false } }
    @seen = {}
    explore(x, y, x_delta, y_delta)
    @energies.map { |l| l.select { _1 }.count }.sum
  end

  def explore(x, y, x_delta, y_delta)
    return if @seen[[x, y, x_delta, y_delta]]

    @seen[[x, y, x_delta, y_delta]] = true

    loop do
      return if oob_move(x, y, x_delta, y_delta)
      
      x += x_delta
      y += y_delta
      @energies[x][y] = true
      break if @grid[x][y] != '.'
    end

    next_move(x, y, x_delta, y_delta)
  end

  def oob_move(x, y, x_delta, y_delta)
    x += x_delta
    y += y_delta
    return true if x < 0 || x >= @n_rows
    return true if y < 0 || y >= @n_cols
    false
  end

  def next_move(x, y, x_delta, y_delta)
    case @grid[x][y]
    when "\\"
      explore(x, y, y_delta, x_delta)
    when "/"
      explore(x, y, -y_delta, -x_delta)
    when "-"
      if y_delta != 0
        explore(x, y, x_delta, y_delta)
      else
        explore(x, y, 0, 1)
        explore(x, y, 0, -1)
      end
    when "|"
      if x_delta != 0
        explore(x, y, x_delta, y_delta)
      else
        explore(x, y, 1, 0)
        explore(x, y, -1, 0)
      end
    end
  end
end
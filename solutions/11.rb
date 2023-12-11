require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day11 < Base
  DAY = 11

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    acc = 0
    @empty_rows = []
    lines.each_with_index do |l, i|
      n = l.gsub("#", "1").gsub(".", "0").to_i(2)
      @empty_rows << i if n == 0
      acc = acc | n
    end
    @empty_columns = []
    acc.to_s(2).chars.each_with_index do |c, i|
      @empty_columns << i if c == "0"
    end
    @galaxies = []
    lines.each_with_index do |l, i|
      l.chars.each_with_index do |char, j|
        @galaxies << [i, j] if char == "#"
      end
    end
  end

  def one
    @galaxies.each_with_index.map do |n, idx|
      (idx+1..@galaxies.length - 1).map do |j|
        distance(*n, *@galaxies[j], 2)
      end.sum
    end.sum
  end

  def two
    @galaxies.each_with_index.map do |n, idx|
      (idx+1..@galaxies.length - 1).map do |j|
        distance(*n, *@galaxies[j], 1000000)
      end.sum
    end.sum
  end

  def distance(ax, ay, bx, by, multiplier)
    xs = [ax, bx].sort
    ys = [ay, by].sort
    x_diff = xs[1] - xs[0] + (@empty_rows.select { |r| r > xs[0] && r < xs[1] }.count * (multiplier - 1))
    y_diff = ys[1] - ys[0] + (@empty_columns.select { |r| r > ys[0] && r < ys[1] }.count * (multiplier - 1))
    x_diff + y_diff
  end
end
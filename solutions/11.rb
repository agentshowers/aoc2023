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
        if char == "#"
          row_exps = @empty_rows.select { |n| n < i }.count
          col_exps = @empty_columns.select { |n| n < j }.count
          @galaxies << [i, j, row_exps, col_exps]
        end
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

  def distance(a_x, a_y, a_rexp, a_cexp, b_x, b_y, b_rexp, b_cexp, multiplier)
    x_diff = (a_x - b_x).abs
    y_diff = (a_y - b_y).abs
    rexp_diff = (a_rexp - b_rexp).abs * (multiplier - 1)
    cexp_diff = (a_cexp - b_cexp).abs * (multiplier - 1)
    x_diff + y_diff + rexp_diff + cexp_diff
  end
end
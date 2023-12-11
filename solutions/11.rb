require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day11 < Base
  DAY = 11

  def initialize(type = "example")
    @input = Parser.lines(DAY, type)

    find_expansions
    find_galaxies
    calculate_distances
  end

  def one
    @xy_sum + @exp_sum
  end

  def two
    @xy_sum + @exp_sum * (1000000 - 1)
  end

  def find_expansions
    @empty_rows = []
    acc = 0
    @input.each_with_index do |l, i|
      n = l.gsub("#", "1").gsub(".", "0").to_i(2)
      @empty_rows << i if n == 0
      acc = acc | n
    end

    @empty_columns = []
    acc.to_s(2).chars.each_with_index do |c, i|
      @empty_columns << i if c == "0"
    end
  end

  def find_galaxies
    @galaxies = []
    @input.each_with_index do |l, i|
      l.chars.each_with_index do |char, j|
        if char == "#"
          row_exps = @empty_rows.select { |n| n < i }.count
          col_exps = @empty_columns.select { |n| n < j }.count
          @galaxies << [i, j, row_exps, col_exps]
        end
      end
    end
  end

  def calculate_distances
    @xy_sum = distance_sum(@galaxies.map { _1[0] } ) + distance_sum(@galaxies.map { _1[1] } )
    @exp_sum = distance_sum(@galaxies.map { _1[2] } ) + distance_sum(@galaxies.map { _1[3] } )
  end

  def distance_sum(arr)
    arr.sort!

    res = 0
    sum = 0
    arr.each_with_index do |n, idx|
      res += (n * idx - sum)
      sum += n
    end
    res
  end
end
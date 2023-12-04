require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day3 < Base
  DAY = 3

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @matrix = lines.map { |l| l.split("") }
    @x = @matrix.length
    @y = @matrix[0].length
  end

  def one
    sum = 0
    i = 0
    while i < @x
      j = 0
      while j < @y
        if @matrix[i][j].match?(/\d/)
          number, used, j = number_and_used(i, j)
          #puts "#{number} is #{used}"
          sum += number if used
        else
          j += 1
        end
      end
      i += 1
    end
    sum
  end

  private def number_and_used(i, j)
    used = false

    used = true if j > 0 && !@matrix[i][j-1].match?(/\d|\./) # left
    used = true if i > 0 && j > 0 && !@matrix[i-1][j-1].match?(/\d|\./) # top-left
    used = true if i < (@x-1) && j > 0 && !@matrix[i+1][j-1].match?(/\d|\./) # bottom-left

    number = 0
    while j < @y && @matrix[i][j].match(/\d/)
      used = true if i > 0 && !@matrix[i-1][j].match?(/\d|\./) # top
      used = true if i < (@x-1) && !@matrix[i+1][j].match?(/\d|\./) # bottom
      number *= 10
      number += @matrix[i][j].to_i
      j += 1
    end

    if j < @y
      used = true if !@matrix[i][j].match?(/\d|\./) # current
      used = true if i > 0 && !@matrix[i-1][j].match?(/\d|\./) # top
      used = true if i < (@x-1) && !@matrix[i+1][j].match?(/\d|\./) # bottom
    end

    [number, used, j]
  end

  def two
    gears = {}
    i = 0
    while i < @x
      j = 0
      while j < @y
        if @matrix[i][j].match?(/\d/)
          number, adjacent_gears, j = check_gears(i, j)
          adjacent_gears.each do |g|
            if gears[g]
              gears[g] << number
            else
              gears[g] = [number]
            end
          end
        else
          j += 1
        end
      end
      i += 1
    end
    sum = 0
    gears.values.each do |numbers|
      sum += numbers.inject(:*) if numbers.length == 2
    end
    sum
  end

  private def check_gears(i, j)
    gears = []

    gears << [i, j-1] if j > 0 && @matrix[i][j-1] == "*" # left
    gears << [i-1, j-1] if i > 0 && j > 0 && @matrix[i-1][j-1] == "*" # top-left
    gears << [i+1, j-1] if i < (@x-1) && j > 0 && @matrix[i+1][j-1] == "*"# bottom-left

    number = 0
    while j < @y && @matrix[i][j].match(/\d/)
      gears << [i-1, j] if i > 0 && @matrix[i-1][j] == "*" # top
      gears << [i+1, j] if i < (@x-1) && @matrix[i+1][j] == "*" # bottom
      number *= 10
      number += @matrix[i][j].to_i
      j += 1
    end

    if j < @y
      gears << [i, j] if @matrix[i][j] == "*" # current
      gears << [i-1, j] if i > 0 && @matrix[i-1][j] == "*" # top
      gears << [i+1, j] if i < (@x-1) && @matrix[i+1][j] == "*" # bottom
    end

    [number, gears, j]
  end
end
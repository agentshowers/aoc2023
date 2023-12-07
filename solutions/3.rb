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
    @gears = {}
  end

  def one
    sum = 0
    i = 0
    while i < @x
      j = 0
      while j < @y
        if @matrix[i][j].match?(/\d/)
          number, used, j = number_and_used(i, j)
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

    local_gears = []

    if j > 0 && !@matrix[i][j-1].match?(/\d|\./) # left
      used = true
      local_gears << [i, j-1] if @matrix[i][j-1] == "*"
    end
    if i > 0 && j > 0 && !@matrix[i-1][j-1].match?(/\d|\./) # top-left
      used = true
      local_gears << [i-1, j-1] if @matrix[i-1][j-1] == "*"
    end
    if i < (@x-1) && j > 0 && !@matrix[i+1][j-1].match?(/\d|\./) # bottom-left
      used = true
      local_gears << [i+1, j-1] if @matrix[i+1][j-1] == "*"
    end

    number = 0
    while j < @y && @matrix[i][j].match(/\d/)
      if i > 0 && !@matrix[i-1][j].match?(/\d|\./) # top
        used = true
        local_gears << [i-1, j] if @matrix[i-1][j] == "*"
      end
      if i < (@x-1) && !@matrix[i+1][j].match?(/\d|\./) # bottom
        used = true
        local_gears << [i+1, j] if @matrix[i+1][j] == "*"
      end
      number *= 10
      number += @matrix[i][j].to_i
      j += 1
    end

    if j < @y
      if !@matrix[i][j].match?(/\d|\./) # current
        used = true
        local_gears << [i, j] if @matrix[i][j] == "*"
      end
      if i > 0 && !@matrix[i-1][j].match?(/\d|\./) # top
        used = true
        local_gears << [i-1, j] if @matrix[i-1][j] == "*"
      end
      if i < (@x-1) && !@matrix[i+1][j].match?(/\d|\./) # bottom
        used = true
        local_gears << [i+1, j] if @matrix[i+1][j] == "*"
      end
    end

    local_gears.each do |g|
      @gears[g] = (@gears[g] || [] ) << number
    end
    [number, used, j]
  end

  def two
    sum = 0
    @gears.values.each do |numbers|
      sum += numbers.inject(:*) if numbers.length == 2
    end
    sum
  end
end
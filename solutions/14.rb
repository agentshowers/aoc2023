require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day14 < Base
  DAY = 14

  def initialize(type = "example")
    @map = Parser.lines(DAY, type)
    @rows = @map.length
    @columns = @map[0].length
  end

  def one
    # n = @map.length
    # sums = Array.new(n) { 0 }
    # spots = Array.new(n) { 0 }
    # @map.each_with_index do |line, i|
    #   line.chars.each_with_index do |c, j|
    #     if c == "O"
    #       sums[j] += (n - spots[j])
    #       spots[j] += 1
    #     elsif c == "#"
    #       spots[j] = i + 1
    #     end
    #   end
    # end
    # sums.sum
    vertical_move(0, @rows, 1)
    
    calculate_load
  end

  def two
    results = {}
    i = 1
    loop_start = nil
    loop_size = nil
    while !loop_start
      cycle
      res = calculate_load
      if results[res]
        loop_start = results[res]
        loop_size = i - results[res]
      else
        results[res] = i
      end
      i += 1
    end
    # 200.times do |i|
    #   cycle
    #   puts "#{calculate_load}"
    # end    

    (1000000000 - loop_size)
    #@input[0]
  end

  def cycle
    vertical_move(0, @rows, 1)
    horizontal_move(0, @columns, 1)
    vertical_move(@rows - 1, -1, -1)
    horizontal_move(@columns - 1, -1, -1)
  end

  def horizontal_move(start_j, end_j, dir)
    spots = Array.new(@rows) { start_j }
    j = start_j
    while j != end_j
      i = 0
      while i < @rows
        if @map[i][j] == "O"
          if j != spots[i]
            @map[i][spots[i]] = "O"
            @map[i][j]= "."
          end
          spots[i] += dir
        elsif @map[i][j] == "#"
          spots[i] = j + dir
        end
        i += 1
      end
      j += dir
    end
  end

  def vertical_move(start_i, end_i, dir)
    spots = Array.new(@columns) { start_i }
    i = start_i
    while i != end_i
      j = 0
      while j < @columns
        if @map[i][j] == "O"
          if i != spots[j]
            @map[spots[j]][j] = "O"
            @map[i][j]= "."
          end
          spots[j] += dir
        elsif @map[i][j] == "#"
          spots[j] = i + dir
        end
        j += 1
      end
      i += dir
    end
  end

  def calculate_load
    @map.each_with_index.map do |line, idx|
      line.chars.select { |c| c == "O" }.length * (@map.length - idx)
    end.sum
  end
end
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
    vertical_move(0, @rows, 1)
    
    calculate_load
  end

  def two
    results = {}
    values = []
    i = 1
    loop_start = nil
    loop_size = nil
    while !loop_start
      cycle
      hash = map_hash
      if results[hash]
        loop_start = results[hash]
        loop_size = i - results[hash]
      else
        results[hash] = i
        values << calculate_load
      end
      i += 1
    end

    rem = (1000000000 - loop_start) % loop_size
    values[loop_start + rem - 1]
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

  def map_hash
    @map.each_with_index do |line|
      line.gsub("O", "0").gsub(/\.|#/, "1").to_i(2).to_s
    end.join("-")
  end
end
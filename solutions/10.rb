require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day10 < Base
  DAY = 10

  def initialize(type = "example")
    @map = {}
    lines = Parser.lines(DAY, type)
    @size = lines[0].length
    @flat = lines.join.chars
    @flat.each_with_index do |char, pos|
      if char == "S"
        @start = pos
        char = infer_s(pos)
        @flat[pos] = char
      end

      if char != "."
        a, b = neighbors(char, pos)
        @map[pos] = [a, b]
      end
    end
    calculate_distances
  end

  def one
    @distances.values.max
  end

  def two
    count = 0
    last_corner = nil
    inside = false
    @flat.each_with_index do |char, pos|
      inside = false if pos % @size == 0
      if !@distances[pos]
        count += 1 if inside
      else
        if char == "|"
          inside = !inside
        elsif char == "L" || char == "F"
          last_corner = char
        elsif char == "J"
          inside = last_corner == "L" ? inside : !inside
          last_corner = nil
        elsif char == "7"
          inside = last_corner == "F" ? inside : !inside
          last_corner = nil
        end
      end
    end
    count
  end

  def calculate_distances
    @distances = { @start => 0 }
    to_visit = [@start]
    while to_visit.length > 0
      current = to_visit.shift
      if @map[current]
        neighbors = @map[current]
        neighbors.each do |n|
          next if @distances[n]
          @distances[n] = @distances[current] + 1
          to_visit << n
        end
      end
    end
  end

  def neighbors(char, pos)
    case char
    when "|"
      [north(pos), south(pos)]
    when "-"
      [west(pos), east(pos)]
    when "L"
      [north(pos), east(pos)]
    when "J"
      [north(pos), west(pos)]
    when "7"
      [south(pos), west(pos)]
    when "F"
      [south(pos), east(pos)]
    end
  end

  def infer_s(pos)
    connect_north = ["|", "7", "F"].include?(@flat[north(pos)])
    connect_south = ["|", "L", "J"].include?(@flat[south(pos)])
    connect_east = ["-", "J", "7"].include?(@flat[east(pos)])
    connect_west = ["-", "L", "F"].include?(@flat[west(pos)])

    return "|" if connect_north && connect_south
    return "-" if connect_east && connect_west
    return "L" if connect_north && connect_east
    return "J" if connect_north && connect_west
    return "7" if connect_south && connect_west
    return "F" if connect_south && connect_east
  end

  def north(pos)
    pos - @size
  end

  def south(pos)
    pos + @size
  end

  def east(pos)
    pos + 1
  end

  def west(pos)
    pos - 1
  end
end
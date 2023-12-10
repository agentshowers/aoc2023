require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day10 < Base
  DAY = 10

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @row_size = lines[0].length
    @flat = lines.join.chars
    @flat.each_with_index do |char, pos|
      if char == "S"
        @start = pos
        char = infer_s(pos)
        @flat[pos] = char
        break
      end
    end
    calculate_loop
  end

  def one
    (@loop.keys.length / 2.0).ceil
  end

  def two
    count = 0
    last_corner = nil
    inside = false
    @flat.each_with_index do |char, pos|
      if !@loop[pos]
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

  def calculate_loop
    @loop = { @start => true }
    cur_pos = neighbors(@start).first
    prev_pos = @start
    while cur_pos != @start
      @loop[cur_pos] = true
      next_pos = (neighbors(cur_pos) - [prev_pos]).first
      prev_pos = cur_pos
      cur_pos = next_pos
    end
  end

  def neighbors(pos)
    case @flat[pos]
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
    pos - @row_size
  end

  def south(pos)
    pos + @row_size
  end

  def east(pos)
    pos + 1
  end

  def west(pos)
    pos - 1
  end
end
require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day18 < Base
  DAY = 18

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @instructions = lines.map do |l|
      dir, n, color = l.split(" ")
      [dir, n.to_i, color]
    end
  end

  def one
    shoelace do |instruction|
      [instruction[0], instruction[1]]
    end
  end

  def two
    shoelace do |instruction|
      case instruction[2][7]
      when "0"
        dir = "R"
      when "1"
        dir = "D"
      when "2"
        dir = "L"
      when "3"
        dir = "U"
      end
      n = instruction[2][2..6].to_i(16)
      [dir, n]
    end
  end

  def shoelace
    x1 = 0
    y1 = 0
    area = 0
    boundary = 0
    @instructions.each do |instruction|
      dir, n = yield(instruction)
      x2 = x1
      y2 = y1
      boundary += n
      case dir
      when "R"
        x2 = x1 + n
      when "L"
        x2 = x1 - n
      when "D"
        y2 = y1 - n
      when "U"
        y2 = y1 + n
      end
      area += (x1 * y2 - x2 * y1)
      x1 = x2
      y1 = y2
    end
    (area.abs / 2) + (boundary / 2) + 1
  end

  def solve
    solution = []
    sum = 0
    File.readlines("out", chomp: true).each do |line|
      sum += line.chars.select { |x| x == "#" }.count
      solution << sum
    end

    corners = {}
    x = 0
    y = 0
    @instructions.each do |instruction|
      dir, n = yield(instruction)
      case dir
      when "R"
        y += n
      when "L"
        y -= n
      when "D"
        x += n
      when "U"
        x -= n
      end
      if corners[x]
        corners[x] << y
        corners[x].sort!
      else
        corners[x] = [y]
      end
    end
    prev = nil
    sum = 0
    offset = corners.keys.sort.first.abs

    corners.keys.sort.each do |row|
      puts "row: #{row}"
      if prev
        puts "prev: #{corners[prev]}"
        puts "cur: #{corners[row]}"
        sum += line_length(corners[prev]) * (row - prev)
        puts "pre shrink: #{sum}"
        raise StandardError.new("boom at row #{row + offset} wanted #{solution[row + offset -1]} got #{sum}") if sum != solution[row + offset - 1]
        sum += shrink(corners[prev].dup, corners[row])
        puts "post shrink: #{sum}"
        new_cols = merge(corners[prev], corners[row])
        
        corners[row] = new_cols
      end
      prev = row
    end
    sum
  end

  def line_length(cols)
    sum = 0
    cols.each_slice(2) do |a, b|
      sum += (b - a + 1)
    end
    sum
  end

  def merge(previous, current)
    (previous.union(current) - previous.intersection(current)).sort
  end

  def shrink(previous, current)
    shrink = 0
    i = 0
    j = 0
    while i < current.length && j < previous.length
      if current[i+1] < previous[j]
        i += 2
      elsif previous[j+1] < current[i]
        j += 2
      elsif current[i] < previous[j]
        if i+2 < current.length && current[i+2] == previous[j+1]
          i += 4
        elsif i+2 < current.length && current[i+2] < previous[j+1]
          shrink += (previous[j+1] - current[i+2])
          i += 4
        else
          i += 2
        end
        j += 2
      elsif current[i] == previous[j]
        if current[i+1] == previous[j+1]
          shrink += (previous[j+1] - previous[j] + 1)
          i += 2
        else
          shrink += (current[i+1] - previous[j])
          if i+2 < current.length && current[i+2] == previous[j+1]
            i += 4
          elsif i+2 < current.length && current[i+2] < previous[j+1]
            shrink += (previous[j+1] - current[i+2])
            i += 4
          else
            i += 2
          end
        end
        j += 2
      else
        if current[i+1] < previous[j+1]
          shrink += (previous[j+1] - current[i+1])
        end
        i += 2
        j += 2
      end
    end
    shrink
  end


end
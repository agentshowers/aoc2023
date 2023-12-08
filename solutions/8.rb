require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day8 < Base
  DAY = 8

  def initialize(type = "example")
    @type = type
    lines = Parser.lines(DAY, type)
    parse(lines)
  end

  private def parse(lines)
    @instructions = lines[0].gsub("L", "0").gsub("R", "1").chars.map(&:to_i)
    @map = {}

    (2..lines.length-1).each do |n|
      orig, dests = lines[n].split(" = ")
      @map[orig] = dests.gsub("(", "").gsub(")", "").split(", ")
    end
  end

  def one
    count = 0
    current = "AAA"
    i = 0
    while current != "ZZZ"
      next_i = @instructions[i]
      current = @map[current][next_i]
      count += 1
      i = (i + 1) % @instructions.length
    end
    count
  end

  def two
    if @type == "example"
      lines = File.readlines("example/8b.txt", chomp: true)
      parse(lines)
    end
    starts = @map.keys.select { |k| k.end_with?("A") }

    values = starts.map do |s|
      match = nil
      i = 0
      j = 0
      while !match
        next_i = @instructions[i]
        s = @map[s][next_i]
        i = (i + 1) % @instructions.length
        j += 1
        if s.end_with?("Z")
          match = j
        end
      end
      match
    end

    values.reduce(1, :lcm)
  end
end
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

    calculate_loops
  end

  def one
    @loop_sizes["AAA"]
  end

  def two
    @loop_sizes.values.reduce(1, :lcm)
  end

  def calculate_loops
    @loop_sizes = {}
    @map.keys.select { |k| k.end_with?("A") }.each do |s|
      @loop_sizes[s] = loop_size(s)
    end
  end

  def loop_size(start)
    count = 0
    i = 0
    while !start.end_with?("Z")
      next_i = @instructions[i]
      start = @map[start][next_i]
      count += 1
      i = (i + 1) % @instructions.length
    end
    count
  end
end
require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day5 < Base
  DAY = 5

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @seeds = lines[0].split(": ")[1].split(" ").map(&:to_i)
    @mappings = []
    current_mapping = nil
    lines[1..-1].each do |line|
      next if line == ""
      if line[0].match?(/\d/)
        current_mapping.add_range(line.split(" ").map(&:to_i))
      else
        @mappings << current_mapping if current_mapping
        current_mapping = Mapping.new
      end
    end
    @mappings << current_mapping
  end

  def one
    @seeds.map do |seed|
      @mappings.inject(seed) { |value, mapping| mapping.find_value(value) }
    end.min
  end

  def two
    lowest = nil
    @seeds.each_slice(2) do |seed, delta|
      current_ranges = [[seed, delta]]
      @mappings.each do |mapping|
        new_ranges = []
        current_ranges.each do |value, delta|
          new_ranges += mapping.find_ranges(value, delta)
        end
        current_ranges = new_ranges.sort_by { |r| r[0] }
      end
      lowest = current_ranges[0][0] if !lowest || current_ranges[0][0] < lowest
    end
    lowest
  end
end

class Mapping
  attr_reader :ranges

  def initialize()
    @ranges = []
  end

  def add_range(range)
    @ranges << range
    @ranges.sort_by! { |r| r[1] }
  end

  def find_value(value)
    @ranges.each do |dest, source, delta|
      return value if source > value
      return value + (dest-source) if source + delta >= value
    end
    value
  end

  def find_ranges(value, v_delta)
    limit = value + v_delta
    local_ranges = []
    i = 0
    while value < limit
      if i >= @ranges.length
        l = limit
        delta = 0
      elsif value < @ranges[i][1]
        l = [limit, @ranges[i][1]].min
        delta = 0
      elsif value > @ranges[i][1] + @ranges[i][2]
        i += 1
        next
      else
        l = [limit, value + @ranges[i][2]].min
        l = [l, @ranges[i+1][1]].min if i < @ranges.length - 1
        delta = @ranges[i][0] - @ranges[i][1]
        i += 1
      end
      local_ranges << [value + delta, l-value]
      value = l
    end
    local_ranges
  end
end
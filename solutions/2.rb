require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day2 < Base
  DAY = 2
  MAX = {
    "blue" => 14,
    "green" => 13,
    "red" => 12
  }

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @games = lines.map do |line|
      line.split(": ")[1].split(";").map { |sets| sets.strip.split(", ").map { |set| set.split(" ") }}
    end
  end

  private def solve_one
    sum = 0
    @games.each_with_index do |game, index|
      valid = true
      game.each do |set|
        set.each do |n, color|
          next if MAX[color] >= n.to_i
          valid = false
          break
        end
        break unless valid
      end
      sum += (index + 1) if valid
    end
    sum
  end

  private def solve_two
    sum = 0
    @games.each do |game|
      mins = {
        "blue" => 0,
        "green" => 0,
        "red" => 0
      }
      game.each do |set|
        set.each do |n, color|
          mins[color] = [mins[color], n.to_i].max
        end
      end
      sum += mins.values.inject(:*)
    end
    sum
  end
end
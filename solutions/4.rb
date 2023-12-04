require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day4 < Base
  DAY = 4

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @cards = lines.map do |line|
      game = line.split(": ")[1]
      winning, my = game.split(" | ")
      [winning.split(" ").map(&:to_i), my.split(" ").map(&:to_i)]
    end
  end

  private def solve_one
    sum = 0
    @cards.each do |winning, my|
      winners = winning.select { |n| my.include?(n) }.length
      sum += (winners > 0 ? 2.pow(winners-1) : 0)
    end
    sum
  end

  private def solve_two
    total_cards = Array.new(@cards.length) { 1 }
    @cards.each_with_index do |(winning, my), index|
      winners = winning.select { |n| my.include?(n) }.length
      while winners > 0
        total_cards[index+winners] += total_cards[index]
        winners -= 1
      end
    end
    total_cards.sum
  end
end
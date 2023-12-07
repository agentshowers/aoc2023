require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day7 < Base
  DAY = 7

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @cards = lines.map do |line|
      c, b = line.split(' ')
      Hand.new(c, b.to_i)
    end
  end

  def one
    sum = 0
    sorted_cards = @cards.sort_by { |c| c.score }
    sorted_cards.each_with_index do |card, i|
      sum += (i + 1) * card.bid
    end
    sum
  end

  def two
    sum = 0
    sorted_cards = @cards.sort_by { |c| c.joker_score }
    sorted_cards.each_with_index do |card, i|
      sum += (i + 1) * card.bid
    end
    sum
  end
end

class Hand
  CARD_VALUES = {
    'A' => 14,
    'K' => 13,
    'Q' => 12,
    'J' => 11,
    'T' => 10,
    '9' => 9,
    '8' => 8,
    '7' => 7,
    '6' => 6,
    '5' => 5,
    '4' => 4,
    '3' => 3,
    '2' => 2
  }

  attr_reader :bid, :sorted, :sorted2, :cards

  def initialize(s, bid)
    @bid = bid
    @cards = s.split('')
    @tallies = @cards.tally.sort_by do |_, count|
      -count
    end
  end

  def score
    @score ||= begin
      
      sum = 0
      sum += 10.pow(11) * @tallies[0][1]
      sum += 10.pow(10) * @tallies[1][1] if @tallies.count > 1

      @cards.each_with_index do |card, i|
        sum += 10.pow(2 * (4 - i)) * CARD_VALUES[card]
      end
      sum
    end
  end

  def joker_score
    @joker_score ||= begin
      @tallies = @cards.tally.sort_by do |_, count|
        -count
      end
      sum = 0
      i = 0
      j_offset = 0
      while i < @tallies.count
        if @tallies[i][0] == 'J'
          j_offset = 1
          sum += 10.pow(11) * @tallies[i][1]
        elsif i - j_offset < 2
          sum += 10.pow(11 - i + j_offset) * @tallies[i][1]
        end
        i +=1
      end
      @cards.each_with_index do |card, i|
        card_value = card == 'J' ? 1 : CARD_VALUES[card]
        sum += 10.pow(2 * (4 - i)) * card_value
      end
      sum
    end
  end

end

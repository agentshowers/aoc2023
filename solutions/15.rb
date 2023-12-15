require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day15 < Base
  DAY = 15

  def initialize(type = "example")
    @input = Parser.lines(DAY, type)[0].split(",")
  end

  def one
    @input.map do |instruction|
      hash(instruction.chars)
    end.sum
  end

  def two
    boxes = Array.new(256) { [{}, 0] }
    @input.each do |instruction|
      match_data = /(\w+)([=-])(\d*)/.match(instruction)
      box_id = hash(match_data[1].chars)
      box = boxes[box_id]
      if match_data[2] == "-"
        box[0].delete(match_data[1])
      elsif box[0][match_data[1]]
        box[0][match_data[1]][0] = match_data[3].to_i
      else
        box[0][match_data[1]] = [match_data[3].to_i, box[1]]
        box[1] += 1
      end
    end
    boxes.each_with_index.map do |box, i|
      sorted_lenses = box[0].values.sort_by { |x| x[1] }
      sorted_lenses.each_with_index.map do |lens, j|
        lens[0] * (j + 1) * (i + 1)
      end.sum
    end.sum
  end

  def hash(chars)
    val = 0
    chars.each do |char|
      val += char.ord
      val *= 17
      val = val % 256
    end
    val
  end
end
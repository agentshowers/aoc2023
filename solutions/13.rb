require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day13 < Base
  DAY = 13

  def initialize(type = "example")
    @folds = []

    Parser.read(DAY, type).split("\n\n").each do |p|
      rows = []
      columns = Array.new(p.index("\n")) { 0 }
      p.split("\n").each_with_index do |line, i|
        binary = line.gsub("#", "1").gsub(".", "0")
        rows << binary.to_i(2)
        binary.chars.each_with_index do |b, j|
          columns[j] += b.to_i * 2.pow(i)
        end
      end
      @folds << [fold_diffs(rows), fold_diffs(columns)]
    end
  end

  def one
    sum = 0
    @folds.each do |rs, cs|
      if rs.index(:none)
        sum += 100 * (rs.index(:none) + 1)
      else
        sum += (cs.index(:none) + 1)
      end
    end
    sum
  end

  def two
    sum = 0
    @folds.each do |rs, cs|
      if rs.index(:one)
        sum += 100 * (rs.index(:one) + 1)
      else
        sum += (cs.index(:one) + 1)
      end
    end
    sum
  end

  def power_of_two?(n)
    Math.log2(n) % 1 == 0
  end

  def fold_diffs(ns)
    res = []
    (0..ns.length-2).each do |i|
      l = i
      r = i + 1
      diff_state = :none
      while l >= 0 && r < ns.length
        diff = (ns[l] - ns[r]).abs
        if diff != 0
          if diff_state != :none || !power_of_two?(diff)
            diff_state = :multiple
            break
          else
            diff_state = :one
          end
        end
        l -= 1
        r += 1
      end
      res << diff_state
    end
    res
  end
end
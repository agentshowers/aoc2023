require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day13 < Base
  DAY = 13

  def initialize(type = "example")
    @patterns = []
    input = Parser.read(DAY, type)
    input.split("\n\n").each do |p|
      rows = []
      columns = Array.new(p.index("\n")) { 0 }
      p.split("\n").each_with_index do |line, i|
        binary = line.gsub("#", "1").gsub(".", "0")
        rows << binary.to_i(2)
        binary.chars.each_with_index do |b, j|
          columns[j] += b.to_i * 2.pow(i)
        end
      end
      @patterns << [rows, columns]
    end

  end

  def one
    sum = 0
    @patterns.each do |rs, cs|
      row_mirrow = find_mirror(rs)
      if row_mirrow
        sum += 100 * row_mirrow
      else
        sum += find_mirror(cs)
      end
    rescue StandardError
      puts "#{rs} #{cs}\n"
    end
    sum
  end

  def two
    sum = 0
    @patterns.each do |rs, cs|
      row_mirrow = find_candidate(rs)
      if row_mirrow
        sum += 100 * row_mirrow
      else
        sum += find_candidate(cs)
      end
    rescue StandardError
      puts "#{rs} #{cs}\n"
    end
    sum
  end

  def find_mirror(ns)
    diffs = fold_diffs(ns)
    if diffs.index(0)
      diffs.index(0) + 1
    else
      nil
    end
  end

  def find_candidate(ns)
    diffs = fold_diffs(ns)
    diffs.each_with_index do |diff, index|
      return index + 1 if power_of_two?(diff)
    end
    nil
  end

  def power_of_two?(n)
    Math.log2(n) % 1 == 0
  end

  def fold_diffs(ns)
    sum = []
    acc = 0
    ns.each do |n|
      acc += n
      sum << acc
    end
    
    i = 0
    res = []
    while i <= ns.length - 2
      if i >= (ns.length / 2.0).floor
        l = (i+1) * 2 - ns.length
        r = ns.length - 1
      else
        l = 0
        r = (i * 2) + 1
      end
  
      l_sum = sum[i] - (l == 0 ? 0 : sum[l-1])
      r_sum = sum[r] - sum[i]
    
      diff = (l_sum - r_sum).abs
      res << diff
      i += 1
    end
    res
  end
end
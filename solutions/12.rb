require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day12 < Base
  DAY = 12

  def initialize(type = "example")
    @lines = Parser.lines(DAY, type)
    @combos_memo = {}
    @single_combos_memo = {}
    @breaks_memo = {}
  end

  def one
    groups = @lines.map { |line| parse(line) }
    groups.map do |g| 
      solve(*g)
    end.sum
  end

  def two
    groups = @lines.map { |line| parse(line, 5) }
    groups.each_with_index.map do |g, i| 
      puts i
      solve(*g)
    end.sum
  end

  def parse(line, replicate = 1)  
    springs, ns = line.split(" ")
    springs = Array.new(replicate){ springs.dup }.join("?")
    split_springs = springs.gsub(".", " ").strip.split(" ").map(&:strip)
    numbers = ns.split(",").map(&:to_i)
    numbers = numbers * replicate
    [split_springs, numbers]
  end

  def solve(str, sizes)
    breaks = cached_size_breaks(str, sizes)
    breaks.map do |b|
      b.zip(str).map do |ns, s|
        cached_combos(s, ns)
      end.inject(:*)
    end.sum
  end

  def cached_size_breaks(str, sizes)
    key = "#{str.map(&:length).join(",")}-#{sizes.join(",")}"
    return @breaks_memo[key] if @breaks_memo[key]
    res = size_breaks(str, sizes)
    @breaks_memo[key] = res
    res
  end

  def size_breaks(str, sizes)
    if sizes.length == 1 && str.length == 1
      return [[sizes]] if str[0].length >= sizes[0]
      return []
    end
    return [] if sizes.length > 0 && str.length == 0
    return [Array.new(str.length) { [].dup }] if sizes.length == 0
    
    rem = str[0].length
    i = 0
    solutions = []
    sub_solutions = cached_size_breaks(str[1..-1], sizes)
    sub_solutions.each do |sub|
      solutions << ([[]] + sub)
    end
    while i < sizes.length && rem >= sizes[i]
      sub_solutions = cached_size_breaks(str[1..-1], sizes[i+1..-1])
      sub_solutions.each do |sub|
        solutions << ([sizes[0..i]] + sub)
      end
      rem -= (sizes[i] + 1) if i >= 0
      i += 1
    end
    solutions
  end

  def cached_combos(str, ns)
    key = "#{str}-#{ns.join(",")}"
    return @combos_memo[key] if @combos_memo[key]
    res = combos(str, ns)
    @combos_memo[key] = res
    res
  end

  def combos(str, ns)
    return 0 if str.include?("#") && ns.length == 0
    return 0 if str.length < (ns.sum + ns.length - 1)
    return 1 if ns.length == 0
    return cached_single_combo(str, ns[0]) if ns.length == 1
  
    n = ns[0]
    rem = ns[1..-1]
    if str[0] == "#"
      return 0 if str[n] == "#"
      cached_combos(str[n+1..-1], ns[1..-1])
    else
      left_hash = str.index("#")
      sum = 0
      i = n
      loop do
        if str[i] != "#"
          sum += (cached_single_combo(str[i-n..i-1], n) * cached_combos(str[i+1..-1], rem))
        end
        i += 1
        break if left_hash && i - n > left_hash
        break if i > str.length - 2
      end
      sum
    end
  end

  def cached_single_combo(str, n)
    key = "#{str}-#{n}"
    return @single_combos_memo[key] if @single_combos_memo[key]

    res = single_combo(str, n)
    @single_combos_memo[key] = res
    res
  end

  def single_combo(str, n)
    return 1 if str.length == n
    l_idx = str.index("#")
    return str.length - n + 1 unless l_idx
    r_idx = str.rindex("#")
    return 0 if r_idx - l_idx + 1 > n
    return str.length - n + 1if l_idx >= str.length - n && r_idx < n

    used = r_idx - l_idx + 1
    rem = n - used
    left_moves = [l_idx, n - used].min
    right_moves = [str.length - r_idx - 1, n - used].min
    [left_moves, right_moves].min + 1
  end
end
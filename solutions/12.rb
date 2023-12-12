require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day12 < Base
  DAY = 12

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @groups = lines.map do |line|
      springs, ns = line.split(" ")
      split_springs = springs.gsub(".", " ").strip.split(" ").map(&:strip)
      [split_springs, ns.split(",").map(&:to_i)]
    end
  end

  def one
    puts @groups.map { |g| group_perms(*g) }.to_s
  end

  def two
    0 #@groups.to_s
  end

  def group_perms(springs, broken)
    return 0 if springs.length == 0 && broken.length > 0

    spring = springs[0]
    n = broken[0]
    if spring.length < n
      group_perms(springs[1..-1], broken)
    elsif spring.length < n + 2
      local_perms = combos(spring, n)
      local_perms = spring.length - n + 1
      local_perms * group_perms(springs[1..-1], broken[1..-1])
    elsif spring[0] == "#"
      new_spring = spring[n+1..-1]
      new_springs = new_spring ? [new_spring] + springs[1..-1] : springs[1..-1]
      group_perms(springs[1..-1], broken[1..-1])
    else
      while spring[n] == "#" { n += 1 }
      local_perms = combos(spring[0..n-1], n)
      new_springs = new_spring ? [new_spring] + springs[1..-1] : springs[1..-1]
      group_perms(springs[1..-1], broken[1..-1])

    end
    
  end

  def combos(str, n)
    return 1 if str.length == n
    l_idx = str.index("#")
    return str.length - n + 1 unless l_idx
    r_idx = str.rindex("#")
    used = r_idx - l_idx + 1
    rem = n - used
    left_moves = [l_idx, used].min
    right_moves = [str.length - r_idx - 1, n - used].min
    [left_moves, right_moves].min + 1
  end
end
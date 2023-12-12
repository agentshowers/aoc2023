require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day12 < Base
  DAY = 12

  def initialize(type = "example")
    @lines = Parser.lines(DAY, type)
    @memo = {}
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

  def solve(springs, sizes)
    key = "#{springs.join("-")}-#{sizes.join("-")}"
    return @memo[key] if @memo[key]
    res = inner_solve(springs, sizes)
    @memo[key] = res
    res
  end

  def inner_solve(springs, sizes)
    return 0 if springs.select { |s| s.include?("#") }.length > sizes.length
    return 0 if springs.length == 0 && sizes.length > 0
    return 1 if sizes.length == 0
    
    n = sizes[0]
    spring = springs[0]
    spr_len = spring.length

    return 0 if spring.include?("#") && n > spr_len
    return solve(springs[1..-1], sizes) if n > spr_len

    i = 0
    res = 0
    stop = false
    while n + i <= spr_len && !stop
      stop = true if spring[i] == "#"
      if spr_len == n + i
        res += solve(springs[1..-1], sizes[1..-1])
      elsif spring[n+i] != "#"
        if spr_len == n + i + 1
          new_springs = springs[1..-1]
        else
          split_spring = spring[n+i+1..-1]
          new_springs = [split_spring] + springs[1..-1]
        end
        res += solve(new_springs, sizes[1..-1])
      end
      i += 1
    end
    res += solve(springs[1..-1], sizes) if !spring.include?("#")
    res
  end
end
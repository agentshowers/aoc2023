#!/usr/bin/env ruby

require 'json'
require 'optparse'
require 'uri'
require 'net/http'

DAYS = 12


def solve(range)
  range.map do |n|
    printf("\r\e[KSolving #{n}/#{DAYS}")
    require_relative "solutions/#{n}.rb"
  
    day_class = Kernel.const_get("Day#{n}")
    t1 = Time.now
    day = day_class.new("input")
    res1 = day.one
    res2 = day.two
    t2 = Time.now
    time = 1000.0 * (t2 - t1)

    [n, res1, res2, time]
  end
end

def pretty_print(solutions)
  printf("\r\e[K")
  total_time = solutions.map {_1[3]}.sum

  puts "-----------------------------------------------------------------"
  puts "| Day | Part 1               | Part 2               | Time       |"
  puts "-----------------------------------------------------------------"


  solutions.each do |day, pt1, pt2, time|
    if time < 100.0
      color_code = 32
    elsif time < 1000.0
      color_code = 33
    else
      color_code = 31
    end
    time_str = "#{time.round(2).to_s} ms"
    puts sprintf("| %-3s | %-20s | %-20s | \e[#{color_code}m%-10s\e[0m |", day, pt1, pt2, time_str)
  end

  puts "-----------------------------------------------------------------\n"
  puts " "*42 + "Total time: #{total_time.round(2)} ms"
end


range = (1..DAYS)

puts "******************************************************************"
puts "*                                                                *"
puts "*                  🎄🎄 Advent of Code 2023 🎄🎄                 *"
puts "*                                                                *"
puts "******************************************************************"
puts ""

solutions = solve(range)
pretty_print(solutions)
  
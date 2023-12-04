#!/usr/bin/env ruby

Dir["./solutions/*.rb"].each {|file| require file }

raise StandardError.new("Missing day") if !ARGV[0]

type = ARGV[1] || "example"

clazz = Object.const_get("Day#{ARGV[0]}")
day = clazz.new(type)
day.print_one
day.print_two
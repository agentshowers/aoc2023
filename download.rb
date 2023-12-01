#!/usr/bin/env ruby

require 'net/http'
require 'erb'

raise StandardError.new("Missing day") if !ARGV[0]

day = ARGV[0]
year = ARGV[1] || 2023

# Fetch input

cookie = File.read("cookie").strip

uri = URI("https://adventofcode.com/#{year}/day/#{day}/input")
req = Net::HTTP::Get.new(uri)
req['Cookie'] = "session=#{cookie}"
res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) { |http| http.request(req) }
File.open("input/#{day}.txt", 'w') do |file|
  file.write(res.body)
end

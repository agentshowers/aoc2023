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

# Generate code

TEMPLATE_FILE = 'template.erb'

$day = day

render = ERB.new(File.read(TEMPLATE_FILE),trim_mode: ">")
File.write("solutions/#{day}.rb", render.result)

# Open page

%x{ touch example/#{day}.txt }
%x{ code solutions/#{day}.rb }
%x{ code example/#{day}.txt }

%x{ open -a Firefox 'https://adventofcode.com/#{year}/day/#{day}' }
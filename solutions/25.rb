require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day25 < Base
  DAY = 25

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @wires = {}
    lines.each do |line|
      source, dest = line.split(": ")
      @wires[source] ||= []
      dest.split(" ").each do |w|
        @wires[w] ||= []
        @wires[source] << w
        @wires[w] << source
      end
    end
    @wires["xft"].delete("pzv")
    @wires["pzv"].delete("xft")
    @wires["sds"].delete("hbr")
    @wires["hbr"].delete("sds")
    @wires["dqf"].delete("cbx")
    @wires["cbx"].delete("dqf")
  end

  def one
    visited = {}
    queue = ["xft"]
    count = 0
    while queue.any?
      next_v = queue.pop
      next if visited[next_v]
      visited[next_v] = true
      count += 1
      @wires[next_v].each do |dst|
        queue << dst if !visited[dst]
      end
    end
    (@wires.keys.length - count) * count
  end

  def two
    ":)"
  end
end
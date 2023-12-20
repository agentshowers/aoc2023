require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

HIGH = 1
LOW = 0

class Day20 < Base
  DAY = 20

  def initialize(type = "example")
    @modules = {}
    lines = Parser.lines(DAY, type)
    lines.each do |line|
      id, outputs = line.split(" -> ")
      outputs = outputs.split(", ")
      if id.start_with?("&")
        id = id[1..-1]
        @modules[id] = Conjunction.new(id, outputs)
      elsif id.start_with?("%")
        id = id[1..-1]
        @modules[id] = FlipFlop.new(id, outputs)
      else
        @modules[id] = Broadcaster.new(id, outputs)
      end
    end
    @modules.values.each do |mod|
      mod.outputs.each do |output|
        @modules[output] = Module.new(output, []) if !@modules[output]
        @modules[output].add_input(mod.id)
      end
    end
    iterate
  end

  def one
    @high_lows[0] * @high_lows[1]
  end

  def two
    @cycle_counter.values.reduce(1, :lcm)
  end

  def iterate
    @high_lows = [0, 0]
    @counter = 0
    # I _think_ this would work for most inputs, as they all seem to have a single Conjunction gate leading to rx
    # We need to find the cycle of when the inputs to this gate pulse HIGH and then find the LCM of all of them
    # They also seem to be prime, so multiplying them would work too instead of LCM
    inputs = @modules["rx"].inputs.keys
    inputs = @modules[inputs.first].inputs.keys if inputs.length == 1
    @cycle_counter = inputs.map { |id| [id, 0] }.to_h
    while @cycle_counter.values.any? { |x| x == 0 }
      @counter += 1
      press_button
    end
  end

  def press_button
    queue = [["button", "broadcaster", LOW]]
    while queue.any?
      origin, dest, freq = queue.shift
      # only count the first 1000 pushes for part 1
      @high_lows[freq] += 1 if @counter <= 1000
      @cycle_counter[origin] = @counter if freq == HIGH && @cycle_counter[origin]
      @modules[dest].pulse(origin, freq).each do |output, freq|
        queue << [dest, output, freq]
      end
    end
  end
end

class Module
  attr_reader :id, :outputs, :inputs

  def initialize(id, outputs)
    @id = id
    @outputs = outputs
    @inputs = {}
  end

  def add_input(input)
    @inputs[input] = LOW
  end

  def pulse(_origin, _freq)
    []
  end
end

class Broadcaster < Module
  def pulse(_origin, freq)
    @outputs.map { |id| [id, freq] }
  end
end

class FlipFlop < Module
  def initialize(id, outputs)
    super
    @on = false
  end

  def pulse(_origin, freq)
    return [] if freq == HIGH

    freq = 1 - freq if !@on
    @on = !@on
    @outputs.map { |id| [id, freq] }
  end
end

class Conjunction < Module
  def pulse(origin, freq)
    @inputs[origin] = freq
    output = @inputs.values.any? { |x| x == LOW } ? HIGH : LOW
    @outputs.map { |id| [id, output] }
  end
end

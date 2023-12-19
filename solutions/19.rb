require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day19 < Base
  DAY = 19

  def initialize(type = "example")
    workflows, parts = Parser.read(DAY, type).split("\n\n")
    @workflows = {}
    workflows.split("\n").map do |workflow|
      key, conditions = /(\w+){(.*)}/.match(workflow).captures
      @workflows[key] = conditions.split(",").map do |str|
        if !str.include?(":")
          [nil, str]
        else
          cond_str, outcome = str.split(":")
          match_data = /(\w+)([<>])(\d+)/.match(cond_str)
          variable, signal, value = match_data.captures
          condition = Condition.new(variable, signal, value.to_i)
          [condition, outcome]
        end
      end
    end
    @parts = parts.split("\n").map do |part|
      part.gsub(/[{}]/,"").split(",").map do |x|
        k,v = x.split("=")
        [k, v.to_i]
      end.to_h
    end
  end

  def one
    @parts.map do |part|
      accepted?(part) ? part.values.sum : 0
    end.sum
  end

  def two
    4000.pow(4) - count_rejections("in", [])
  end

  def count_rejections(key, conditions)
    total = 0
    @workflows[key].each do |condition, outcome|
      if outcome == "R"
        total += rejected_combinations((conditions + [condition]).compact)
      elsif outcome != "A"
        total += count_rejections(outcome, conditions.dup + [condition])
      end
      conditions << condition.reverse if condition
    end
    total
  end

  def rejected_combinations(conditions)
    ranges = {
      "x" => { "min" => 1, "max" => 4000 },
      "m" => { "min" => 1, "max" => 4000 },
      "a" => { "min" => 1, "max" => 4000 },
      "s" => { "min" => 1, "max" => 4000 },
    }

    conditions.each do |condition|
      case condition.signal
      when "<"
        ranges[condition.variable]["max"] = condition.value - 1
      when "<="
        ranges[condition.variable]["max"] = condition.value
      when ">"
        ranges[condition.variable]["min"] = condition.value + 1
      when ">="
        ranges[condition.variable]["min"] = condition.value
      end
    end

    ranges.values.map do |range|
      [range["max"] - range["min"] + 1, 0].max
    end.inject(:*)
  end

  def accepted?(part)
    current = "in"

    while !["A", "R"].include?(current)
      @workflows[current].each do |condition, outcome|
        if !condition || condition.apply?(part)
          current = outcome
          break
        end
      end
    end

    current == "A"
  end
end

class Condition
  attr_reader :variable, :signal, :value

  def initialize(variable, signal, value)
    @variable = variable
    @signal = signal
    @value = value
  end

  def apply?(part)
    part[@variable].send(@signal, @value)
  end

  def reverse
    reverse_condition = @signal == "<" ? ">=" : "<="
    Condition.new(@variable, reverse_condition, @value)
  end
end

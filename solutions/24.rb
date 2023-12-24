require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"
require 'z3'

class Day24 < Base
  DAY = 24

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @stones = lines.map do |str|
      pos, vel = str.split(" @ ")
      pos = pos.split(",").map(&:to_i)
      vel = vel.split(",").map(&:to_i)
      [pos, vel]
    end
    @intersection_range = type == "example" ? [7, 27] : [200000000000000, 400000000000000]
  end

  def one
    sum = 0
    @stones.each_with_index do |stone, i|
      (i+1...@stones.size).each do |j|
        sum += 1 if intersects?(stone, @stones[j])
      end
    end
    sum
  end

  def two
    solver = Z3::Solver.new

    x = Z3.Int('x')
    y = Z3.Int('y')
    z = Z3.Int('z')
    ax = Z3.Int('ax')
    ay = Z3.Int('ay')
    az = Z3.Int('az')

    @stones.each_with_index do |stone, i|
      t = Z3.Int("t#{i}")

      solver.assert(t >= 0)

      solver.assert(stone[0][0] + stone[1][0]*t == x + ax*t)
      solver.assert(stone[0][1] + stone[1][1]*t == y + ay*t)
      solver.assert(stone[0][2] + stone[1][2]*t == z + az*t)
    end

    if solver.satisfiable?
      model = solver.model
      model[x].to_s.to_i + model[y].to_s.to_i + model[z].to_s.to_i
    else
      "oh shit"
    end
  end

  def intersects?(stone1, stone2)
    x, y = intersection(stone1, stone2)
    return false if x.abs == Float::INFINITY
    return false if past?(stone1, x, y) || past?(stone2, x, y)
    return false if x < @intersection_range[0] || x > @intersection_range[1] || y < @intersection_range[0] || y > @intersection_range[1]
    true
  end

  def intersection(stone1, stone2)
    a1 = -stone1[1][1]*1.0 / stone1[1][0]
    c1 = -(stone1[0][1] + a1 * stone1[0][0])

    a2 = -stone2[1][1]*1.0 / stone2[1][0]
    c2 = -(stone2[0][1] + a2 * stone2[0][0])

    x = (c2-c1) / (a1-a2)
    y = (c1*a2 - c2*a1) / (a1-a2)
    [x, y]
  end

  def past?(stone, x, y)
    (x - stone[0][0]) * stone[1][0] < 0 || (y - stone[0][1]) * stone[1][1] < 0
  end
end



# t0 = Z3.Int('t0')
# t1 = Z3.Int('t1')
# x = Z3.Real('x')
# y = Z3.Real('y')
# z = Z3.Real('z')
# ax = Z3.Real('ax')
# ay = Z3.Real('ay')
# az = Z3.Real('az')

# solver.assert(t0 >= 0)
# solver.assert(t1 >= 0)

# solver.assert(19 + -2*t0 == x + ax*t0)
# solver.assert(13 +  1*t0 == y + ay*t0)
# solver.assert(30 + -2*t0 == z + az*t0)

# solver.assert(18 + -1*t1 == x + ax*t1)
# solver.assert(19 + -1*t1 == y + ay*t1)
# solver.assert(22 + -2*t1 == z + az*t1)

# 19, 13, 30 @ -2,  1, -2
# 18, 19, 22 @ -1, -1, -2
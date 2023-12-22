require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day21 < Base
  DAY = 21

  def initialize(type = "example")
    raw_map = Parser.lines(DAY, type)
    @n = raw_map.length
    @map = []
    5.times do
      raw_map.each do |line|
        @map << line.gsub("S", ".") * 5
      end
    end
    @map.flatten!

    visit
  end

  def one
    @one_count
  end

  def two
    cycles = (26501365 - @n/2)/@n
    acc = 0

    [[0, 2], [2, 0], [2, 4], [4, 2]].each do |x, y|
      acc += @visited[1].keys.select { |x1,y1| x1 >= @n*x && x1 < @n*(x+1) && y1 >= @n*y && y1 < @n*(y+1) }.count
    end

    [[0, 1], [0, 3], [4, 1], [4, 3]].each do |x, y|
      acc += cycles * @visited[1].keys.select { |x1,y1| x1 >= @n*x && x1 < @n*(x+1) && y1 >= @n*y && y1 < @n*(y+1) }.count
    end

    [[1, 1], [1, 3], [3, 1], [3, 3]].each do |x, y|
      acc += (cycles-1) * @visited[1].keys.select { |x1,y1| x1 >= @n*x && x1 < @n*(x+1) && y1 >= @n*y && y1 < @n*(y+1) }.count
    end
    
    acc += cycles.pow(2) * @visited[1].keys.select { |x,y| x >= @n*1 && x < @n*2 && y >= @n*2 && y < @n*3 }.count
    acc += (cycles.pow(2) - 2*cycles + 1) * @visited[1].keys.select { |x,y| x >= @n*2 && x < @n*3 && y >= @n*2 && y < @n*3 }.count
    
    acc
  end

  def visit
    queue = [[], []]
    @visited = [{}, {}]
    start_x = start_y = @map.length / 2
    steps = 0
    state = 0
    queue[state] << [start_x, start_y]
    @visited[state][[start_x, start_y]] = true

    while steps < (@n/2 + 2*@n)
      while queue[state].any?
        x, y = queue[state].shift
        neighbors(x, y).each do |nx, ny|
          if @map[nx][ny] == "." && !@visited[1-state][[nx, ny]]
            queue[1-state] << [nx, ny]
            @visited[1-state][[nx, ny]] = true
          end
        end
      end
      state = 1 - state
      steps += 1
      @one_count = @visited[0].keys.count if steps == 64
    end
  end

  def neighbors(x, y)
    [[x-1, y], [x+1, y], [x, y-1], [x, y+1]]
  end
end
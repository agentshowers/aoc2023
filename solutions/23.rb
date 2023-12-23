require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day23 < Base
  DAY = 23

  def initialize(type = "example")
    @map = Parser.lines(DAY, type)
    @n_rows = @map.length
    @n_cols = @map[0].length
    find_junctions
    generate_graph
  end

  def one
    longest_path({}, [0, 1], true)
  end

  def two
    longest_path({}, [0, 1], false)
  end

  def longest_path(visited, node, directed)
    return 0 if terminal?(*node)
    return @last_distance if node == @pre_terminal

    visited[node] = true
    max = 0
    @junctions[node].each do |junction, dist, slope_forward|
      next unless !directed || slope_forward
      next if visited[junction]
      subpath = longest_path(visited, junction, directed)
      max = (subpath + dist) if (subpath + dist > max)
    end

    visited[node] = false
    max
  end

  def find_junctions
    @junctions = {}
    @junctions[[0,1]] = []
    (1..@n_rows-2).each do |x|
      (1..@n_cols-2).each do |y|
        neighbors = 0
        [[x-1, y], [x+1, y], [x, y-1], [x, y+1]].map do |nx, ny|
          neighbors += 1 if @map[nx][ny] != "#"
        end
        @junctions[[x,y]] = [] if neighbors > 2
      end
    end
    @junctions[[@n_rows - 1, @n_cols - 2]] = []
  end

  def generate_graph
    visited = {}
    queue = [[0, 1]]

    while queue.any?
      junction = queue.pop
      next if visited[junction]
      visited[junction] = true

      moves = next_steps(*junction)
      moves.each do |nx, ny|
        steps = 1
        local_visited = [junction]
        while !@junctions[[nx, ny]] do
          local_visited << [nx, ny]
          nx, ny = (next_steps(nx, ny) - local_visited).first
          steps += 1
        end
        @junctions[junction] << [[nx, ny], steps, true]
        @junctions[[nx, ny]] << [junction, steps, false]
        queue << [nx, ny] if !visited[[nx, ny]] && !terminal?(nx, ny)
      end
    end

    @pre_terminal = @junctions[[@n_rows - 1, @n_cols - 2]].first[0]
    @last_distance = @junctions[[@n_rows - 1, @n_cols - 2]].first[1]
  end

  def next_steps(x, y)
    case @map[x][y]
    when ">"
      return [[x, y+1]]
    when "v"
      return [[x+1, y]]
    when "<"
      return [[x, y-1]]
    when "^"
      return [[x-1, y]]
    else
      neighbors = []
      neighbors << [x-1, y] if !["#", "v"].include?(@map[x-1][y])
      neighbors << [x+1, y] if !["#", "^"].include?(@map[x+1][y])
      neighbors << [x, y-1] if !["#", ">"].include?(@map[x][y-1])
      neighbors << [x, y+1] if !["#", "<"].include?(@map[x][y+1])
      return neighbors
    end
  end

  def terminal?(x, y)
    x == @n_rows - 1 && y == @n_cols - 2
  end
end
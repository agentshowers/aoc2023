require "./lib/parser.rb"
require "./lib/utils.rb"
require "./lib/base.rb"

class Day22 < Base
  DAY = 22
  MAX = 10
  GROUND = -1
  EMPTY = nil

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @pieces = lines.map do |line|
      e1, e2 = line.split("~")
      [e1.split(",").map(&:to_i), e2.split(",").map(&:to_i)]
    end.sort_by { |x| x[0][2] }

    unfreeze
  end

  def one
    @core_pieces = @supports.select { |x| x.length == 1 && x[0] != -1 }.map { |x| x[0] }.uniq
    @pieces.length - @core_pieces.length
  end

  def two
    arr = Array.new(@pieces.length) { -1 }
    @core_pieces.map do |idx|
      dropping_pieces(idx)
    end.sum
  end

  def dropping_pieces(idx)
    supports = Marshal.load(Marshal.dump(@supports))
    dropping = [idx]
    count = 0
    
    while dropping.any?
      dropped = dropping.shift
      (@supporters[dropped] || []).each do |block|
        supports[block].delete(dropped)
        if supports[block].length == 0
          dropping << block
          count += 1
        end
      end
    end

    count
  end

  # Drop logic

  def unfreeze
    @stack = []
    @stack << Array.new(MAX) { Array.new(MAX) { GROUND } }
    @supports = Array.new(@pieces.length) { [] }
    @supporters = {}
    @pieces.each_with_index do |piece, idx|
      drop(piece, idx)
    end
  end

  def drop(piece, idx)
    min_x = piece[0][0]
    min_y = piece[0][1]
    min_z = piece[0][2]
    max_x = piece[1][0]
    max_y = piece[1][1]
    max_z = piece[1][2]

    under = []
    loop do
      under = find_at(min_z-1, min_x, max_x, min_y, max_y)
      break if under.length > 0
      min_z -= 1
      max_z -= 1
    end

    under.each do |under_idx|
      @supporters[under_idx] ||= []
      @supporters[under_idx] << idx
    end
    @supports[idx] = under
    (min_z..max_z).each do |z|
      if @stack.length <= z
        @stack << Array.new(MAX) { Array.new(MAX) { EMPTY } }
      end
      (min_x..max_x).each do |x|
        (min_y..max_y).each do |y|
          @stack[z][x][y] = idx
        end
      end
    end
  end

  def find_at(z, min_x, max_x, min_y, max_y)
    return [] if @stack.length <= z
    blocks = []
    @stack[z][min_x..max_x].each do |row|
      row[min_y..max_y].each do |block|
        blocks << block if block
      end
    end
    blocks.uniq
  end
end
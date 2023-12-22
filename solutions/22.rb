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
    @pieces.length - @core_pieces.length
  end

  def two
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
      (@dependents[dropped] || []).each do |block|
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
    @supports = Array.new(@pieces.length) { [] }
    @dependents = {}
    @core_pieces = []

    stack = []
    stack << Array.new(MAX) { Array.new(MAX) { GROUND } }
    (0..@pieces.length-1).each do |idx|
      drop(idx, stack)
    end
  end

  def drop(idx, stack)
    piece = @pieces[idx]
    min_x, min_y, min_z = piece[0]
    max_x, max_y, max_z = piece[1]
    supports = []

    loop do
      if stack.length > min_z - 1
        supports = find_at(stack, min_z-1, min_x, max_x, min_y, max_y)
        break if supports.length > 0
      end
      min_z -= 1
      max_z -= 1
    end

    update_stack(stack, idx, min_x, min_y, min_z, max_x, max_y, max_z)

    supports.each do |sup_idx|
      @dependents[sup_idx] ||= []
      @dependents[sup_idx] << idx
    end
    @supports[idx] = supports
    @core_pieces << supports[0] if supports[0] != GROUND && supports.length == 1 && !@core_pieces.include?(supports[0])
  end

  def find_at(stack, z, min_x, max_x, min_y, max_y)
    blocks = []
    stack[z][min_x..max_x].each do |row|
      row[min_y..max_y].each do |block|
        blocks << block if block
      end
    end
    blocks.uniq
  end

  def update_stack(stack, idx, min_x, min_y, min_z, max_x, max_y, max_z)
    (min_z..max_z).each do |z|
      if stack.length <= z
        stack << Array.new(MAX) { Array.new(MAX) { EMPTY } }
      end
      (min_x..max_x).each do |x|
        (min_y..max_y).each do |y|
          stack[z][x][y] = idx
        end
      end
    end
  end
end
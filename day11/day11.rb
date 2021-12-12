require_relative '../utility/utils.rb'

day = 11
process_method = :process_grid

class Point < Struct.new(:row, :col, keyword_init: true)
  def out_of_grid(grid)
    row < 0 || col < 0 || col >= grid.max_col || row >= grid.max_row
  end

  def zero?(grid)
    grid.grid[row][col] == 0
  end

  def flash?(grid)
    grid.grid[row][col] > 9
  end

  def incr_by_one(grid)
    grid.grid[row][col] = grid.grid[row][col] + 1
  end

  def propagate(grid)
    return if out_of_grid(grid)
    return if zero?(grid)

    if flash?(grid)
      grid.grid[row][col] = 0
      grid.number_of_flashes += 1
      adjacent_points.each { |point| point.propagate(grid) }
    else
      incr_by_one(grid)
      if flash?(grid)
        grid.grid[row][col] = 0
        grid.number_of_flashes += 1
        adjacent_points.each { |point| point.propagate(grid) }
      end
    end
  end

  def adjacent_points
    tl = Point.new(row: row - 1, col: col - 1)
    t = Point.new(row: row - 1, col: col)
    tr = Point.new(row: row - 1, col: col + 1)
    l = Point.new(row: row, col: col - 1)
    r = Point.new(row: row, col: col + 1)
    bl = Point.new(row: row + 1, col: col - 1)
    b = Point.new(row: row + 1, col: col)
    br = Point.new(row: row + 1, col: col + 1)

    [tl, t, tr, l, r, bl, b, br]
  end
end

class Grid
  def initialize(input)
    @max_row = input.size
    @max_col = input.first.size
    @grid = input
    @step_count = 0
    @number_of_flashes = 0
  end

  def number_of_flashes=(value)
    @number_of_flashes=value
  end

  def number_of_flashes
    @number_of_flashes
  end

  def max_row
    @max_row
  end

  def max_col
    @max_col
  end

  def grid
    @grid
  end

  def step_count
    @step_count
  end

  def step
    increase_by_one
    flash_locations = flashes
    propagate_flashes(flash_locations)
    @step_count += 1
  end

  def step_by(x, print_grid: false)
    print if print_grid
    x.times do
      step
      print if print_grid
    end
  end

  def find_sync
    loop do
      step
      return step_count if in_sync?
    end
  end

  def in_sync?
    grid.flatten.min == grid.flatten.max
  end

  def propagate_flashes(flash_locations)
    flash_locations.each do |location|
      location.propagate(self)
    end
  end

  def flashes
    flashes = []
    grid.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        flashes << Point.new(row: row_index, col: col_index) if col > 9
      end
    end
    flashes
  end

  def increase_by_one
    grid.map! do |row|
      row.map! do |col|
        col + 1
      end
    end
  end

  def print
    puts "Grid at #{step_count}"
    grid.each do |row|
      puts "#{row}"
    end
    puts "\n"
  end
end

input = send(process_method, file_name(day))
sample = send(process_method, 'sample.txt')
input2 = send(process_method, file_name(day))
sample2 = send(process_method, 'sample.txt')

def puzzle1(input)
  grid = Grid.new(input)
  grid.step_by(100, print_grid: false)
  grid.number_of_flashes
end

def puzzle2(input)
  grid = Grid.new(input)
  grid.find_sync
end

puts "Sample Puzzle 1: #{puzzle1(sample)}"
puts "Puzzle 1: #{puzzle1(input)}"
puts "Sample Puzzle 2: #{puzzle2(sample2)}"
puts "Puzzle 2: #{puzzle2(input2)}"

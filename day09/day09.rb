require_relative '../utility/utils.rb'
require 'set'

day = 9

input = process_grid(file_name(day))
sample = process_grid('sample.txt')

class LowPoint < Struct.new(:row, :col, :value, keyword_init: true)
end
class Point < Struct.new(:row, :col, keyword_init: true)
end

def index_of_contenders(line)
  contenders = []
  contenders << [line[0], 0] if line[0] < line[1]

  inner_contenders = line[1..-2].map.with_index do |value, index|
    actual_index = index + 1
    if line[actual_index] < line[actual_index - 1] && line[actual_index] < line[actual_index + 1]
      [line[actual_index], actual_index]
    else
      nil
    end
  end.compact

  contenders = contenders + inner_contenders
  contenders << [line[-1], (line.size - 1)] if line[-1] < line[-2]
  contenders
end

def check_above(contenders, previous_line)
  contenders.select do |contender|
    value, index = contender
    value < previous_line[index]
  end
end

def check_below(previous_contenders, current_line)
  previous_contenders.select do |contender|
    value, index = contender
    value < current_line[index]
  end
end

def low_points(input)
  low_points  = Set.new
  previous_contenders = []
  previous_line = []

  input.each.with_index do |line, row|
    new_contenders = index_of_contenders(line)

    # First line, move on
    if previous_line.empty?
      previous_line = line
      previous_contenders = new_contenders
      next
    end

    # Check previous contenders for current line
    new_risk_points = check_below(previous_contenders, line)
    new_risk_points.each do |point|
      low_points.add(LowPoint.new(row: row - 1, col: point[1], value: point.first ))
    end

    previous_contenders = check_above(new_contenders, previous_line)

    # On the last line
    if row == input.size - 1
      previous_contenders.each do |point|
        low_points.add(LowPoint.new(row: row , col: point[1], value: point.first ))
      end
      next
    end

    previous_line = line
  end
  low_points
end

def puzzle1(input)
  low_points(input).reduce(0) { |sum, point| sum + point.value + 1 }
end

# We'll leaves marks in the grid if the point has already been visited
def low_point_in_previous_basin(low_point, input)
  input[low_point.row][low_point.col] == -1
end

# Calculate the basin size
def basin_size(point, input)
  return 0 if out_of_grid(point, input)

  value = input[point.row][point.col]

  return 0 if value == 9   # Edge
  return 0 if value == -1  # Already Visited

  input[point.row][point.col] = -1
  1 + next_points(point).reduce(0) { |sum, npoint| sum + basin_size(npoint, input) }
end

# Returns the adjacent points to the current point
def next_points(point)
  top = Point.new(row: point.row + 1, col: point.col)
  bottom = Point.new(row: point.row - 1, col: point.col)
  left = Point.new(row: point.row, col: point.col - 1)
  right = Point.new(row: point.row, col: point.col + 1)
  [top, bottom, left, right]
end

# Returns whether the current point is out of the grid
def out_of_grid(point, input)
  max_row = input.size
  max_col = input.first.size
  point.row < 0 || point.col < 0 || point.row >= max_row || point.col >= max_col
end

def puzzle2(input)
  basins = []
  low_points = low_points(input)
  low_points.each do |low_point|
    next if low_point_in_previous_basin(low_point, input)
    basins << basin_size(low_point, input)
  end
  basins.sort.last(3).reduce(&:*)
end

puts "Sample Puzzle 1: #{puzzle1(sample)}"
puts "Puzzle 1: #{puzzle1(input)}"
puts "Sample Puzzle 2: #{puzzle2(sample)}"
puts "Puzzle 2: #{puzzle2(input)}"

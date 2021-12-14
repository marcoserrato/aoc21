require_relative '../utility/utils.rb'
require 'set'
require 'pry'

day = 13
process_method = :process_coordinates

input = send(process_method, file_name(day))
sample = send(process_method, 'sample.txt')

def fold(point, fold)
  case fold.direction
  when :row # Fold up
    # The col point shouldn't change, but the row should
    return point if point.row < fold.value

    new_row = fold.value - (point.row - fold.value)
    Point.new(row: new_row, col: point.col)
  when :col # Fold left
    # The row point shouldn't change, but the col should
    return point if point.col < fold.value # No need to fold if I'm above the line

    new_column = fold.value - (point.col - fold.value)
    Point.new(row: point.row, col: new_column  )
  end
end

def fold_by(points, folds, number_of_folds: nil)
  starting_points = Set.new(points)
  ending_points = Set.new

  folds = number_of_folds.nil? ? folds : folds[0..(number_of_folds - 1)]

  folds.each do |fold|
    starting_points.each do |point|
      ending_points.add(fold(point, fold))
    end
    starting_points = ending_points.dup
    ending_points = Set.new
  end
  starting_points
end

def puzzle1(input)
  points, folds = input
  fold_by(points, folds, number_of_folds: 1).count
end

def print(points)
  max_row = points.map(&:row).max
  max_col = points.map(&:col).max

  grid = Array.new(max_row + 1) { Array.new(max_col + 1, ".")}

  points.each do |point|
    grid[point.row][point.col] = "#"
  end

  puts "Grid"
  grid.each do |row|
    puts "#{row.join}"
  end
  puts "\n"
end

def puzzle2(input)
  points, folds = input
  print(fold_by(points, folds))
end

puts "Sample Puzzle 1: #{puzzle1(sample)}"
puts "Puzzle 1: #{puzzle1(input)}"
puts "Sample Puzzle 2: #{puzzle2(sample)}"
puts "Puzzle 2: #{puzzle2(input)}"

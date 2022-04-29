require_relative '../utility/utils.rb'
require 'set'
require 'pry'

day = 15
process_method = :process_grid

input = send(process_method, file_name(day))
sample = send(process_method, 'sample.txt')

def puzzle1(input)
  breadth_first_search(input)
end

def puzzle2(input)
  breadth_first_search(input, part2: true)
  # endp = breadth_first_search(input, part2: true)
  # map = input * 5
  # map.map! { |m| m * 5 }

  # map.each_with_index do |v, row|
  #   v.each_with_index do |n, col|
  #     map[row][col] = weight(input, Point.new(row: row, col: col))
  #   end
  # end

  # c = Point.new(row: 49, col: 49)
  # until endp[c] == nil
  #   e = endp[c]
  #   map[e.row][e.col] = "*"
  #   c = e
  # end

  # map.each do |m|
  #   puts "#{m.join}"
  # end
  # nil
end

def weight(input, point)
  r = point.row / input.size
  c = point.col / input.first.size
  nw = r + c
  weight = input[point.row % 10][point.col % 10]

  if weight + nw > 9
    ((weight + nw) % 10) + 1
  else
    weight + nw
  end
end

def manhattan(point, goal)
  return (point.row - goal.row).abs + (point.col - goal.col).abs
end

def out_of_grid(point, max_row, max_col)
  point.row < 0 || point.col < 0 || point.row >= max_row || point.col >= max_col
end

def adjacent_points(point, max_row, max_col)
  up = Point.new(row: point.row + 1, col: point.col)
  down = Point.new(row: point.row - 1, col: point.col)
  left = Point.new(row: point.row, col: point.col - 1)
  right = Point.new(row: point.row, col: point.col + 1)
  [up, down, left, right].reject { |point| out_of_grid(point, max_row, max_col) }
end

class WeightedPoint < Struct.new(:point, :weight, keyword_init: true)
  def <=>(other)
    self.weight <=> other.weight
  end
end

def breadth_first_search(input, part2: false)
  max_row = input.size
  max_row = max_row * 5 if part2
  max_col = input.first.size
  max_col = max_col * 5 if part2

  start = Point.new(row: 0, col: 0)
  goal = Point.new(row: max_row - 1, col: max_col - 1)

  progress = Set.new
  # came_from = {}
  # came_from[start] = nil
  cost_so_far = {}
  cost_so_far[start] = 0
  frontier = SortedSet.new([WeightedPoint.new(point: start, weight: 0)])
  #frontier = [WeightedPoint.new(point: start, weight: 0)]

  until frontier.empty?
    current = frontier.first
    frontier.delete(current)
    current = current.point

    break if current == goal

    adjacent_points(current, max_row, max_col).each do |adj_point|
      # Cost is the cost so far to get to current + the cost to the adjacent point
      new_cost = cost_so_far[current] + weight(input, adj_point)

      if !cost_so_far.keys.include?(adj_point) || new_cost < cost_so_far[adj_point]
        cost_so_far[adj_point] = new_cost

        priority = new_cost + manhattan(adj_point, goal)

        #puts "#{adj_point} - #{manhattan(adj_point, goal)}"
        frontier.add(WeightedPoint.new(point: adj_point, weight: new_cost))
        #came_from[adj_point] =  current
      end
    end

    #frontier.sort_by! { |v| v.weight }
    end
  cost_so_far[Point.new(row: max_row - 1, col: max_col - 1)]
  #came_from
end

#puts "Sample Puzzle 1: #{puzzle1(sample)}"
#puts "Puzzle 1: #{puzzle1(input)}"
#puts "Sample Puzzle 2: #{puzzle2(sample)}"
puts "Puzzle 2: #{puzzle2(input)}"

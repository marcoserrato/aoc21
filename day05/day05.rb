require_relative '../utility/utils.rb'

input = process_input_segments_to_klass(file_name(5), Segment)

def dimensions(input)
  max_x = input.map { |x| [x.origin_x, x.dest_x] }.flatten.max
  max_y = input.map { |y| [y.origin_y, y.dest_y] }.flatten.max
  [max_x, max_y]
end

def add_segments(segments, grid, consider_diagonal: false)
  segments.each do |segment|
    case segment.direction
    when :x
      y = segment.origin_y
      range = [segment.origin_x, segment.dest_x]
      (range.min..range.max).each do |x|
        grid[y][x] = grid[y][x] + 1
      end
    when :y
      x = segment.origin_x
      range = [segment.origin_y, segment.dest_y]
      (range.min..range.max).each do |y|
        grid[y][x] = grid[y][x] + 1
      end
    when :diagonal
      next unless consider_diagonal

      x_method = (segment.origin_x - segment.dest_x) > 0 ? :reverse_each : :each
      xs = [segment.origin_x, segment.dest_x]
      ys = [segment.origin_y, segment.dest_y]

      ysi = (ys.min..ys.max).to_a
      ysi.reverse! if (segment.origin_y - segment.dest_y) > 0
      (xs.min..xs.max).send(x_method).with_index do |x, index|
        y = ysi[index]
        grid[y][x] = grid[y][x] + 1
      end
    end
  end
end

def intersections(grid)
  grid.flatten.reduce(0) do |sum, v|
    sum = sum + 1 if v > 1
    sum
  end
end

def puzzle1(input)
  max_x, max_y = dimensions(input)
  grid = Array.new(max_y + 1){ Array.new(max_x + 1,0) }
  add_segments(input, grid)
  intersections(grid)
end

def puzzle2(input)
  max_x, max_y = dimensions(input)
  grid = Array.new(max_y + 1){ Array.new(max_x + 1,0) }
  add_segments(input, grid, consider_diagonal: true)
  intersections(grid)
end

sample = process_input_segments_to_klass("sample.txt", Segment)

puts "Puzzle 1 Sample: #{puzzle1(sample)}"
puts "Puzzle 1: #{puzzle1(input)}"
puts "Puzzle 2 Sample: #{puzzle2(sample)}"
puts "Puzzle 2: #{puzzle2(input)}"

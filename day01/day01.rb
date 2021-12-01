require_relative '../utility/utils.rb'

input = process_input_as_ints(file_name(1))

def puzzle1(input)
  depths = input
  previous = depths[0]
  increases = 0
  depths[1..-1].each do |depth|
    increases = increases + 1 if depth > previous
    previous = depth
  end
  increases
end

def puzzle2(input)
  depths = input
  sums = []
  (1..(depths.size-3)).each do |index|
    sums << depths[index..(index+2)].reduce(&:+)
  end

  sum_inc = 0
  previous_sum = depths[0..2].reduce(&:+)
  sums.each do |depth|
    sum_inc = sum_inc + 1 if depth > previous_sum
    previous_sum = depth
  end
  sum_inc
end

puts "Puzzle 1: #{puzzle1(input)}"
puts "Puzzle 2: #{puzzle2(input)}"

require_relative '../utility/utils.rb'

input = process_csv_input(file_name(7))
sample = process_csv_input('sample.txt')

def puzzle1(input)
  mean = input.sort[input.size / 2]
  input.reduce(0) { |sum, value| sum + (mean-value).abs }
end

def puzzle2(input)
  i_suck_at_stats(input)
end

def total_fuel_for_loc(loc, input)
  input.reduce(0) do |sum, value|
    d = (loc-value).abs
    total = (d * (d + 1)) / 2
    sum + total
  end
end

def i_suck_at_stats(input)
  total_fuels = (input.min..input.max).map { |loc| total_fuel_for_loc(loc, input) }.min
end

puts "Sample Puzzle 1: #{puzzle1(sample)}"
puts "Puzzle 1: #{puzzle1(input)}"
puts "Sample Puzzle 2: #{puzzle2(sample)}"
puts "Puzzle 2: #{puzzle2(input)}"

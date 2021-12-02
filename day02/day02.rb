require_relative '../utility/utils.rb'

input = process_multi_value_input(file_name(2))

def puzzle1(directions)
  directions.reduce([0,0]) do |sum, direction|
    intr, value = direction
    value = value.to_i
    case intr
    when "forward"
      sum[0] = sum[0] + value
    when "down"
      sum[1] = sum[1] + value
    when "up"
      sum[1] = sum[1] - value
    end
    sum
  end.reduce(&:*)
end

def puzzle2(directions)
  directions.reduce([0,0,0]) do |sum, direction|
    intr, value = direction
    value = value.to_i
    case intr
    when "forward"
      sum[0] = sum[0] + value
      sum[1] = sum[1] + (sum[2] * value)
    when "down"
      sum[2] = sum[2] + value
    when "up"
      sum[2] = sum[2] - value
    end
    sum
  end[..-2].reduce(&:*)
end

puts "Puzzle 1: #{puzzle1(input)}"
puts "Puzzle 2: #{puzzle2(input)}"

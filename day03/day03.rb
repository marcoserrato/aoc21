require_relative '../utility/utils.rb'

input = process_input(file_name(3))

# Accumulates all the bits per 'column' and checks if they're more or less
# than half the size of the input. That should indicate which value was more
# common.
def get_gamma_rate(input)
  sums = input.reduce(Array.new(input.first.size, 0)) do |sum, line|
    bits = line.split('').map(&:to_i)
    bits.each_with_index do |bit, index|
      sum[index] = sum[index] + bit
    end
    sum
  end
  sums.map { |sum| sum > input.length / 2 ? 1 : 0 }.join
end

def puzzle1(input)
  # to_i accepts a base, which converts the string binrary representation of
  # gamma to an int.
  gamma = get_gamma_rate(input).to_i(2)
  # xor against all 1s gives us the opposite value!
  epsilon = gamma ^ (2**(input.first.length)-1)

  gamma * epsilon
end

def most_common(input, position)
  total = input.reduce(0) do |sum , line|
    sum += line.split('')[position].to_i
    sum
  end
  # problem is division by two isn't accurate
  if total == input.length / 2.0
    1
  else
    total > (input.length / 2) ? 1 : 0
  end
end

def least_common(input, position)
  total = input.reduce(0) do |sum , line|
    sum += line.split('')[position].to_i
    sum
  end
  # problem is division by two isn't accurate
  if total == input.length / 2.0
    0
  else
    total > (input.length / 2) ? 0 : 1
  end
end

def gas_filter(input, comp)
  bits = input.first.length
  index = 0
  found = false
  subset = input
  while index < bits && !found
    common = send(comp, subset, index)
    subset = subset.select { |line| line[index].to_i == common }
    if subset.size == 1
      found = true
    else
      index = index + 1
    end
  end
  subset.first
end

def puzzle2(input)
  gas_filter(input, :most_common).to_i(2) * gas_filter(input, :least_common).to_i(2)
end

puts "Puzzle 1: #{puzzle1(input)}"
puts "Puzzle 2: #{puzzle2(input)}"


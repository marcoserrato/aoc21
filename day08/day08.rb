require_relative '../utility/utils.rb'
require 'set'

day = 8

input = process_signals(file_name(day))
sample = process_signals('sample.txt')

def puzzle1(input)
  result = input.map do |seqs|
    seqs[1].split.select do |seq|
      [2,3,4,7].include?(seq.size)
    end
  end
  result.flatten.count
end

def puzzle2(input)
  input.reduce(0) do |sum,code|
    scramble, output = code
    solver = segment_solver(scramble)
    sum + output.split.map { |scram| get_value(scram, solver) }.join.to_i
  end
end

ZERO = Set.new([:t, :b, :lt, :rt, :rb, :lb])
TWO = Set.new([:t, :rt, :m, :lb, :b])
THREE = Set.new([:t, :m, :b, :rt, :rb])
FIVE = Set.new([:t, :lt, :m, :rb, :b])
SIX = Set.new([:t, :lt, :m, :rb, :lb, :b])
NINE = ZERO.dup
NINE.add(:m)
NINE.delete(:lb)
NUMBERS = [[ZERO, 0], [TWO, 2], [THREE, 3], [FIVE,5], [SIX,6], [NINE,9]]

def get_value(output, solver)
  num = output.split('').map { |char| solver[char] }.to_set
  case num.size
  when 2
    1
  when 3
    7
  when 4
    4
  when 7
    8
  else
    NUMBERS.each do |(number, index)|
      return index if (number ^ num).empty?
    end
  end
end

def frequencies(lines)
  lines.split(' ').reduce({}) do |counts, line|
    line.split('').each do |char|
      counts[char] ||= 0
      counts[char] = counts[char] + 1
    end
    counts
  end
end

def segment_solver(input)
  solver = Hash.new
  one, seven, four, eight = input.split.select { |v| [2,3,4,7].include?(v.size) }.sort_by(&:length)

  frequencies = frequencies(input)
  rf = frequencies.invert

  sevens = frequencies.select { |k, v| v == 7 }.keys
  eights = frequencies.select { |k, v| v == 8 }.keys

  # The top left segment is the only segment that appears 6 times across all 10 digits.
  solver[:lt] = rf[6]
  # Same for the bottom left segment but 4 times.
  solver[:lb] = rf[4]
  # Again for the bottom right segment but 9 times.
  solver[:rb] = rf[9]

  # The top right and bottom right segments both appear in 1 and 4, however, we now know
  # what segment the bottom right is so we can remove it from the intersection of both sets.
  solver[:rt] = (one.split('').to_set & four.split('').to_set).delete(solver[:rb]).first

  # The top and right top segments are the only segments that appear 8 times, and now we know
  # the top right segments.
  solver[:t] = Set.new(eights).delete(solver[:rt]).first

  # Since we know all the segments for four except the middle
  solver[:m] = (four.split('').to_set ^ Set.new([solver[:lt], solver[:rt], solver[:rb]])).first

  # Finally bottom and middle are the only segments that appear 7 times, and we now know middle.
  solver[:b] = (Set.new(sevens) ^ Set.new([solver[:m]])).first

  solver.invert
end

puts "Sample Puzzle 1: #{puzzle1(sample)}"
puts "Puzzle 1: #{puzzle1(input)}"
puts "Sample Puzzle 2: #{puzzle2(sample)}"
puts "Puzzle 2: #{puzzle2(input)}"

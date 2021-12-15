require_relative '../utility/utils.rb'

day = 14
process_method = :process_polymer_template

input = send(process_method, file_name(day))
sample = send(process_method, 'sample.txt')

# The bad way...
def synthesize(sequence, template)
  new_sequence = []
  frequencies = {}
  (0..(sequence.size - 2)).each do |index|
    polymer = [sequence[index], sequence[index + 1]].join
    before = sequence[index]
    middle = template[polymer]

    new_sequence << before
    new_sequence << middle

    frequencies[before] ||= 0
    frequencies[before] += 1
    frequencies[middle] ||= 0
    frequencies[middle] += 1
  end
  new_sequence << sequence[-1]
  frequencies[sequence[-1]] += 1
  [new_sequence.join, frequencies]

end

def max_minus_min(frequencies)
  frequencies.values.max - frequencies.values.min
end

def synth_by(times, seq, template)
  freq = nil
  times.times do
    seq, freq = synthesize(seq, template)
  end
  max_minus_min(freq)
end

def puzzle1(input)
  seq, temp = input
  synth_by(10, seq, temp)
end

# The better way
def synthesize2(sequence, template, steps)
  pairs = {}
  (0..(sequence.size - 2)).each do |index|
    polymer_pair = [sequence[index], sequence[index + 1]].join
    pairs[polymer_pair] ||= 0
    pairs[polymer_pair] += 1
  end

  frequencies = {}
  sequence.chars.each do |char|
    frequencies[char] ||= 0
    frequencies[char] += 1
  end

  steps.times do
    temp_hash = {}
    frequency = {}

    pairs.each do |pol, value|
      resulting_pol = template[pol]

      frequencies[resulting_pol] ||= 0
      frequencies[resulting_pol] += value

      left, right = pol.split('')
      left_pol = [left, resulting_pol].join
      right_pol = [resulting_pol, right].join

      temp_hash[left_pol] ||= 0
      temp_hash[right_pol] ||= 0
      temp_hash[left_pol] += value
      temp_hash[right_pol] += value
    end
    pairs = temp_hash.dup
  end

  max_minus_min(frequencies)
end

def puzzle2(input)
  seq, temp = input
  synthesize2(seq, temp, 40)
end

puts "Sample Puzzle 1: #{puzzle1(sample)}"
puts "Puzzle 1: #{puzzle1(input)}"
puts "Sample Puzzle 2: #{puzzle2(sample)}"
puts "Puzzle 2: #{puzzle2(input)}"

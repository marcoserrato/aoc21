require_relative '../utility/utils.rb'

day = 10
process_method = :process_input

input = send(process_method, file_name(day))
sample = send(process_method, 'sample.txt')

CLOSE = {
  ")" => "(",
  "]" => "[",
  "}" => "{",
  ">" => "<"
}
OPEN = CLOSE.invert

PUZZLE1_SCORES = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137
}

PUZZLE2_SCORES = {
  ")" => 1,
  "]" => 2,
  "}" => 3,
  ">" => 4
}

def process_line(line, return_stack: false)
  stack = Array.new
  line.split('').each do |symbol|
    case symbol
    when "(", "[", "{", "<"
      stack.push(symbol)
    when ")", "]", "}", ">"
      return symbol if stack.last != CLOSE[symbol]

      stack.pop
    end
  end
  return_stack ? stack : nil
end

def puzzle1(input)
  bad_lines = input.map { |line| process_line(line) }.compact
  bad_lines.reduce(0) do |sum, symbol|
    sum + PUZZLE1_SCORES[symbol]
  end
end

def puzzle2(input)
  incomplete = []
  input.each do |line|
    line_stack = process_line(line, return_stack: true)

    # Bad lines return the problem symbol, incomplete return their stack
    next if line_stack.is_a?(String)

    incomplete << line_stack.reverse.map { |symbol| OPEN[symbol] }
  end
  incomplete.map do |line|
    line.reduce(0) { |sum, symbol| sum * 5 + PUZZLE2_SCORES[symbol] }
  end.sort[incomplete.size / 2]
end

puts "Sample Puzzle 1: #{puzzle1(sample)}"
puts "Puzzle 1: #{puzzle1(input)}"
puts "Sample Puzzle 2: #{puzzle2(sample)}"
puts "Puzzle 2: #{puzzle2(input)}"

require_relative '../utility/utils.rb'

input = process_bingo_input(file_name(4))
input2= process_bingo_input(file_name(4))

def mark_value_in_board(board, number)
  board.map! do |row|
    row.map! do |num|
      num == number ? -1 : num
    end
  end
end

def bingo?(board)
  board.each do |row|
    return true if row.reduce(&:+) == -5
  end
  (0..4).each do |col|
    return true if board.map { |row| row[col] }.reduce(&:+) == -5
  end
  false
end

def sum_board(board)
  board.flatten.select { |r| r > 0 }.reduce(&:+)
end

def bingo(sequence, boards)
  sequence.each do |number|
    boards.each do |board|
      mark_value_in_board(board, number)
      return [board, number] if bingo?(board)
    end
  end
end

def nbingo(sequence, boards)
  indexes = []
  winning_boards = []
  sequence.each do |number|
    boards.each_with_index do |board, index|
      mark_value_in_board(board, number) unless indexes.include?(index)
      if bingo?(board) && !indexes.include?(index)
        winning_boards << [board, number]
        indexes << index
      end
    end
  end
  winning_boards.last
end

def puzzle1(input)
  winning, seq = bingo(input[0], input[1])
  sum_board(winning) * seq
end

def puzzle2(input)
  board, seq = nbingo(input[0], input[1])
  sum_board(board) * seq
end

puts "Puzzle 1: #{puzzle1(input)}"
puts "Puzzle 2: #{puzzle2(input2)}"

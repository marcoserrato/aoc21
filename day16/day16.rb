require_relative '../utility/utils.rb'
require 'pry'

day = 16

class TransmissionReader
  def initialize(input)
    File.open(input, 'r') do |file|
      @raw_input = file.readline.gsub(/\n/, '').split('')
    end
    @buffer = []
    @total_read = 0
  end

  def total_read
    @total_read
  end

  def flush_buffer
    @buffer = []
  end

  def done?
    @raw_input.empty? && @buffer.empty?
  end

  def decode_hex
    value = @raw_input.shift
    @buffer = ("%04b" % value.to_i(16)).split('')
  end

  def next_bit
    if @buffer.empty?
      decode_hex
    end
    @total_read += 1
    @buffer.shift
  end

  def next_n_bits(n)
    n.times.map do
      unless done?
        next_bit
      end
    end.compact
  end
end

input = file_name(day)
sample = 'sample.txt'

def parse_packet(reader)
  version = reader.next_n_bits(3).join.to_i(2)
  type_id = reader.next_n_bits(3).join.to_i(2)
  binding.pry
  case type_id
  when 4
    bits = reader.next_n_bits(4)
    c = bits.shift
    res = bits
    until c == 0
      bits = reader.next_n_bits(4)
      c = bits.shift
      res + bits
    end
    res.join.to_i(2)
    reader.flush_buffer
  else
    length_type_id = reader.next_n_bits(1).join.to_i
    length = 0
    if length_type_id == 1
      length = reader.next_n_bits(15).join.to_i(2)
    else
      length = reader.next_n_bits(11).join.to_i(2)
    end
    parse_sub_packet(reader, length)
  end
end

def parse_sub_packet(reader, total)
  nt = total
  while nt > 0
    binding.pry
    st = reader.total_read
    parse_packet(reader)
    et = reader.total_read
    binding.pry
    nt = total - (et - st)
  end
end

def puzzle1(input)
  reader = TransmissionReader.new(input)

  until reader.done?
    parse_packet(reader)
  end
end

def puzzle2(input)
end

puts "Sample Puzzle 1: #{puzzle1(sample)}"
#puts "Puzzle 1: #{puzzle1(input)}"
puts "Sample Puzzle 2: #{puzzle2(sample)}"
#puts "Puzzle 2: #{puzzle2(input)}"

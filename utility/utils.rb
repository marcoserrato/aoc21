def file_name(day)
  "day" + day.to_s.rjust(2, "0") + "_input.txt"
end

def process_input(file)
  File.open(file, 'r') do |file|
    file.readlines.map { |line| line.gsub(/\n/, '') }
  end
end

def process_multi_value_input(file)
  File.open(file, 'r') do |file|
    file.readlines.map { |line| line.gsub(/\n/, '').split }
  end
end

def process_csv_input(file)
  File.open(file, 'r') do |file|
    file.readline.gsub(/\n/, '').split(',').map(&:to_i)
  end
end

def process_input_as_ints(file)
  process_input(file).map(&:to_i)
end

# Klass is a Stuct which responds to #members
def process_input_to_klass(file, klass)
  inputs = File.open(file, 'r') do |file|
    file.readlines.map { |line| line.gsub(/\n/, '') }
  end
  inputs.map do |input|
    input = input.is_a?(Array) ? input : [input]
    klass.new(klass.members.zip(input).to_h.transform_keys { |k| k.to_sym })
  end
end

def process_bingo_input(file)
  File.open(file, 'r') do |file|
    lines = file.readlines
    sequence = lines.first.split(",").map(&:to_i)
    boards = []
    temp = []

    lines[2..-1].map do |line|
      if line == "\n"
        boards << temp
        temp = []
      else
        temp << line.gsub(/\n/, '').split.map(&:to_i)
      end
    end
    [sequence, boards]
  end
end

class Segment < Struct.new(:origin_x, :origin_y, :dest_x, :dest_y, keyword_init: true)
  def direction
    if origin_x - dest_x == 0
      :y
    elsif origin_y - dest_y == 0
      :x
    else
      :diagonal
    end
  end
end

def process_input_segments_to_klass(file, klass)
  inputs = File.open(file, 'r') do |file|
    file.readlines.map { |line| line.gsub(/\n/, '').split(',').map { |r| r.split(' -> ') }.flatten.map(&:to_i) }
  end
  inputs.map do |input|
    input = input.is_a?(Array) ? input : [input]
    klass.new(klass.members.zip(input).to_h.transform_keys { |k| k.to_sym })
  end
end

def process_signals(file)
  File.open(file, 'r') do |file|
    file.readlines.map do |line|
      line = line.gsub(/\n/, '')
      input, output = line.split('|')
      [input.strip, output.strip]
    end
  end
end

def process_grid(file)
  File.open(file, 'r') do |file|
    file.readlines.map do |line|
      line.gsub(/\n/, '').split('').map(&:to_i)
    end
  end
end

class PathInput < Struct.new(:from, :to, keyword_init: true)
end

def process_paths(file)
  File.open(file, 'r') do |file|
    file.readlines.map do |line|
      from, to = line.gsub(/\n/, '').split('-')
      PathInput.new(from: from, to: to)
    end
  end
end


class Point < Struct.new(:row, :col, keyword_init: true)
end

class Fold < Struct.new(:direction, :value, keyword_init: true)
end

def process_coordinates(file)
  input = [[],[]]
  File.open(file, 'r') do |file|
    file.readlines.each do |line|
      line = line.gsub(/\n/, '')
      next if line.empty?

      if line.match?(/fold along/)
        direction, value = line.split.last.split("=")
        direction = direction == "y" ? :row : :col
        input[1] << Fold.new(direction: direction, value: value.to_i)
      else
        col, row = line.split(',')
        input[0] << Point.new(row: row.to_i, col: col.to_i)
      end
    end
  end
  input
end

def grid_to_graph(file)
  File.open(file, 'r') do |file|
    file.readlines.each_with_index do |line, row|
      line = line.gsub(/\n/, '')
      points = lines.split('')
      points.each_with_index do |weight, col|
      end
    end
  end
end

def process_polymer_template(file)
  sequence = nil
  template = {}
  File.open(file, 'r') do |file|
    file.readlines.each do |line|
      line = line.gsub(/\n/, '')
      next if line.empty?

      from, to = line.split(' -> ')

      if to.nil?
        sequence = line
        next
      else
        template[from] = to
      end
    end
  end
  [sequence, template]
end

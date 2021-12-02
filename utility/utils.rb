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

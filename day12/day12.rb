require_relative '../utility/utils.rb'

day = 12
process_method = :process_paths

input = send(process_method, file_name(day))
sample = send(process_method, 'sample.txt')

class Caves
  def initialize(input)
    @full_paths = []
    @nodes = {
      "start" => Node.new("start"),
      "end" => Node.new("end")
    }
    input.each do |link|
      nodes[link.from] ||= Node.new(link.from)
      nodes[link.to] ||= Node.new(link.to)
      nodes[link.from].add_link(link.to)
      nodes[link.to].add_link(link.from)
    end
  end

  def full_paths
    @full_paths
  end

  def nodes
    @nodes
  end

  def find_all_paths(part)
    method = part == :part1 ? :find_path : :find_path_2

    nodes["start"].connections.each { |node| send(method, node) }
  end

  def find_path(node_name, visited = ["start"])
    node = nodes[node_name]
    if node.end?
      visited << "end"
      full_paths << visited
      return
    end

    # Am I back in a small cave I've already visited?
    if node.small_cave? && visited.include?(node.name)
      # Invalid path, return
      return
    end

    visited << node.name
    node.connections.map do |next_node|
      find_path(next_node, visited.dup)
    end
  end

  def find_path_2(node_name, visited = ["start"], double_visit: false)
    node = nodes[node_name]

    if node.start?
      # Can't visit start twice
      return
    end
    if node.end?
      visited << "end"
      full_paths << visited
      return
    end

    # Am I back in a small cave I've already visited?
    if node.small_cave? && visited.include?(node.name)
      if double_visit
        return
      else
        double_visit = true
      end
    end

    visited << node.name
    node.connections.map do |next_node|
      find_path_2(next_node, visited.dup, double_visit: double_visit)
    end
  end

  def double_visit(visit)
    return false if visit.nil?

    visit[1] > 2
  end

  def pprint
    nodes.each do |name, node|
      puts "Segment Name: #{name}"
      puts "#{node.pprint}"
      puts "\n"
    end
  end
end

class Node
  def initialize(name)
    @name = name
    @connections = []
  end

  def add_link(target)
    connections << target
  end

  def small_cave?
    name.match?(/[a-z]+/)
  end

  def end?
    name == "end"
  end

  def start?
    name == "start"
  end

  def big_cave?
    !small_cave?
  end

  def name
    @name
  end

  def connections
    @connections
  end

  def pprint
    puts "#{connections}"
  end
end

def puzzle1(input)
  caves = Caves.new(input)
  caves.find_all_paths(:part1)
  caves.full_paths.count
end

def puzzle2(input)
  caves = Caves.new(input)
  caves.find_all_paths(:part2)
  caves.full_paths.count
end

puts "Sample Puzzle 1: #{puzzle1(sample)}"
puts "Puzzle 1: #{puzzle1(input)}"
puts "Sample Puzzle 2: #{puzzle2(sample)}"
puts "Puzzle 2: #{puzzle2(input)}"

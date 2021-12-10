require_relative '../utility/utils.rb'

input = process_csv_input(file_name(6))

# My solution
class FishEnvironment
  class Counter
    def initialize(pool=0)
      @pool = pool
    end

    def add(n=1)
      @pool += n
    end

    def pool
      @pool
    end
  end

  def counters
    # There are 9 spots in day counter since 0 is a valid state
    @counters ||= 9.times.map { |i| Counter.new }
  end

  def initialize(starting_fishes)
    # Tally up the fish by there start time
    starting_fishes.each { |fish| counters[fish].add }
  end

  def simulate(days)
    days.times do |day|
      # Fish reproduce when counter *is* at 0, and not when they *arrive* at 0.
      # When this happens they produce a fish with a timer of 8.
      # Then their timer goes back to 6
      # On day 0, fish with counter 0 reproduce
      # On day 1, fish with counter 1 reproduce (Since they would technically be at 0)
      curr = counters.shift
      counters[6].add(curr.pool)
      counters.push(Counter.new(curr.pool))
    end
    counters.map(&:pool).reduce(&:+)
  end
end

# An interesting solution I found... 
class LaternFish
  def buckets
    @buckets
  end

  def initialize(input)
    @buckets = Array.new(9,0)
    input.each { |fish| buckets[fish] += 1 }
  end

  def sim(iteration)
    buckets[(iteration + 7) % 9] += buckets[iteration % 9]
  end
end
# ............

def puzzle1(input)
  FishEnvironment.new(input).simulate(80)
end

def puzzle2(input)
  FishEnvironment.new(input).simulate(256)
end

puts "Puzzle 1 Sample: #{puzzle1(process_csv_input('sample.txt'))}"
puts "Puzzle 1: #{puzzle1(input)}"
puts "Puzzle 2 Sample: #{puzzle2(process_csv_input('sample.txt'))}"
puts "Puzzle 2: #{puzzle2(input)}"

require './helper.rb'
#input = File.open("input/day20.txt").readlines.map(&:strip).reject(&:empty?)

Player = Struct.new(:position, :score) do
  def move(spaces)
    spaces.times do
      self.position += 1
      self.position = 1 if self.position == 11
    end
    self.score += self.position
  end
end

# Example
#p1 = Player.new(4, 0)
#p2 = Player.new(8, 0)


# Real
p1 = Player.new(10, 0)
p2 = Player.new(1, 0)

=begin
roll = 0
times_rolled = 0
die = Enumerator.new do |e|
  while true do
    times_rolled += 1
    roll += 1
    roll = 1 if roll > 100
    e.yield roll
  end
end

while true do
  s = die.take(3).sum
  p1.move(s)
  break if p1.score >= 1000
  s = die.take(3).sum
  p2.move(s)
  break if p2.score >= 1000
end


puts times_rolled * [p1.score, p2.score].min
=end
# Part 2
possible_rolls = []
(1..3).each do |a|
  (1..3).each do |b|
    (1..3).each do |c|
      possible_rolls << [a, b, c]
    end
  end
end

DISTRIBUTION = possible_rolls.map(&:sum).group_by(&:itself).transform_values(&:length)

class State
  attr_accessor :p1, :p2, :winner

  def initialize(p1, p2)
    @p1 = p1
    @p2 = p2
  end

  def ==(other)
    self.p1 == other.p1 && self.p2 == other.p2
  end
end

remaining = {
  State.new(p1, p2) => 1
}

turn = :p1
wins = Hash.new(0)

while remaining.any?
  new_universes = Hash.new(0)
  puts "#{remaining.count} remaining"
  remaining.each do |state, num_universes|
    DISTRIBUTION.each do |roll, roll_universes|
      new_state = State.new(state.p1.dup, state.p2.dup)
      new_state.send(turn).move(roll)
      if new_state.send(turn).score >= 21
        wins[turn] += (num_universes * roll_universes)
      else
        new_num_universes = num_universes * roll_universes

        new_universes[new_state] += num_universes * roll_universes
      end
    end
  end

  remaining = new_universes
  turn = turn == :p1 ? :p2 : :p1
end

puts wins.inspect
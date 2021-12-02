require './helper.rb'
input = File.open("input/day2.txt").readlines.map(&:strip).reject(&:empty?).map { |s| s.split(" ") }

# Part 1
class Submarine
    def initialize
        @x, @d = 0, 0
    end

    def follow_commands(commands)
        commands.each { |(command, value)| send(command, value.to_i) }
    end

    def planned_course
        @x * @d
    end

    def forward(v)
        @x += v
    end

    def down(v)
        @d += v
    end

    def up(v)
        @d -= v
    end
end

sub = Submarine.new
sub.follow_commands(input)

Helper.assert_equal 1762050, sub.planned_course

# Part 2
class BetterSubmarine < Submarine
    def initialize
        super
        @aim = 0
    end

    def forward(v)
        super
        @d += @aim * v
    end

    def down(v)
        @aim += v
    end

    def up(v)
        @aim -= v
    end
end

sub = BetterSubmarine.new
sub.follow_commands(input)

Helper.assert_equal 1855892637, sub.planned_course
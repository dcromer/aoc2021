require './helper.rb'
input = File.open("input/day2.txt").readlines.map(&:strip).reject(&:empty?).map { |s| s.split(" ") }

class Submarine
    def initialize
        @x, @d = 0, 0
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

    def planned_course
        @x * @d
    end
end

sub = Submarine.new
input.each { |(command, value)| sub.send(command, value.to_i) }

Helper.assert_equal 1762050, sub.planned_course

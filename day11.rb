require './helper.rb'

input = File.open("input/day11_test.txt").readlines.map(&:strip).reject(&:empty?)

class Grid
    attr_accessor :rows
    
    def initialize(rows)
        @rows = rows
    end

    def to_s
        rows.map(&:join).join("\n")
    end
end

grid =  Grid.new(input.map { |row| row.split.map(&:to_i) })

puts grid.to_s

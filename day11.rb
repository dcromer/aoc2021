require './helper.rb'

input = File.open("input/day11_test.txt").readlines.map(&:strip).reject(&:empty?)

class Octopus
    attr_accessor :energy_level
    class << self
        attr_accessor :flashes
    end

    self.flashes = 0
    def initialize(energy_level)
        @flashed = false
        @energy_level = energy_level
    end

    def energize
        @energy_level += 1
    end

    def should_flash?
        @energy_level > 9 && !@flashed
    end

    def flash!
        @flashed = true
        self.class.flashes += 1
    end

    def flashed?
        @flashed
    end

    def reset
        if flashed?
            @energy_level = 0
            @flashed = false
        end
    end
end

class Grid
    attr_accessor :rows

    def initialize(rows)
        @rows = rows
    end

    def step
        @step_flashes = 0
        Grid.all(@rows).each(&:energize)

        for i in @rows.each_index
            for j in @rows[i].each_index
                octopus = @rows[i][j]
                flash(i, j) if octopus.should_flash?
            end
        end

        Grid.all(@rows).each(&:reset)

        if @step_flashes == Grid.all(@rows).count
            return true           
        end
        false
    end

    def flash(i, j)
        flasher = @rows[i][j]
        flasher.flash!
        @step_flashes += 1
        for (m, n) in Grid.index_neighbors_8(@rows, i, j)
            neighbor = @rows[m][n]
            neighbor.energize
            flash(m, n) if neighbor.should_flash?
        end
    end

    def to_s
        rows.map { |r| r.map(&:energy_level).join }.join("\n")
    end
end

grid =  Grid.new(input.map { |row| row.chars.map { |v| Octopus.new(v.to_i) } })

steps = 1
until grid.step
    steps += 1
end

puts steps

require './helper.rb'

input = File.open("input/day11_test.txt").readlines.map(&:strip).reject(&:empty?)

def index_neighbors(g, i, j)
    max_i = g.length - 1
    max_j = g[i].length - 1
    [
        ([i, j - 1] if j > 0),
        ([i - 1, j - 1] if j > 0 && i > 0),
        ([i + 1, j - 1] if i < max_i && j > 0),
        ([i, j + 1] if j < max_j),
        ([i - 1, j + 1] if j < max_j && i > 0),
        ([i - 1, j] if i > 0),
        ([i + 1, j] if i < max_i),
        ([i + 1, j + 1] if i < max_i && j < max_j)
    ].compact
end

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
    attr_accessor :rows, :all

    def initialize(rows)
        @rows = rows
        @all = rows.flatten
    end

    def step
        @step_flashes = 0
        all.each(&:energize)

        for i in @rows.each_index
            for j in @rows[i].each_index
                octopus = @rows[i][j]
                flash(i, j) if octopus.should_flash?
            end
        end

        all.each(&:reset)

        if @step_flashes == all.count
            return true           
        end
        false
    end

    def flash(i, j)
        flasher = @rows[i][j]
        flasher.flash!
        @step_flashes += 1
        for (m, n) in index_neighbors(@rows, i, j)
            neighbor = @rows[m][n]
            neighbor.energize
            flash(m, n) if neighbor.should_flash?
        end
    end

    def all
        return enum_for :all unless block_given?

        for i in @rows.each_index
            for j in @rows[i].each_index
                yield @rows[i][j]
            end
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

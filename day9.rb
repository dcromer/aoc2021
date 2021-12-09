require './helper.rb'

input = File.open("input/day9.txt").readlines.map(&:strip).reject(&:empty?)

grid = input.map do |row|
    row.split("").map(&:to_i)
end

def get_low_points(g)
    Enumerator.new do |e|
        for i in g.each_index
            for j in g[i].each_index
                height = g[i][j]
                neighbors = [
                    (g[i][j - 1] if j > 0),
                    (g[i][j + 1] if j < g[i].length - 1),
                    (g[i - 1]&.at(j) if i > 0),
                    (g[i + 1]&.at(j) if i < g.length - 1)
                ].compact
                if neighbors.min > height
                    e.yield [i, j]
                end
            end
        end
    end
end

low_heights = get_low_points(grid).each.map { |(i, j)| grid[i][j] }
Helper.assert_equal 516, low_heights
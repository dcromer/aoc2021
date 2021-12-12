require './helper.rb'

input = File.open("input/day9.txt").readlines.map(&:strip).reject(&:empty?)

grid = input.map do |row|
    row.split("").map(&:to_i)
end

def get_neighbors(g, i, j)
    Grid.index_neighbors_4(g, i, j).map { |(l, m)| g[l][m] }
end

def get_low_points(g)
    Enumerator.new do |e|
        for i in g.each_index
            for j in g[i].each_index
                height = g[i][j]
                if get_neighbors(g, i, j).min > height
                    e.yield [i, j]
                end
            end
        end
    end
end

low_heights = get_low_points(grid).each.map { |(i, j)| grid[i][j] }
Helper.assert_equal 516, low_heights.sum + low_heights.count

# Part 2
basin_map = grid.each.map do |row|
    row.each.map { |_| -1 }
end

get_low_points(grid).each_with_index do |(i, j), color|
    queue = [[i,j]]
    basin_map[i][j] = color

    while node = queue.shift do
        i, j = *node
        height = grid[i][j]
        for (k, l) in Grid.index_neighbors_4(grid, i, j)
            if (basin_map[k][l].nil? || basin_map[k][l] != color) && grid[k][l] != 9 && grid[k][l] >= height
                basin_map[k][l] = color
                queue.append [k, l]
            end
        end
    end
end

a, b, c = *basin_map.flatten.group_by(&:itself).except(-1).transform_values(&:length).values.sort.reverse.take(3)
Helper.assert_equal 1023660, a * b * c
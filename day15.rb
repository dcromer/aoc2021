require './helper.rb'
input = File.open("input/day15.txt").readlines.map(&:strip).reject(&:empty?)

grid =  input.map { |row| row.chars.map(&:to_i) }

part_2_grid = (5 * grid.length).times.map do |i|
  (5 * grid.length).times.map do |j|
    original = grid[i % grid.length][j % grid.length]
    new = original + i / grid.length + j / grid.length
    if new > 9
      new -= 9
    end
    new
  end
end

def build_path_weights(grid)
  grid.map do |row|
    row.map do |_|
      Float::INFINITY
    end
  end
end

def build_previous(grid)
  grid.map do |row|
    row.map { |_| nil }
  end
end

def dijkstra(grid)
  path_weights = build_path_weights(grid)

  previous = build_previous(grid)

  remaining = Grid.all_with_index(grid).sort_by(&:first).map { |v, i| i }
  index = remaining.shift
  path_weights[0][0] = 0
  while index
    i, j = *index

    for (l, m) in Grid.index_neighbors_4(grid, i, j)
      old_weight = path_weights[l][m]
      new_weight = path_weights[i][j] + grid[l][m]
      if new_weight < old_weight
        path_weights[l][m] = new_weight
        previous[l][m] = [i,j]
        remaining << [l, m]
      end
    end

    index = remaining.shift
  end

  previous
end

def score(grid)
  previous = dijkstra(grid)
  total_risk = 0
  i = grid.length - 1
  j = grid.length - 1
  node = previous[i][j]
  until node.nil?
    total_risk += grid[i][j]
    i, j = *node
    node = previous[i][j]
  end
  total_risk
end

Helper.assert_equal 717, score(grid)
Helper.assert_equal 2993, score(part_2_grid)

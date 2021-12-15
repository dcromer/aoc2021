require './helper.rb'

input = File.open("input/day15.txt").readlines.map(&:strip).reject(&:empty?)

grid =  input.map { |row| row.chars.map(&:to_i) }

class Node
    attr_accessor :weight, :neighbors
   
    def initialize(weight, neighbors)
        @weight = weight 
        @neighbors = neighbors
    end
end

path_weights = grid.map do |row|
  row.map do |_|
    Float::INFINITY
  end
end

previous = grid.map do |row|
  row.map { |_| nil }
end

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
    end
  end

  remaining = remaining.sort_by { |(l,m)| path_weights[l][m] }
  index = remaining.shift
end

total_risk = 0
i = grid.length - 1
j = grid.length - 1
node = previous[i][j]
until node.nil?
  total_risk += grid[i][j]
  i, j = *node
  node = previous[i][j]
end

puts total_risk
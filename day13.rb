require './helper.rb'

input = File.open("input/day13.txt").readlines.map(&:strip).reject(&:empty?)

Point = Struct.new(:x, :y)
Fold = Struct.new(:axis, :value)

points = []
folds = []

input.each do |line|
    if line.start_with?("fold along")
        _, _, keep = line.split(" ")
        axis, value = *keep.split("=")
        folds << Fold.new(axis, value.to_i)
    else
        points << Point.new(*line.split(",").map(&:to_i))
    end
end

def fold(points, fold)
    new_points = points.map do |point|
        if fold.axis == "x"
          if point.send(fold.axis) < fold.value
            point
          else
            Point.new(point.x - (point.x - fold.value) * 2, point.y)
          end
        else
            if point.send(fold.axis) < fold.value
              point
            else
              Point.new(point.x, point.y - (point.y - fold.value) * 2)
            end
        end
    end

    new_points.group_by(&:itself).transform_values(&:length).except { |k, v| v > 1 }.keys
end

#Part 1
part_1_points = fold(points, folds.first)
Helper.assert_equal 807, part_1_points.count

folds.each do |fold|
  points = fold(points, fold)
end

def print_points(points)
  x = points.max_by(&:x).x + 1
  y = points.max_by(&:y).y + 1
  grid = []
  y.times do
    grid << (["."] * x)
  end
  
  points.each do |p|
    grid[p.y][p.x] = "#"
  end
  grid.map(&:join).join("\n")
end

# Part 2
puts print_points(points)
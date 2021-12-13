require './helper.rb'

input = File.open("input/day13.txt").readlines.map(&:strip).reject(&:empty?)

Point = Struct.new(:x, :y)
Fold = Struct.new(:axis, :value)

points = []
folds = []

input.each do |line|
  if line.delete_prefix!("fold along ")
    axis, value = *line.split("=")
    folds << Fold.new(axis, value.to_i)
  else
    points << Point.new(*line.split(",").map(&:to_i))
  end
end

def fold(points, fold)
  points.map do |point|
    if point.send(fold.axis) < fold.value
      point
    else
      p = point.dup
      folded_value = point.send(fold.axis) - (point.send(fold.axis) - fold.value) * 2
      p.send("#{fold.axis}=", folded_value)
      p
    end
  end.uniq
end

#Part 1
Helper.assert_equal 807, fold(points, folds.first).count

# Part 2
folds.each do |fold|
  points = fold(points, fold)
end

def print_points(points)
  x = points.max_by(&:x).x + 1
  y = points.max_by(&:y).y + 1
  grid = (["."] * x * y).each_slice(x).to_a 
  points.each { |p| grid[p.y][p.x] = "#" }
  grid.map(&:join).join("\n")
end

# "LGHEGUEJ"
puts print_points(points)
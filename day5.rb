require './helper.rb'

input = File.open("input/day5.txt").readlines.map(&:strip).reject(&:empty?)


size = 1000
grid = (0..size).map { |_| (0..size).map { |_| 0 } }

Point = Struct.new(:x,:y)
input.each do |line|
    p1, _, p2 = line.split(" ")
    p1 = Point.new(*p1.split(",").map(&:to_i))
    p2 = Point.new(*p2.split(",").map(&:to_i))
    if p1.x == p2.x # vertical
        Range.new(*[p1.y, p2.y].sort).each do |y|
            grid[y][p1.x] += 1
        end
    elsif p1.y == p2.y # horizontal
        Range.new(*[p1.x, p2.x].sort).each do |x|
            grid[p1.y][x] += 1
        end
    end
end

Helper.assert_equal 6225, grid.map { |row| row.select { |i| i >= 2}.count }.sum

# part 2
grid = (0..size).map { |_| (0..size).map { |_| 0 } }

input.each do |line|
    p1, _, p2 = line.split(" ")
    p1 = Point.new(*p1.split(",").map(&:to_i))
    p2 = Point.new(*p2.split(",").map(&:to_i))

    if p1.x == p2.x # vertical
        Range.new(*[p1.y, p2.y].sort).each do |y|
            grid[y][p1.x] += 1
        end    
    elsif p1.y == p2.y # horizontal
        Range.new(*[p1.x, p2.x].sort).each do |x|
            grid[p1.y][x] += 1
        end
    else
        first, second = [p1,p2].sort_by(&:x)
        rate = (second.y - first.y) / (second.x - first.x)
        (second.x - first.x + 1).times do |i|
            grid[first.y + i * rate][first.x + i] += 1
        end
    end
end

Helper.assert_equal 22116, grid.map { |row| row.select { |i| i >= 2}.count }.sum
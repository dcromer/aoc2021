require './helper.rb'
input = File.open("input/day20.txt").readlines.map(&:strip).reject(&:empty?)

algorithm = input.shift.chars

image = input.map(&:chars)

ORDERED_INDEXES = [
    [-1, -1],
    [0, -1],
    [1, -1],
    [-1, 0],
    [0, 0],
    [1, 0],
    [-1, 1],
    [0, 1],
    [1, 1]
]
def get_pixels(g, i, j)
    Grid.map_filter_neighbors(i, j, g.length, ORDERED_INDEXES).map do |(i, j)|
        g[j][i]
    end.join
end

def pad(g, n, char=".")
    new_length = g.length + 2 * n
    blank_row = [char] * new_length
    blank_cols = [char] * n

    new_g = []
    n.times do
        new_g << blank_row
    end

    g.each do |row|
        new_g << (blank_cols + row + blank_cols)
    end

    n.times do
        new_g << blank_row
    end
    new_g

end

def map_pixel(g, a, i, j)
    index = get_pixels(g, i, j).gsub(/./, "." => "0", "#" => "1").to_i(2)
    a[index]
end

def enhance(image, algorithm)
    #image = pad(image, 2)
    new_image = image.length.times.map do |_|
        ["."] * image.length
    end
    Grid.all_with_index(image).each do |_, (i, j)|
        new_image[i][j] = map_pixel(image, algorithm, j, i)
    end
    new_image
end

=begin
2.times do
    image = enhance(image, algorithm)
end
=end

50.times do |i|
    puts i
    char = i % 2 == 0 ? "." : "#"
    image = pad(image, 2, char)
    image = enhance(image, algorithm)
end

puts Grid.all(image).select { |p| p == "#" }.count


require './helper.rb'
input = File.open("input/day20.txt").readlines.map(&:strip).reject(&:empty?)

kernel = input.shift.chars
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

def pad(g, n, pad_char)
    new_length = g.length + 2 * n
    blank_row = [pad_char] * new_length
    blank_cols = [pad_char] * n

    new_g = []
    n.times do { new_g << blank_row }

    g.each do |row|
        new_g << (blank_cols + row + blank_cols)
    end

    n.times do { new_g << blank_row }

    new_g
end

def map_pixel(g, a, i, j)
    index = get_pixels(g, i, j).gsub(/./, "." => "0", "#" => "1").to_i(2)
    a[index]
end

def convolve(image, kernel)
    new_image = image.length.times.map do |_|
        ["."] * image.length
    end
    Grid.all_with_index(image).each do |_, (i, j)|
        new_image[i][j] = map_pixel(image, kernel, j, i)
    end
    new_image
end

# Part 1
# This is sort of naive; instead of intelligently determining the padding for our convolution, we
# cheat and realize that the kernel always maps 0's to 1's and vice versa.
2.times do |i|
    char = i % 2 == 0 ? "." : "#"
    image = pad(image, 2, char)
    image = convolve(image, kernel)
end

Helper.assert_equal 5225, Grid.all(image).select { |p| p == "#" }.count

48.times do |i|
    puts "Step: #{i}"
    char = i % 2 == 0 ? "." : "#"
    image = pad(image, 2, char)
    image = convolve(image, kernel)
end

Helper.assert_equal 18131, Grid.all(image).select { |p| p == "#" }.count

require './helper.rb'

input = File.open("input/day1.txt").readlines.map(&:strip).reject(&:empty?).map(&:to_i)

def num_increasing(array)
    array.each_cons(2).select { |(a, b)| a < b }.count
end

Helper.assert_equal 1466, num_increasing(input)

part_2_input = input.each_cons(3).map(&:sum)

Helper.assert_equal 1491, num_increasing(part_2_input)
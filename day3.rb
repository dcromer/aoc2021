require './helper.rb'

input = File.open("input/day3.txt").readlines.map(&:strip).reject(&:empty?)
gamma = input.map { |binary_string| binary_string.split("").map(&:to_i) }
    .transpose
    .map { |bits| (bits.sum / input.length.to_f).round(0) }
    .join
epsilon = gamma.chars.map { |c| c == "0" ? "1" : "0"}.join

power_consumption = gamma.to_i(2) * epsilon.to_i(2)
Helper.assert_equal 1082324, power_consumption

# part 2
def filter_strings(strings)
    bit = 0
    while strings.length > 1 do
        average_bit = (strings.map { |c| c[bit].to_i }.sum / strings.length.to_f).round(0)
        strings = strings.select { |s| yield(s[bit].to_i, average_bit) }
        bit += 1
    end

    strings.first
end

oxygen = filter_strings(input) { |bit, average_bit| bit == average_bit }
co2 = filter_strings(input) {|bit, average_bit| bit != average_bit }

life_support_rating = oxygen.to_i(2) * co2.to_i(2)

Helper.assert_equal 1353024, life_support_rating

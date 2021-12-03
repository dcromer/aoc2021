input = File.open("input/day3.txt").readlines.map(&:strip).reject(&:empty?)
gamma_string = input.map { |binary_string| binary_string.split("").map(&:to_i) }
    .transpose
    .map { |bits| (bits.sum / input.length.to_f).round(0) }
    .join
epsilon_string = gamma_string.chars.map { |c| c == "0" ? "1" : "0"}.join

power_consumption = gamma_string.to_i(2) * epsilon_string.to_i(2)
assert_equal 1082324, power_consumption
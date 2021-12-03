require './helper.rb'

input = File.open("input/day3.txt").readlines.map(&:strip).reject(&:empty?)
bit_distribution = input.map { |binary_string| binary_string.split("").map(&:to_i) }
    .transpose
    .map { |bits| (bits.sum / input.length.to_f) }
gamma_string = bit_distribution.map { |distribution| distribution.round(0) }.join
epsilon_string = gamma_string.chars.map { |c| c == "0" ? "1" : "0"}.join

power_consumption = gamma_string.to_i(2) * epsilon_string.to_i(2)
Helper.assert_equal 1082324, power_consumption

# part 2
def filter_strings(strings)
    candidates = strings
    bit = 0
    while candidates.length > 1 do
        average_bit = candidates.map { |c| c[bit].to_i }.sum / candidates.length.to_f
        
        candidates = candidates.select { |candidate| yield(candidate[bit], average_bit) }
        bit += 1
    end

    return candidates.first
end

oxygen_generator_rating_string = filter_strings(input) do |bit, average_bit|
    average_bit >= 0.5 && bit == "1" || average_bit < 0.5 && bit == "0"
end

co2_scrubber_rating_string = filter_strings(input) do |bit, average_bit|
    average_bit >= 0.5 && bit == "0" || average_bit < 0.5 && bit == "1"
end

life_support_rating = oxygen_generator_rating_string.to_i(2) * co2_scrubber_rating_string.to_i(2)

Helper.assert_equal 1353024, life_support_rating

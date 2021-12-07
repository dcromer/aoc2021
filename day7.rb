require './helper.rb'

input = File.open("input/day7.txt").readlines.map(&:strip).reject(&:empty?)

crabs = input[0].split(",").map(&:to_i)
buckets = [0] * (crabs.max + 1)
crabs.each{ |c| buckets[c] += 1 }

def calculate_fuel(b)
    b.length.times.map do |i|
        b.each_with_index.map do |num_crabs, j|
            yield((j - i).abs) * num_crabs
        end.sum
    end.min
end

# Part 1
Helper.assert_equal 355150, calculate_fuel(buckets) { |distance| distance }

# Part 2
Helper.assert_equal 98368490, calculate_fuel(buckets) { |distance| distance * (distance + 1) / 2 }
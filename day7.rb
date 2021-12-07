require './helper.rb'

input = File.open("input/day7.txt").readlines.map(&:strip).reject(&:empty?)

crabs = input[0].split(",").map(&:to_i)

buckets = [0] * (crabs.max + 1)
crabs.each{ |c| buckets[c] += 1 }

fuel = buckets.length.times.map do |i|
   buckets.each_with_index.map do |num_crabs, j|
        (j - i).abs * num_crabs
   end.sum
end

Helper.assert_equal 355150, fuel.min

# Part 2
fuel = buckets.length.times.map do |i|
    buckets.each_with_index.map do |num_crabs, j|
        distance = (j - i).abs
        cumulative_distance =  distance * (distance + 1) / 2
        cumulative_distance * num_crabs
    end.sum
 end

Helper.assert_equal 98368490, fuel.min
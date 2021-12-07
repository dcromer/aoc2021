require './helper.rb'

input = File.open("input/day7.txt").readlines.map(&:strip).reject(&:empty?)

crabs = input[0].split(",").map(&:to_i)

buckets = [0] * (crabs.max + 1)
crabs.each{ |c| buckets[c] += 1 }

fuel = buckets.each_with_index.map do |num_crabs, i|
   buckets.each_with_index.map do |other_crabs, j|
        (j - i).abs * other_crabs
   end.sum
end


Helper.assert_equal 355150, fuel.min
# Part 2
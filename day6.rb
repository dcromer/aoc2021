require './helper.rb'

input = File.open("input/day6.txt").readlines.map(&:strip).reject(&:empty?)

fish = input[0].split(",").map(&:to_i).each_with_object(Hash.new(0)) do |f, result|
    result[f] += 1
end

def simulate_fish(f, days)
    days.times do |i|
        new_fish = Hash.new(0)
        (0..7).each do |i|
            new_fish[i] = f[i + 1]
        end
        new_fish[8] = f[0]
        new_fish[6] += f[0]
        f = new_fish
    end
    f.values.sum
end

Helper.assert_equal 355386, simulate_fish(fish, 80)
# Part 2
Helper.assert_equal 1613415325809, simulate_fish(fish, 256)

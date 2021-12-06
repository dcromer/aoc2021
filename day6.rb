require './helper.rb'

input = File.open("input/day6.txt").readlines.map(&:strip).reject(&:empty?)

fish = [0] * 9
input[0].split(",").map(&:to_i).each { |i| fish[i] += 1 }

def simulate_fish(f, days)
    days.times do |i|
        new_fish = f.shift
        f.append(new_fish)
        f[6] += new_fish
    end
    f
end

Helper.assert_equal 355386, simulate_fish(fish.dup, 80).sum
# Part 2
Helper.assert_equal 1613415325809, simulate_fish(fish.dup, 256).sum

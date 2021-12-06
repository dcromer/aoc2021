require './helper.rb'

input = File.open("input/day6.txt").readlines.map(&:strip).reject(&:empty?)

fish = input[0].split(",").map(&:to_i)

days = 80

days.times do |i|
    new_fish = []
    fish = fish.map do |f|
        if f == 0
            new_fish << 8
            6
        else
            f - 1
        end
    end

    fish.push(*new_fish)
end

puts fish.length

# Part 1: 355386
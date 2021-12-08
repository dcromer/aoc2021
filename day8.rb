require './helper.rb'

input = File.open("input/day8.txt").readlines.map(&:strip).reject(&:empty?)
Entry = Struct.new(:signal_pattern, :output_value)

entries = input.map do |line|
    puts line
    signal_pattern, output_value = line.split("|")
    Entry.new(signal_pattern.split(" "), output_value.split(" "))
end

num_easy_digits = entries.map do |entry|
    entry.output_value.select { |v| [2, 4, 3, 7].include? v.length }.count
end.sum

puts num_easy_digits

# Part 2

entries.map do |entry|
    v1, v4, v7, v8 = entry.output_value.sort_by(&:length)
    puts v1
end
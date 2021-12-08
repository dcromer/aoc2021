require './helper.rb'

input = File.open("input/day8.txt").readlines.map(&:strip).reject(&:empty?)
Entry = Struct.new(:signal_pattern, :output_value)

entries = input.map do |line|
    signal_pattern, output_value = line.split("|")
    Entry.new(signal_pattern.split(" ").map(&:chars), output_value.split(" ").map(&:chars))
end

num_easy_digits = entries.map do |entry|
    entry.output_value.select { |v| [2, 4, 3, 7].include? v.length }.count
end.sum

Helper.assert_equal 539, num_easy_digits

# Part 2
part_2 = entries.map do |entry|
    v1, v7, v4, v8, *_rest = *entry.signal_pattern.sort_by(&:length)
    a = (v7 - v1).first
    counts_by_segment = entry.signal_pattern.flatten.group_by(&:itself).transform_values(&:length)
    b = counts_by_segment.key(6)
    c = counts_by_segment.except(a).key(8)
    d_or_g = counts_by_segment.filter { |k,v| v == 7 }.keys
    d = (v4 & d_or_g).first
    e = counts_by_segment.key(4)
    f = (v1 - [c]).first
    g = (d_or_g - [d]).first
    segment_key = Hash[[a,b,c,d,e,f,g].zip(("a".."g").to_a)]

    digit_key = {
        "abcefg" => 0,
        "cf" => 1,
        "acdeg" => 2,
        "acdfg" => 3,
        "bcdf" => 4,
        "abdfg" => 5,
        "abdefg" => 6,
        "acf" => 7,
        "abcdefg" => 8,
        "abcdfg" => 9
    }
    entry.output_value.map do |segments|
        translated = segments.map do |segment|
            segment_key[segment]
        end.sort.join("")
        digit_key[translated].to_s
    end.join("").to_i
end.sum

Helper.assert_equal 1084606, part_2
require './helper.rb'

input = File.open("input/day14.txt").readlines.map(&:strip).reject(&:empty?)

polymer_template = input.shift

pair_insertion_rules = {}

input.each do |line|
    match, insert_element = line.split("->").map(&:strip)
    pair_insertion_rules[match] = insert_element
end

counts = {}
for i in 0..(polymer_template.length - 2)
    pair = polymer_template[i, 2]
    counts[pair] ||= 0
    counts[pair] += 1
end

def apply_rules(counts, pair_insertion_rules)
    matches = counts.keys & pair_insertion_rules.keys

    new_counts = {}
    matches.each do |pair|
        to_insert = pair_insertion_rules[pair]
        count = counts[pair]
        new_counts[pair[0] + to_insert] ||= 0
        new_counts[pair[0] + to_insert] += count
        new_counts[to_insert + pair[1]] ||= 0
        new_counts[to_insert + pair[1]] += count
    end

    new_counts.merge(counts.except(*matches))
end

40.times do 
    counts = apply_rules(counts, pair_insertion_rules)
end

def score(counts, initial)
    letter_score = Hash.new(0)
    letter_score[initial] = 1
    counts.each do |k, v|
        letter_score[k[1]] += v
    end
    result = letter_score.values.sort
    result[-1] - result[0]
end

puts score(counts, polymer_template[0])

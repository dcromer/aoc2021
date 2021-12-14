require './helper.rb'

input = File.open("input/day14.txt").readlines.map(&:strip).reject(&:empty?)

polymer_template = input.shift
pair_insertion_rules = input.each_with_object({}) do |line, result|
    match, insert_element = line.split("->").map(&:strip)
    result[match] = insert_element
end

def apply_rules(counts, pair_insertion_rules)
    matches = counts.keys & pair_insertion_rules.keys

    new_counts = Hash.new(0)
    matches.each do |pair|
        to_insert = pair_insertion_rules[pair]
        count = counts[pair]
        new_counts[pair[0] + to_insert] += count
        new_counts[to_insert + pair[1]] += count
    end

    new_counts.merge(counts.except(*matches))
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

def solve_puzzle(polymer_template, pair_insertion_rules, iterations)
    counts = polymer_template.chars.each_cons(2).map(&:join).group_by(&:itself).transform_values(&:length)

    iterations.times do
        counts = apply_rules(counts, pair_insertion_rules)
    end

    score(counts, polymer_template[0])
end

# Part 1
Helper.assert_equal 3058, solve_puzzle(polymer_template, pair_insertion_rules, 10)
# Part 2
Helper.assert_equal 3447389044530, solve_puzzle(polymer_template, pair_insertion_rules, 40)

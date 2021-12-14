require './helper.rb'

input = File.open("input/day14.txt").readlines.map(&:strip).reject(&:empty?)

polymer_template = input.shift
polymer_template_2 = polymer_template.dup

pair_insertion_rules = {}

input.each do |line|
    match, insert_element = line.split("->").map(&:strip)
    pair_insertion_rules[match] = insert_element
end

def apply_rules(polymer_template, pair_insertion_rules)
    matches = []
    for i in 0..(polymer_template.length - 2)
        if match = pair_insertion_rules[polymer_template[i, 2]]
            matches << [i + 1, match]
        end
    end
    matches.each_with_index do |(i, match), j|
        polymer_template.insert(i + j, match)
    end
    polymer_template
end

10.times do 
    polymer_template = apply_rules(polymer_template, pair_insertion_rules)
    puts polymer_template
end

def score(polymer_template)
    counts = polymer_template.chars.group_by(&:itself).transform_values(&:length).values.sort
    counts[-1] - counts[0]
end

puts score(polymer_template)
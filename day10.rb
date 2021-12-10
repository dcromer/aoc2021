require './helper.rb'

input = File.open("input/day10.txt").readlines.map(&:strip).reject(&:empty?)

openers = "([{<".chars
closers = ")]}>".chars
invalid = []
input.map do |input|
    stack = []
    input.chars.each_with_index do |char, index|
        if openers.include?(char)
            stack.push(char)
        elsif char == closers[openers.index(stack.last)]
            stack.pop
        else
            invalid << char
            break
        end
    end
end

key = [3,57,1197,25137]
score = invalid.map { |c| key[closers.index(c)] }.sum
puts score
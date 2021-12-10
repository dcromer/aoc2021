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
#puts score

def get_stack(chars)
    openers = "([{<".chars
    closers = ")]}>".chars  
    stack = []

    chars.each_with_index do |char, index|
        if openers.include?(char)
            stack.push(char)
        elsif char == closers[openers.index(stack.last)]
            stack.pop
        else
            return nil
        end
    end

    stack
end

key = [1,2,3,4]

open_stacks = input.map do |line|
    if stack = get_stack(line.chars)
        score = 0
        stack.reverse.map { |c| key[openers.index(c)] }.each do |i|
            score = score * 5 + i
        end
        score
    end
end.compact

puts open_stacks.sort[open_stacks.length / 2]
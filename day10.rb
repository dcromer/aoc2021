require './helper.rb'

input = File.open("input/day10.txt").readlines.map(&:strip).reject(&:empty?)

OPENERS = "([{<".chars
CLOSERS = ")]}>".chars
PART_1_SCORE = [3,57,1197,25137]
PART_2_SCORE = [1,2,3,4]

invalid_score = 0
scores = input.map do |input|
    stack = []
    input.chars.each do |char|
        if OPENERS.include?(char)
            stack.push(char)
        elsif char == CLOSERS[OPENERS.index(stack.last)]
            stack.pop
        else
            invalid_score += PART_1_SCORE[CLOSERS.index(char)]
            stack = []
            break
        end
    end

    if stack.any?
        score = 0
        stack.reverse.map { |c| PART_2_SCORE[OPENERS.index(c)] }.each do |i|
            score = score * 5 + i
        end
        score
    end
end.compact


Helper.assert_equal 399153, invalid_score
Helper.assert_equal 2995077699, scores.sort[scores.length / 2]

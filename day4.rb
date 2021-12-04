require './helper.rb'

input = File.open("input/day4.txt").readlines.map(&:strip).reject(&:empty?)

calls = input.shift

class Board
    attr_reader :cells

  def initialize(rows)
    @cells = rows.map { |row| row.split.map { |cell| { value: cell.to_i, marked: false } } }
  end

  def each_cell
    return enum_for :each_cell unless block_given?
    cells.map { |row| row.map { |c| yield c } }
  end

  def mark(value)
    each_cell do |c|
        if c[:value] == value
            c[:marked] = true
            return value
        end
    end
  end

  def to_s
    cells.map do |row|
        row.map { |c| "#{sprintf("%2i", c[:value])}#{'*' if c[:marked]}" }.join(" ")
    end.join("\n")
  end

  def is_win?
    is_row_win?(cells) || is_row_win?(cells.transpose) || is_diagonal_win?(cells) || is_diagonal_win?(cells.transpose)
  end

  def is_row_win?(rows)
    rows.any? do |row|
        row.all? { |c| c[:marked] }
    end
  end

  def is_diagonal_win?(rows)
    (0..4).all? { |i| rows[i][i][:marked] }
  end
end

boards = []
while input.length > 0
    rows = input.shift(5)
    boards << Board.new(rows)
end

def play_bingo(boards, calls)
    calls.split(",").each do |call|
        call = call.to_i
        boards.each do |b|
            b.mark(call)
            return b, call if b.is_win?
        end
    end
end

winner, final_call = play_bingo(boards, calls)
score = winner.each_cell.reject { |c| c[:marked] }.sum { |c| c[:value] } * final_call
Helper.assert_equal 41668, score

# Part 2
def endless_bingo(boards, calls)
    calls.split(",").each do |call|        
        call = call.to_i
        winners = []
        boards.each do |b|
            b.mark(call)
            winners << b if b.is_win?
        end
        if boards.length == 1 && boards[0].is_win?
            return boards[0], call
        end
        boards -= winners
    end
end

winner, final_call = endless_bingo(boards, calls)
score = winner.each_cell.reject { |c| c[:marked] }.sum { |c| c[:value] } * final_call
Helper.assert_equal 10478, score

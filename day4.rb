require './helper.rb'

input = File.open("input/day4.txt").readlines.map(&:strip).reject(&:empty?)

calls = input.shift

class Board
  attr_reader :cells

  Cell = Struct.new(:value, :marked)

  def initialize(rows)
    @cells = rows.map { |row| row.split.map { |value| Cell.new(value.to_i, false) } }
  end

  def each_cell
    return enum_for :each_cell unless block_given?
    cells.each { |row| row.each { |c| yield c } }
  end

  def mark(value)
    each_cell do |c|
        if c.value == value
            c.marked = true
            return value
        end
    end
  end

  def to_s
    cells.map do |row|
        row.map { |c| "#{sprintf("%2i", c.value)}#{'*' if c.marked}" }.join(" ")
    end.join("\n")
  end

  def is_win?
    is_row_win?(cells) || is_row_win?(cells.transpose) || is_diagonal_win?(cells) || is_diagonal_win?(cells.transpose)
  end

  def is_row_win?(rows)
    rows.any? do |row|
        row.all?(&:marked)
    end
  end

  def is_diagonal_win?(rows)
    (0..4).all? { |i| rows[i][i].marked }
  end

  def score
    each_cell.reject(&:marked).sum(&:value)
  end
end

boards = []
while input.length > 0
    rows = input.shift(5)
    boards << Board.new(rows)
end

def play_bingo(boards, calls)
    calls.split(",").each do |n|
        n = n.to_i
        boards.each do |b|
            b.mark(n)
            return b.score * n if b.is_win?
        end
    end
end

score = play_bingo(boards, calls)
Helper.assert_equal 41668, score

# Part 2
def endless_bingo(boards, calls)
    calls.split(",").each do |n|        
        n = n.to_i
        winners = []
        boards.each do |b|
            b.mark(n)
            winners << b if b.is_win?
        end
        if boards.length == 1 && boards[0].is_win?
            return boards[0].score * n
        end
        boards -= winners
    end
end

score = endless_bingo(boards, calls)
Helper.assert_equal 10478, score

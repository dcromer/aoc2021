require './helper.rb'

input = File.open("input/day4.txt").readlines.map(&:strip).reject(&:empty?)

calls = input.shift.split(",").map(&:to_i)

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
    if hit = each_cell.detect { |c| c.value == value }
      hit.marked = true
      if is_win?
        @winning_call = value
        return true
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
    each_cell.reject(&:marked).sum(&:value) * @winning_call
  end
end

boards = input.each_slice(5).map { |rows| Board.new(rows) }

def play_bingo(boards, calls)
  calls.each_with_object([]) do |n, winners|
    round_winners = boards.select { |b| b.mark(n) }
    boards -= round_winners
    winners.push(*round_winners)
  end
end

winners = play_bingo(boards, calls)

Helper.assert_equal 41668, winners.first.score
# Part 2
Helper.assert_equal 10478, winners.last.score

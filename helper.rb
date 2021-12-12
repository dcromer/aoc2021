module Helper
    def self.assert_equal(a, b)
        raise "Expected #{a} == #{b}" unless a == b
    end
end

# Utilities for working with 2x2 arrays
class Grid
  class << self
    ADJACENT_SPACES = [
      [0,-1],
      [0,1],
      [1,0],
      [-1,0]
    ]
    DIAGONAL_SPACES = ADJACENT_SPACES + [
      [-1, -1],
      [1, -1],
      [-1, 1],
      [1, 1]
    ]
    def index_neighbors_4(g, i, j)
      map_filter_neighbors(i, j, g.length, ADJACENT_SPACES)
    end

    def index_neighbors_8(g, i, j)
      map_filter_neighbors(i, j, g.length, DIAGONAL_SPACES)
    end

    private

    def map_filter_neighbors(i, j, max, vectors)
      vectors.map do |(k, l)|
        [i + k, j + l]
      end.select do |(k, l)|
        (k >= 0 && k < max) && (l >= 0 && l < max)
      end
    end
  end
end
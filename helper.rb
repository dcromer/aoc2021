module Helper
    def self.assert_equal(a, b)
        raise "Expected #{a} == #{b}" unless a == b
    end
end

# Utilities for working with 2x2 arrays
class Grid
  class << self
    def index_neighbors_4(g, i, j)
        [
          [0,-1],
          [0,1],
          [1,0],
          [-1,0]
        ].map do |(k, l)|
          [i + k, j + l]
        end.select do |(k, l)|
          (k >= 0 && k < g.length) && (l >= 0 && l < g[0].length)
        end
    end
  end
end
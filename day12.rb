require './helper.rb'

input = File.open("input/day12.txt").readlines.map(&:strip).reject(&:empty?)

class Node
    attr_accessor :name, :edges

    def initialize(name)
        @name = name
        @edges = []
    end

    def large_cave?
      @name == @name.upcase
    end

    def end?
      @name == "end"
    end

    def start?
      @name == "start"
    end
end

nodes_by_name = {}
input.map do |line|
    start, ending = *line.split("-")
    nodes_by_name[start] ||= Node.new(start)
    nodes_by_name[ending] ||= Node.new(ending)
    nodes_by_name[start].edges << nodes_by_name[ending]
    nodes_by_name[ending].edges << nodes_by_name[start]
end

def get_paths(start, current_path=[], filter_edges:)
  current_path = current_path + [start.name]
  num_visits_by_node = current_path.group_by(&:itself).transform_values(&:length)
  to_visit = start.edges.select { |node| filter_edges.call(node, num_visits_by_node) }

  to_visit.map do |edge|
    if edge.end?
      [[current_path + [edge.name]]]
    else
      get_paths(edge, current_path, filter_edges: filter_edges)
    end
  end.flatten(1)
end

def filter_part_1(node, num_visits_by_node)
  times_visited = num_visits_by_node[node.name] || 0
  node.large_cave? || times_visited == 0
end

def filter_part_2(node, num_visits_by_node)
  times_visited = num_visits_by_node[node.name] || 0
  visited_small_cave_twice = num_visits_by_node.select { |k, v| k == k.downcase && v > 1 }.any?

  !node.start? && (node.large_cave? || times_visited == 0 || (times_visited == 1 && !visited_small_cave_twice))
end

# Part 1
paths = get_paths(nodes_by_name["start"], filter_edges: method(:filter_part_1))
Helper.assert_equal 4573, paths.count

# Part 2
paths = get_paths(nodes_by_name["start"], filter_edges: method(:filter_part_2))
Helper.assert_equal 117509, paths.count

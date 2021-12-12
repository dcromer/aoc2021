require './helper.rb'

input = File.open("input/day12.txt").readlines.map(&:strip).reject(&:empty?)

class Node
    attr_accessor :name, :large_cave, :edges

    def initialize(name)
        @name = name
        @large_cave = name == name.upcase
        @edges = []
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

$paths = []
def get_paths(start, current_path=[])
  current_path = current_path + [start.name]
  start.edges.select do |edge|
      times_visited = current_path.group_by(&:itself).transform_values(&:length)[edge.name] || 0
      edge.large_cave || times_visited == 0
  end.map do |edge|
    if edge.end?
      $paths << (current_path + [edge.name])
    else
      get_paths(edge, current_path)
    end
  end
end

get_paths(nodes_by_name["start"])

puts $paths.count
#puts $paths.map { |p| p.join("-")}.join("\n")

# Part 2
$paths = []
def get_paths2(start, current_path=[])
  current_path = current_path + [start.name]

  start.edges.select do |edge|
      num_visits_by_node = current_path.group_by(&:itself).transform_values(&:length)
      times_visited = num_visits_by_node[edge.name] || 0
      visited_small_cave_twice = num_visits_by_node.select { |k, v| k == k.downcase && v > 1 }.any?

      !edge.start? && (edge.large_cave || times_visited == 0 || (times_visited == 1 && !visited_small_cave_twice))
  end.map do |edge|
    if edge.end?
      $paths << (current_path + [edge.name])
    else
      get_paths2(edge, current_path)
    end
  end
end

get_paths2(nodes_by_name["start"])

puts $paths.count
#puts $paths.map { |p| p.join("-")}.join("\n")
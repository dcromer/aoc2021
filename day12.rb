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
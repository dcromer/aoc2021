require './helper.rb'
input = File.open("input/day16.txt").readlines.map(&:strip).reject(&:empty?)

def convert_to_binary(hex_string)
  [hex_string].pack('H*').unpack('B*').first
end

Packet = Struct.new(:version, :type_id, :literal_value, :packets, keyword_init: true)

def build_packets(bitstring, outer: true)
  Enumerator.new do |e|
    until bitstring.empty?
      version = bitstring.slice!(0, 3).to_i(2)
      type_id = bitstring.slice!(0, 3).to_i(2)
      # Literal Value
      if type_id == 4
        group = bitstring.slice!(0, 5)
        groups = [group.slice(1, 4)]
        until group.start_with?('0')
          group = bitstring.slice!(0, 5)
          groups << group.slice(1, 4)
        end

        e.yield Packet.new(version: version, type_id: type_id, literal_value: groups.join.to_i(2))
      # Operator
      else
        length_type = bitstring.slice!(0, 1).to_i(2)
        if length_type == 0
          total_length = bitstring.slice!(0, 15).to_i(2)
          packets = build_packets(bitstring.slice!(0, total_length), outer: false)

          e.yield Packet.new(version: version, type_id: type_id, packets: packets.to_a)
        else
          num_packets = bitstring.slice!(0, 11).to_i(2)
          packets = build_packets(bitstring, outer: false).take(num_packets)
           
          e.yield Packet.new(version: version, type_id: type_id, packets: packets.to_a)
        end
      end
      if outer
        while bitstring[0] == "0"
          bitstring.slice!(0, 1)
        end
      end
    end
  end
end

def add_versions(packets)
  versions = 0
  packets.each do |packet|
    versions += packet.version
    versions += add_versions(packet.packets) if packet.packets
  end
  versions
end

def calculate_packet(packet)
  case packet.type_id
  when 0
    packet.packets.map { |p| calculate_packet(p) }.sum
  when 1
    product = 1
    packet.packets.each { |p| product = product * calculate_packet(p) }
    product
  when 2
    packet.packets.map { |p| calculate_packet(p) }.min
  when 3
    packet.packets.map { |p| calculate_packet(p) }.max
  when 4
    packet.literal_value
  when 5
    calculate_packet(packet.packets.first) > calculate_packet(packet.packets[1]) ? 1 : 0
  when 6
    calculate_packet(packet.packets.first) < calculate_packet(packet.packets[1]) ? 1 : 0
  when 7
    calculate_packet(packet.packets.first) == calculate_packet(packet.packets[1]) ? 1 : 0
  end
end

def solve_part_1(hex_string)
  bitstring = convert_to_binary(hex_string)
  packets = build_packets(bitstring).to_a
  add_versions(packets)
end

def solve_part_2(hex_string)
  bitstring = convert_to_binary(hex_string)
  packets = build_packets(bitstring).to_a
  calculate_packet(packets.first)
end

example_1 = "D2FE28"
example_1_binary = convert_to_binary(example_1)
Helper.assert_equal "110100101111111000101000", example_1_binary
example_1_packet = build_packets(example_1_binary).first
Helper.assert_equal 2021, example_1_packet.literal_value

example_2_binary = "00111000000000000110111101000101001010010001001000000000"
example_2_packet = build_packets(example_2_binary).first
Helper.assert_equal [10, 20], example_2_packet.packets.map(&:literal_value)

example_3_binary = "11101110000000001101010000001100100000100011000001100000"
example_3_packet = build_packets(example_3_binary).first
Helper.assert_equal [1, 2, 3], example_3_packet.packets.map(&:literal_value)

Helper.assert_equal 977, solve_part_1(input.first.dup)
Helper.assert_equal 3, solve_part_2("C200B40A82")
Helper.assert_equal 54, solve_part_2("04005AC33890")
Helper.assert_equal 101501020883, solve_part_2(input.first.dup)

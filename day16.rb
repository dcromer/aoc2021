require './helper.rb'
input = File.open("input/day16_test.txt").readlines.map(&:strip).reject(&:empty?)

def convert_to_binary(hex_string)
    [hex_string].pack('H*').unpack('B*').first
end

LiteralValue = Struct.new(:version, :literal_value)
Operator = Struct.new(:version, :packets)

def is_terminal_group?(bitstring)
  bitstring.start_with?('0')
end

def build_literal_value!(bitstring, version)
  group = bitstring.slice!(0, 5)
  groups = [group.slice(1, 4)]
  length = 4
  until is_terminal_group?(group)
    group = bitstring.slice!(0, 5)
    groups << group.slice(1, 4)

    length += 4
  end

  return LiteralValue.new(version, groups.join.to_i(2)), length
end

def build_packets(bitstring)
  Enumerator.new do |e|
    until bitstring.empty?
      version = bitstring.slice!(0, 3).to_i(2)
      type_id = bitstring.slice!(0, 3).to_i(2)
      length = 6
      # Literal Value
      if type_id == 4
        value, length = build_literal_value!(bitstring, version)
        e.yield value
        if trash = length % 4
          bitstring.slice!(0, length % 4)
        end
      # Operator
      else
        length_type = bitstring.slice!(0, 1).to_i(2)
        length += 1
        if length_type == 0
          total_length = bitstring.slice!(0, 15).to_i(2)
          length += 15
          packets = build_packets(bitstring.slice!(0, total_length))

          e.yield Operator.new(version, packets.to_a)
          if trash = length % 4
            bitstring.slice!(0, length % 4)
          end
          bitstring.slice!(0, 4) # Mystery, part 2 maybe

        else
        end
      end


    end
  end
end

example_1 = "D2FE28"
example_1_binary = convert_to_binary(example_1)
Helper.assert_equal "110100101111111000101000", example_1_binary
example_1_packet = build_packets(example_1_binary).first
Helper.assert_equal 2021, example_1_packet.literal_value

example_2_binary = "00111000000000000110111101000101001010010001001000000000"
example_2_packet = build_packets(example_2_binary).to_a.first
binding.irb
Helper.assert_equal [10, 20], example_2_packet.packets.map(&:literal_value)
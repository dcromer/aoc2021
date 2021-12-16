require './helper.rb'
input = File.open("input/day16_test.txt").readlines.map(&:strip).reject(&:empty?)

def convert_to_binary(hex_string)
    [hex_string].pack('H*').unpack('B*').first
end

LiteralValue = Struct.new(:version, :type_id, :literal_value)

def is_terminal_group?(bitstring)
  bitstring.start_with?('0')
end

def build_packets(bitstring)
  Enumerator.new do |e|
    until bitstring.empty?
      version = bitstring.slice!(0, 3).to_i(2)
      type_id = bitstring.slice!(0, 3).to_i(2)
      length = 6
      # Literal Value
      if type_id == 4
        group = bitstring.slice!(0, 5)
        groups = [group.slice(1, 4)]
        length += 5
        until is_terminal_group?(group)
          group = bitstring.slice!(0, 5)
          groups << group.slice(1, 4)

          length += 5
        end

        if trash = length % 4
          bitstring.slice!(0, length % 4)
        end
 
        e.yield LiteralValue.new(version, type_id, groups.join.to_i(2))
      end
    end
  end
end

example_1 = "D2FE28"
example_1_binary = convert_to_binary(example_1)
Helper.assert_equal "110100101111111000101000", example_1_binary
example_1_packet = build_packets(example_1_binary).first
Helper.assert_equal 2021, example_1_packet.literal_value





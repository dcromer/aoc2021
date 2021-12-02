module Helper
    def self.assert_equal(a, b)
        raise "Expected #{a} == #{b}" unless a == b
    end
end
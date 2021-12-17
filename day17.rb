#sample_input = "target area: x=20..30, y=-10..-5"

#xmin,xmax,ymin,ymax = 20,30,-10,-5
xmin,xmax,ymin,ymax = 32,65,-225,-177

#input = "target area: x=32..65, y=-225..-177"

def step(y, yv)
    y = y + yv
    yv -= 1
    return y, yv
end

def fire(yv, ymin, ymax)
    y = 0
    apogee = y
    yvmax = ymax - ymin

    while y > ymin
        new_y, yv = step(y, yv)
        apogee = new_y if new_y > apogee
        if new_y >= ymin && new_y <= ymax
            return true, apogee
        end
        y = new_y
    end

    return false, nil
end

def solve_part_1(ymin, ymax)
    1000.times.map do |yv|
        [yv, fire(yv, ymin, ymax)]
    end.select { |(yv, result)| result[0] }
end

puts solve_part_1(ymin, ymax).inspect
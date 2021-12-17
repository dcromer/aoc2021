require './helper.rb'

xmin,xmax,ymin,ymax = 32,65,-225,-177

def step(p, v)
    p += v
    x = if v.x > 0
        v.x - 1
    elsif v.x < 0
        v.x + 1
    else
        0
    end
    v = Vector2.new(x, v.y - 1)
    return p, v
end

def fire(v, xmin, xmax, ymin, ymax)
    p = Vector2.new(0, 0)
    apogee = p.y

    while p.y > ymin && p.x < xmax
        new_p, v = step(p, v)
        apogee = new_p.y if new_p.y > apogee
        if new_p.y >= ymin && new_p.y <= ymax && new_p.x >=xmin && new_p.x <= xmax
            return true, apogee
        end
        p = new_p
    end

    return false, nil
end

def run(xmin, xmax, ymin, ymax)
    (-500..500).to_a.map do |yv|
        1000.times.map do |xv|
            v = Vector2.new(xv, yv)
            [v, fire(v, xmin, xmax, ymin, ymax)]
        end.select { |(_, result)| result[0] }
    end.flatten(1)
end

def solve_part_1(xmin, xmax, ymin, ymax)
    run(xmin, xmax, ymin, ymax).map { |(v, result)| result[1] }.max
end

def solve_part_2(xmin, xmax, ymin, ymax)
    run(xmin, xmax, ymin, ymax).count
end

Helper.assert_equal 25200, solve_part_1(xmin, xmax, ymin, ymax)
Helper.assert_equal 3012, solve_part_2(xmin, xmax, ymin, ymax)

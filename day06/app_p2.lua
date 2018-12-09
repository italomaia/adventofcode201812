local json = require('dkjson')
local coords = {}
local dmap = {}
local max_x, max_y = nil, nil
local points_within_range = 0
local points_within_range_max_dist = 10000
local fname = 'input'

local function fn_keys(t)
    local _keys = {}
    for k, v in pairs(t) do
        table.insert(_keys, k)
    end
    return _keys
end

local function parse_coord(str)
    local x, y = string.match(str, "(%d+), (%d+)")
    return {math.floor(x)+1, math.floor(y)+1}
end

for line in io.lines(fname) do
    local coord = parse_coord(line)
    table.insert(coords, coord)
    
    max_x = max_x or coord[1]
    max_y = max_y or coord[2]
    
    max_x = (max_x > coord[1]) and max_x or coord[1]
    max_y = (max_x > coord[2]) and max_x or coord[2]
end

-- OK

local function fn_distance(coord_a, coord_b)
    return math.abs(coord_a[1] - coord_b[1]) + math.abs(coord_a[2] - coord_b[2])
end

local function fn_distance_bulk(coord, coords)
    local total = 0
    for point, _coord in pairs(coords) do
        local distance = fn_distance(coord, _coord)
        total = total + distance
    end
    return total
end

for x=1, max_x do
    for y=1, max_y do
        local total_dist = fn_distance_bulk({x, y}, coords)
        if total_dist < points_within_range_max_dist then
            points_within_range = points_within_range + 1
        end
    end
end

print(points_within_range)
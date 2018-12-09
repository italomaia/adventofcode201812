local coords = {}
local dmap = {}
local max_x, max_y = nil, nil
local json = require('dkjson')

local function fn_keys(t)
    local _keys = {}
    for k, v in pairs(t) do
        table.insert(_keys, k)
    end
    return _keys
end

local function parse_coord(str)
    local x, y = string.match(str, "(%d+), (%d+)")
    return {math.floor(x+1), math.floor(y+1)}
end

for line in io.lines('input') do
    local coord = parse_coord(line)
    table.insert(coords, coord)
    
    max_x = max_x or coord[1]
    max_y = max_y or coord[2]
    
    max_x = (max_x > coord[1]) and max_x or coord[1]
    max_y = (max_x > coord[2]) and max_x or coord[2]
end

-- OK

-- gets the closest point in coords to coord
local function closest(coord, coords)
    local lowest_dist = nil
    local map = {}  -- map each distance to a list of points

    for point, _coord in pairs(coords) do
        local dx = math.abs(coord[1] - _coord[1])
        local dy = math.abs(coord[2] - _coord[2])
        local dist = dx + dy
        
        lowest_dist = lowest_dist or dist
        lowest_dist = (dist < lowest_dist) and dist or lowest_dist

        map[dist] = map[dist] or {}
        map[dist][point] = true
    end

    -- list of points with lowest_dist as distance
    local points = fn_keys(map[lowest_dist])
    
    -- if lowest dist has only one point ...
    if #points == 1 then
        return points[1]
    else
        return -1  -- lowest distance for multiple points 
    end
end

local bounds = {}
-- shows the closest point to each coord
local count_map = {}

for x=1, max_x+1 do
    for y=1, max_y+1 do
        dmap[x] = dmap[x] or {}
        dmap[x][y] = closest({x, y}, coords)
        
        if dmap[x][y] > 0 then
            count_map[dmap[x][y]] = count_map[dmap[x][y]] or 0
            count_map[dmap[x][y]] = count_map[dmap[x][y]] + 1
        end

        if bounds[dmap[x][y]] == nil then bounds[dmap[x][y]] = true end
        if (x == 1) or (x == max_x) or (y == 1) or (y == max_y) then
            bounds[dmap[x][y]] = false
        end
    end
end

local max_p = nil
local max_v = nil

for point, value in pairs(count_map) do
    if bounds[point] then
        max_p = max_p or point
        max_v = max_v or value

        if value > max_v then
            max_v = value
            max_p = point
        end
    end
end

print(max_v)
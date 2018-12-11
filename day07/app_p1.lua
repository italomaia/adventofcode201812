local fname = 'test'
local instructions = {}  -- maps step to following instructions
local req_count = {}  -- how many requirements each step has
local lowest_req_count = nil
local lowest_req = nil
local json = require('dkjson')

local function parse(line)
    return string.match(line, "Step (%a).+step (%a)")
end

for line in io.lines(fname) do
    local step, follow = parse(line)

    instructions[step] = instructions[step] or {}
    
    req_count[step] = req_count[step] or 0
    req_count[follow] = req_count[follow] or 0
    
    table.insert(instructions[step], req)
    req_count[follow] = req_count[follow] + 1

    lowest_req = lowest_req or follow
    lowest_req_count = lowest_req_count or req_count[follow]
    
    if req_count[follow] < lowest_req_count then
        lowest_req_count = req_count[follow]
        lowest_req = follow
    end
end

-- multiple starting points are possible
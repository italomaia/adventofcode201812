local fname = arg[1]
local debug = arg[2] ~= nil
local fol_map = {}  -- maps step to following instructions
local req_map = {}  -- maps requirements for each step
local opt_map = {}  -- possible steps
local curr = {}  -- steps currently being evaluated
local seen = {}  -- steps already done
local result = {}  -- well ... the result
local json = debug and require('dkjson') or nil

-- creates a table with boolean values that keeps track of
-- how many true values it has
function ctable ()
    local proxy = {
        __count = 0
    }

    return setmetatable({}, {
        __index = function (t, k)
            return rawget(proxy, k)
        end,
        __newindex = function (t, k, v)
            if type(v) ~= 'boolean' then
                error('ctable only accepts booleans as value')
            end

            local count = rawget(proxy, '__count')
            local cv = not not rawget(proxy, k) -- current value

            if cv and not v then
                rawset(proxy, '__count', count - 1)
            elseif not cv and v then
                rawset(proxy, '__count', count + 1)
            end
            
            rawset(proxy, k, v)
        end,
        __len = function (t)
            return rawget(proxy, '__count')
        end
    })
end

local function parse(line)
    return string.match(line, "Step (%a).+step (%a)")
end

for line in io.lines(fname) do
    local step, follow = parse(line)

    -- initialize
    opt_map[step] = true
    opt_map[follow] = true
    
    fol_map[step] = fol_map[step] or {}
    req_map[follow] = req_map[follow] or ctable()

    table.insert(fol_map[step], follow)
    req_map[follow][step] = true
end

if debug then
    print("fol_map:\n" .. json.encode(fol_map))
    print("req map:\n" .. json.encode(req_map))
end

for step, _ in pairs(opt_map) do
    req_map[step] = req_map[step] or ctable()

    -- sets first steps
    if #req_map[step] == 0 then
        table.insert(curr, step)
    end
end

if debug then
    print('initial set: ' .. json.encode(curr))
end

io.write("result: ")

while #curr > 0 do
    table.sort(curr)
    
    local step = table.remove(curr, 1)
    local following = fol_map[step] or {}

    if #req_map[step] == 0 and not seen[step] then
        table.insert(result, step)
        seen[step] = true
        
        for _req, _map in pairs(req_map) do
            _map[step] = false
        end
    end
    
    for _, _step in pairs(following) do
        if not seen[_step] then
            table.insert(curr, _step)
        end
    end
end

print(table.concat(result, ''))

-- multiple starting points are possible
local records = {}
local json = require('dkjson')
local sleep_state = false

function fn_reduce (t, fn, default)
    local rs = default
    local curr = nil
    for k, curr in pairs(t) do
        if rs == nil then
            rs = curr
        else rs = fn(rs, curr) end
    end
    return rs
end

function fn_max (t)
    local max = nil
    for k, v in pairs(t) do
        max = max or v
        max = math.max(max, v)
    end
    return max
end

function extract_guard (txt)
    return string.match(txt, "(%d+)")
end

-- true     -> awake
-- false    -> sleep
function extract_state (txt)
    return string.match(txt, "sleep") == nil
end

-- day, min, txt
function parse(line)
    local month, day, min, txt = string.match(line, "%[%d+%-(%d+)%-(%d+) %d+:(%d+)%] (.+)")
    return {
        day = math.floor(string.format("%d%d", month, day)),
        min = math.floor(min),
        txt = txt,
        state = extract_state(txt)
    }
end

for line in io.lines('input') do
    table.insert(records, parse(line))
end

table.sort(records, function (a, b)
    if a.day < b.day then
        return true
    end

    if a.day == b.day then
        return a.min < b.min
    end

    return false
end)

local sleep_map = {}
local time_map = {}
local guard = nil
for _, record in pairs(records) do
    guard = extract_guard(record.txt) or guard
    time_map[record.day] = time_map[record.day] or {}
    time_map[record.day][guard] = time_map[record.day][guard] or {}
    table.insert(time_map[record.day][guard], record)
end

for day, map in pairs(time_map) do
    for guard, _records in pairs(map) do
        sleep_map[guard] = sleep_map[guard] or {}
        
        local last_record = nil
        local local_sleep_map = sleep_map[guard]
        for _, record in pairs(_records) do
            if last_record ~= nil and last_record.state == sleep_state then
                for m=last_record.min, record.min - 1 do
                    local_sleep_map[tostring(m)] = (local_sleep_map[tostring(m)] or 0) + 1
                end
            end

            last_record = record
        end
    end
end

function find_top_slept_minute(sleep_map)
    local max_min, max_qty = nil, nil
    for min, qty in pairs(sleep_map) do
        max_min = max_min or min
        max_qty = max_qty or qty

        if qty > max_qty then
            max_qty = qty
            max_min = min
        end
    end
    return max_min, max_qty
end

local top_slept_minute = nil
local top_slept_minute_qty = nil
local top_slept_guard = nil

for guard, sleep_time_map in pairs(sleep_map) do
    top_slept_guard = top_slept_guard or guard
    
    local slept_minute, slept_minute_qty = find_top_slept_minute(sleep_time_map)
    if slept_minute ~= nil then 
        top_slept_minute = top_slept_minute or slept_minute
        top_slept_minute_qty = top_slept_minute_qty or slept_minute_qty

        if slept_minute_qty > top_slept_minute_qty then
            top_slept_guard = guard
            top_slept_minute = slept_minute
            top_slept_minute_qty = slept_minute_qty
        end
    end
end

print(math.floor(top_slept_guard * top_slept_minute))
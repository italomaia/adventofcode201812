local frequency = {}
for line in io.lines("input") do
    table.insert(frequency, tonumber(line))
end

local len = #frequency
local pos = 0
local total = 0
local count = { [0] = true }

while true do
    pos = (pos % len) + 1
    total = total + frequency[pos]
    
    if count[total] then break else
        count[total] = true
    end

    count[total] = true
end

print(total)
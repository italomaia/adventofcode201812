function diff1(line_a, line_b)
    local count = 0
    for i=1, #line_a do
        local equal = line_a:sub(i, i) == line_b:sub(i, i)
        count = count + (equal and 0 or 1)
        if count > 1 then return false end
    end
    return count == 1
end

function match(line_a, line_b)
    local substr = {}
    for i=1, #line_a do
        if line_a:sub(i, i) == line_b:sub(i, i) then
            table.insert(substr, line_a:sub(i, i))
        end
    end
    return table.concat(substr, "")
end

local lines = {}

for line in io.lines('input') do
    table.insert( lines, line )
end

for y=1, #lines do
    local base = lines[y]
    for z=y+1, #lines do
        local line = lines[z]
        
        if diff1(base, line) then
            print(match(base, line))
            os.exit()
        end
    end
end
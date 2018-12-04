local function count_letters (text)
    local map = {}
    local has2 = false
    local has3 = false

    for c in string.gmatch(text, "(%a)") do
        map[c] = map[c] and (map[c] + 1) or 1
    end

    for chr, count in pairs(map) do
        if count == 2 then has2 = true end
        if count == 3 then has3 = true end
    end

    return has2, has3
end

local rs = {
    ['has2'] = 0,
    ['has3'] = 0,
}

for line in io.lines('input') do
    local has2, has3 = count_letters(line)
    rs['has2'] = rs['has2'] + (has2 and 1 or 0)
    rs['has3'] = rs['has3'] + (has3 and 1 or 0)
end

print(rs['has2'] * rs['has3'])
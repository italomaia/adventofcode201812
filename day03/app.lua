local overlap = {}
local count = 0

local function parse_claim(text)
    -- {int, int, int, int, int}
    local id, le, te, wi, he = string.match(text, "#(%d+) @ (%d+),(%d+): (%d+)x(%d+)")
    return tonumber(le), tonumber(te), tonumber(wi), tonumber(he)
end

for line in io.lines('input') do
    local le, te, wi, he = parse_claim(line)

    for i=le, le+wi-1 do
        for j=te, te+he-1 do
            local coord = string.format("%sx%s", i, j)
            overlap[coord] = overlap[coord] and (overlap[coord] + 1) or 1
            if overlap[coord] == 2 then
                count = count + 1
            end
        end
    end
end

print(count)
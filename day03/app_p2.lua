local claim_size = {}
-- number of inches a claim has without overlap
local claim_occr = {}
local count = 0
local map = {}

local function parse_claim(text)
    -- {int, int, int, int, int}
    local id, le, te, wi, he = string.match(text, "#(%d+) @ (%d+),(%d+): (%d+)x(%d+)")
    return tonumber(id), tonumber(le), tonumber(te), tonumber(wi), tonumber(he)
end

for line in io.lines('input') do
    local id, le, te, wi, he = parse_claim(line)
    claim_size[id] = wi * he

    for i=le, le+wi-1 do
        for j=te, te+he-1 do
            local coord = string.format("%sx%s", i, j)
            if map[coord] == nil then
                map[coord] = { id }
            else
                table.insert(map[coord], id)
            end
        end
    end
end

for coord, ids in pairs(map) do
    if #ids == 1 then
        local id = ids[1]
        claim_occr[id] = claim_occr[id] and (claim_occr[id] + 1) or 1
    end
end

for id, occr in pairs(claim_occr) do
    if claim_size[id] == occr then
        print(id)
        break
    end
end
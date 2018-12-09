local fs = io.open('input')
local data = fs:read()
fs:close()

local stream = {}

for char in string.gmatch(data, ".") do
    local last_char = stream[#stream]
    if (char ~= last_char) and (string.lower(char) == (last_char and string.lower(last_char))) then
        table.remove(stream)
    else
        table.insert(stream, char)
    end
end
print(#stream)
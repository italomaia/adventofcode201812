local fs = io.open('input')
local data = fs:read()
fs:close()

local fstream = {}
local options = {}

for char in string.gmatch(data, ".") do
    table.insert(fstream, char)
    options[string.lower(char)] = true
end

local lowest_count = #fstream

for opt, _ in pairs(options) do
    local stream = {}
    for _, char in pairs(fstream) do
        if string.lower(char) ~= opt then
            local last_char = stream[#stream]
            if (char ~= last_char) and (string.lower(char) == (last_char and string.lower(last_char))) then
                table.remove(stream)
            else
                table.insert(stream, char)
            end
        end
    end

    local count = #stream
    if count < lowest_count then
        lowest_count = count
    end
end
print(lowest_count)
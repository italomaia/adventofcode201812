local total = 0

for line in io.lines('input') do
    total = total + line
end

print(math.floor(total))
"""
    read_schematic(filename)

Read file line-by-line into a matrix of characters that represent the schematic.
"""
function read_schematic(filename)
    lines = readlines(filename)
    xdim = length(lines[1])
    ydim = length(lines)
    schematic::Matrix{Char} = fill('.', xdim, ydim)
    for y = 1:ydim
        line = lines[y]
        for x = 1:xdim
            schematic[y, x] = line[x]
        end
    end
    return schematic
end

"""
    part_number_at(schematic, y, x)

Retrieve partnumber at coordinate in schematic.
"""
function part_number_at(schematic::Matrix{Char}, y, x)
    i = x; j = x
    xdim = size(schematic, 2)
    while i-1 >= 1 && isnumeric(schematic[y, i-1])
        i -= 1
    end
    while j+1 <= xdim && isnumeric(schematic[y, j+1])
        j += 1
    end
    return parse(Int, String(schematic[y, i:j]))
end

"""
    part_numbers(schematic)

Find all part numbers in the schematic. Iterate through every coordinate in the schematic,
when we find a symbol, iterate over every neighbour for digits. If we find a digit then 
use part_number_at() to retrieve the number and add it to a set of all parts associated 
with this symbol. When we have finished iterating over the symbol neighbours, concatenate
the discovered part numbers into the result list.
"""
function part_numbers(schematic::Matrix{Char})::Vector{Int}
    (ydim, xdim) = size(schematic)
    partnums = Vector{Int}()
    for y = 2:ydim-1, x = 2:xdim-1
        ch = schematic[y, x]
        if ch != '.' && !isnumeric(ch)
            parts = Set{Int}()
            for dy = -1:1, dx = -1:1
                n = schematic[y+dy, x+dx]
                if isnumeric(n)
                    partnum = part_number_at(schematic, y+dy, x+dx)
                    push!(parts, partnum)
                end
            end
            push!(partnums, parts...)
        end
    end
    return partnums
end

"""
    sum_part_numbers_in_schematic(filename)

Find all part numbers in the schematic defined in filename and return their sum.
"""
function sum_part_numbers_in_schematic(filename)
    schematic = read_schematic(filename)
    partnums = part_numbers(schematic)
    return sum(partnums)
end
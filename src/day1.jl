"""
    getdigit(str)

Retrieve the digit at the start of string if there is one.
"""
function getdigit(str)
    numbers = Dict(
        "one" => "1",
        "two" => "2",
        "three" => "3",
        "four" => "4",
        "five" => "5",
        "six" => "6",
        "seven" => "7",
        "eight" => "8",
        "nine" => "9",
    )
    for (word, number) in numbers
        if startswith(str, word)
            return number
        end
    end
    if isnumeric(str[1])
        return str[1]
    end
    return nothing 
end

"""
    calibration_value(line)

Read calibration value from string by concatenating the digit at the start and ends of the line, 
before parsing into an Integer.
"""
function calibration_value(line)
    x = nothing
    y = nothing

    index = 1
    while isnothing(x) && index <= length(line)
        x = getdigit(line[index:end])
        index += 1
    end

    index = length(line)
    while isnothing(y) && index >= 1
        y = getdigit(line[index:end])
        index -= 1
    end

    return parse(Int, "$(x)$(y)")
end

"""
    sum_of_calibration_values(filename)

Read filename line-by-line and sum the calibration_value of each line.
"""
function sum_of_calibration_values(filename)
    sum = 0
    for line in readlines(filename)
        value = calibration_value(line)
        sum += value
    end
    return sum
end
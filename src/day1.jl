"""
    calibration_value(line)

Read calibration value from string by concatenating the digit at the start and ends of the line, 
before parsing into an Integer.
"""
function calibration_value(line)
    x = findfirst(isnumeric, line)
    y = findlast(isnumeric, line)
    return parse(Int, "$(line[x])$(line[y])")
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
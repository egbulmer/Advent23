"""
Game with an ID and array of sets of drawn cubes. A set is represented by a tuple of three 
integers in the format (r, g, b).
"""
struct Game
    id::Int
    sets::Vector{Tuple{Int, Int, Int}}
end

"""
    parse_set(str)

Parse a string of the form '3 blue, 4 red, 1 green' into a tuple of three integers: (r, g, b).
"""
function parse_set(str)
    r, g, b = zeros(Int, 3)
    parts = split(str, ",")
    for part in parts
        m = match(r"(\d+) (red|green|blue)", part)
        num = parse(Int, m[1])
        col = m[2]
        if col == "red"
            r = num
        elseif col == "green"
            g = num
        elseif col == "blue"
            b = num
        end
    end
    return (r, g, b)
end

"""
    parse_game(str)

Parse a string into a game with an ID and an array of drawn cubes (e.g. sets).
"""
function parse_game(str)
    m = match(r"Game (\d+): (.*)", str)
    id = parse(Int, m[1])
    sets = map(parse_set, split(m[2], ";"))
    return Game(id, sets)
end

"""
    is_game_possible(game, bag)

Check if the game is possible given the contents of the bag.
"""
function is_game_possible(game::Game, bag::Tuple{Int, Int, Int})::Bool
    maxr, maxg, maxb = bag
    for (setr, setg, setb) in game.sets
        if setr > maxr || setg > maxg || setb > maxb
            return false
        end
    end
    return true
end

"""
    sum_of_possible_games(filename)

Read file one line at a time, parsing them into a Game object and then checking if 
the game is possible if the bag contained 12 red cubes, 13 green cubes, and 14 blue cubes.
Return the sum of all possible game IDs.
"""
function sum_of_possible_games(filename)
    bag = (12, 13, 14)
    sum = 0
    for line in readlines(filename)
        game = parse_game(line)
        if is_game_possible(game, bag)
            sum += game.id
        end
    end
    return sum
end
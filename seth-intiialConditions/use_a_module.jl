module InitialConds
include("main.jl")
using .SethStuff
export getVel, getPos

iota = 0.1

function getVel(days_since_2000)
    pos1 = findPositionFromDate(2000, 1, days_since_2000)
    pos2 = findPositionFromDate(2000, 1, days_since_2000 + iota)

    del = pos2 - pos1

    del / (iota)
end

function getPos(days_since_2000)
    findPositionFromDate(2000, 1, days_since_2000)
end

end

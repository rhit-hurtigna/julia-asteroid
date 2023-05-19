module Simulator
using LinearAlgebra: norm
using Distributions
using Distributed
export runSimMain

function runSimMain(sims, P0, V0, M, g, dT, T, dFrame)
    dists = runManySims(sims, P0, V0, M, g, dT, T, dFrame)
    (_, hist) = runSim(P0, V0, M, g, dT, T, dFrame)
    (dists, hist)
end

function runManySims(sims, P0, V0, M, g, dT, T, dFrame)
    # my_procs = addprocs(10)
    # my_procs = addprocs(4)

    @distributed (vcat) for i = 1:sims
        d = Normal(0, 0.02)
        P0[1,:] += rand(d, 3)
        d = Normal(0, 0.00002)
        V0[1,:] += rand(d, 3)
        (minDist, _) = runSim(P0, V0, M, g, dT, T, T/2)
        minDist
    end
    # @sync rmprocs(my_procs)
end

"""
runSim

P0 -- initial positions, Nx3, float
V0 -- initial velocities, Nx3, float
M -- masses, Nx1, positive float
g -- gravitational constant, positive scalar
dT -- timestep length, positive float
T -- run time [0,T], positive float
dFrame -- time between frames, positive float

Returns MxNx3 matrix of snapshots, where
M is close to [T/dFrame]
"""
function runSim(P0, V0, M, g, dT, T, dFrame)
    minDist = Inf
    Vlast = V0
    Plast = P0
    skip = floor(Int,dFrame/dT)
    numSteps = div(T,dT) + skip
    Hist = zeros(floor(Int,numSteps/skip)+1,size(P0,1),3)
    Hist[1,:,:] = P0
    for i in 1:numSteps
        A = getAccel(Plast,M,g)
        # println(A)
        Vlast = Vlast .+ dT*A
        Plast = Plast .+ dT*Vlast
        dist = norm(Plast[1,:] - Plast[5,:])
        minDist = min(dist, minDist)
        if mod(i, skip) == 0
            Hist[floor(Int,i/skip)+1,:,:] = Plast
        end
    end
    (minDist, Hist)
end

"""
getAccel

P -- positions, Nx3, float
M -- masses, Nx1, positive float
g -- gravity acceleration, scalar

Returns Nx3 matrix of acceleration due to
gravity
"""
function getAccel(P,M,g)
    N = size(P, 1)
    A = zeros(N, 3)
    for i in 1:N
        Pi = P[i,:]
        Mi = M[i]
        for j in i+1:N
            Pj = P[j,:]
            Mj = M[j]
            Vij = Pi-Pj
            # println("Vij: $Vij")
            r = norm(Vij)
            Vij /= r # Vij normal
            # println("Vij normal: $Vij")
            Fij = g * Mi * Mj / r^2
            F = Fij * Vij # now components
            A[i,:] = A[i,:] .- F/Mi
            A[j,:] = A[j,:] .+ F/Mj
        end
    end
    A
end

end # end module

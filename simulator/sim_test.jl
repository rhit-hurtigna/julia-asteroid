include("sim.jl")

using .Simulator

P0 = [0 0 0 ; 150.58e9 0 0]
V0 = [0 0 0 ; 0 30000 0]
M = [1.9891e30 ; 5.97219e24]
g = 6.67430e-11
T = 3.156e+7
dT = T / 10000
dFrame = T / 100

(_, results) = runSim(0, P0, V0, M, g, dT, T, dFrame)

println(results)

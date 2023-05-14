include("../simulator/sim.jl")
using .Simulator
using Plots

# set initial conditions
P0 = [0 0 0 ; 150.58e9 0 100; -150.58e9 0 -100]
V0 = [0 0 0 ; 10000 15000 0; -10000 -15000 0]
M = [1.9891e30 ; 5.97219e24; 5.97219e24]
g = 6.67430e-11
T = 3.156e+7
dT = T / 10000
dFrame = T / 100

# get M x N x 3 matrix of the planets and their coordinates throughout time. See sim.jl for more details.
M = runSim(P0, V0, M, g, dT, T, dFrame)

# get appropriate limits for plot
xmin = minimum(M[:,:,1])
xmax = maximum(M[:,:,1])

ymin = minimum(M[:,:,2])
ymax = maximum(M[:,:,2])

zmin = minimum(M[:,:,3])
zmax = maximum(M[:,:,3])

@userplot PlanetPlot
@recipe function f(pp::PlanetPlot)
    x, y, z, i, j = pp.args
    n = length(x)
    inds = circshift(1:n, 1 - i)
    linewidth --> range(0, 10, length = n)
    seriesalpha --> range(0, 1, length = n)
    aspect_ratio --> 1
    label --> false
    #marker --> j
    x[inds], y[inds], z[inds]
end

# n = 150
# t = range(0, 2π, length = n)
# x = sin.(t)
# y = cos.(t)
# x2 = 2sin.(t)
# y2 = 2cos.(t)

plt = path3d(
    1,
    xlim = (xmin, xmax),
    ylim = (ymin, ymax),
    zlim = (zmin, zmax),
    title = "Planet Simulator",
    legend = false
)


ts = length(M[:,1,1])
N = length(M[1,:,1])

# x = M[:,2,1]
# y = M[:,2,2]
# z = M[:,2,3]

anim = @animate for i ∈ 1:ts
    planetplot!(M[:,2,1], M[:,2,2], M[:,2,3], i, 0)
    # for j = 2:N
    #     x = M[:,j,1]
    #     y = M[:,j,2]
    #     z = M[:,j,3]
    #     planetplot(x, y, z, i, j)
    # end
    # plot!(plt, camera = (i, 20))
end
gif(anim, "anim_fps15.gif", fps = 15)
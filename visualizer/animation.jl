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

# define Planet Struct
Base.@kwdef mutable struct Planet
    x::Float64 = 1
    y::Float64 = 1
    z::Float64 = 1
end


# modify coords of planet by going to next timestep in the M x N x 3 matrix. N will always be the planet index.
function step!(p::Planet, ti, n)
    p.x = M[ti,n,1]
    p.y = M[ti,n,2]
    p.z = M[ti,n,3]
end

planet = Planet()
planet2 = Planet()

# get appropriate limits for plot
xmin = minimum(M[:,:,1])
xmax = maximum(M[:,:,1])

ymin = minimum(M[:,:,2])
ymax = maximum(M[:,:,2])

zmin = minimum(M[:,:,3])
zmax = maximum(M[:,:,3])

ts = length(M[:,1,1])
N = length(M[1,:,1])

planets = Array{Planet, 1}(undef, N)

for i=1:N
    planets[i] = Planet()
end

# initialize a 3D plot with 1 empty series
plt = path3d(
    1,
    xlim = (xmin, xmax),
    ylim = (ymin, ymax),
    zlim = (zmin, zmax),
    title = "Planet Simulator",
    legend = false,
    marker = 1
)

# initialize plots for other planets, changing the marker color each time.
for j=2:N + 1
    path3d!(
        1,
        marker = N
    )
end

# build an animated gif by pushing new points to the plot, saving every frame
anim = @animate for i=1:ts
    for k=1:N
        step!(planets[k],i,k)
        push!(plt, k, planets[k].x, planets[k].y, planets[k].z)
    end

    plot!(plt, camera = (i, 20), )
end every 1

gif(anim, "animations/planet_anim.gif", fps=15);
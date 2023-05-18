module Glue
include("../simulator/sim.jl")
using .Simulator
using Plots
export do_glue

# define Planet Struct
Base.@kwdef mutable struct Planet
    x::Float64 = 1
    y::Float64 = 1
    z::Float64 = 1
end

function do_glue(jobName, asterPosRow, asterVelRow, asterMass,
    start_days_since_2000, end_days_since_2000, numSteps)
    println("do glue")

    # TODO: make the start_days work better
    # each row of P or V is a planet; it's 3 long.
    P0 = [0 0 0 ; 1 0 0; -1 0 0]
    V0 = [0 0 0 ; 0 -0.01719938919 0; 0 0.01719938919 0]
    M = [333060.4016 ; 1; 1]
    # g = 6.67430e-11
    g = 8.887062349e-10 # AU, EM, and days
    T = end_days_since_2000 - start_days_since_2000
    dT = T / numSteps
    dFrame = T / 100

    # ANIMATION START
    # get M x N x 3 matrix of the planets and their coordinates throughout time. See sim.jl for more details.
    M = runSim(P0, V0, M, g, dT, T, dFrame)
    # modify coords of planet by going to next timestep in the M x N x 3 matrix. N will always be the planet index.
    function step!(p::Planet, ti, n)
        p.x = M[ti,n,1]
        p.y = M[ti,n,2]
        p.z = M[ti,n,3]
    end

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

    gif(anim, "glue_anims/$(jobName).gif", fps=15);
end

end

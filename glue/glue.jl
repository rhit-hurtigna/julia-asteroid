module Glue
include("../simulator/sim.jl")
using .Simulator
include("../seth-intiialConditions/use_a_module.jl")
using .InitialConds
using Plots
export do_glue

num_parallel = 300

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
    P0 = getPos(start_days_since_2000)
    V0 = getVel(start_days_since_2000)
    P0 = [0 0 0 ; P0]
    V0 = [0 0 0 ; V0]
    # P0 = [0 0 0 ; 1 0 0; -0.05373818891893653 -0.4617539924365171 -0.032805370560778056]
    # V0 = [0 0 0 ; 0 -0.01719938919 0; (86400*0.0000002587051734295742) (86400*(-0.00000002110837810098687)) (86400*(-0.000000025454787028200698))]
    M = [333060.4016 ; 0.0553; 0.815; 1; 0.107]
    # g = 6.67430e-11
    g = 8.887062349e-10 # AU, EM, and days
    T = end_days_since_2000 - start_days_since_2000
    dT = T / numSteps
    dFrame = T / 100

    # INPUT ASTEROID
    P0 = [asterPosRow ; P0]
    V0 = [asterVelRow ; V0]
    M = [asterMass ; M]

    # ANIMATION START
    # get M x N x 3 matrix of the planets and their coordinates throughout time. See sim.jl for more details.
    (close_dist, M) = runSimMain(num_parallel, P0, V0, M, g, dT, T, dFrame)
    histogram(close_dist)
    savefig("glue_anims/$(jobName)_closeness.png")

    # modify coords of planet by going to next timestep in the M x N x 3 matrix. N will always be the planet index.
    function step!(p::Planet, ti, n)
        p.x = M[ti,n,1]
        p.y = M[ti,n,2]
        p.z = M[ti,n,3]
    end

    # get appropriate limits for plot
    xmin = minimum(M[:,:,1])
    xmax = maximum(M[:,:,1])
    xdel = xmax - xmin
    xmid = (xmin+xmax)/2

    ymin = minimum(M[:,:,2])
    ymax = maximum(M[:,:,2])
    ydel = ymax - ymin
    ymid = (ymin+ymax)/2

    zmin = minimum(M[:,:,3])
    zmax = maximum(M[:,:,3])
    zdel = zmax - zmin
    zmid = (zmin+zmax)/2

    maxdel = maximum([zdel xdel ydel])
    maxrad = maxdel/2
    xmin = xmid - maxrad
    xmax = xmid + maxrad
    ymin = ymid - maxrad
    ymax = ymid + maxrad
    zmin = zmid - maxrad
    zmax = zmid + maxrad

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

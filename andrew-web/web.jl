# https://www.freecodecamp.org/news/how-to-build-web-apps-in-julia/
# ] add genie (Inside the Julia terminal thingy)
using Genie, Genie.Router,Plots, Printf, Base64
using Genie.Renderer, Genie.Renderer.Html, Genie.Renderer.Json, Genie.Requests
using Dates

include("../glue/glue.jl")
using .Glue

# route("/") do
#     html("Hello World")
# end

form = """
<form action="/" method="POST" enctype="multipart/form-data">
  <label for="name">Job name</label>
  <input id='name' type="text" name="name" value="" placeholder="Job name" /><br>
  <label for="mass">Asteroid Mass</label>
  <input id='mass' type="text" min="0" name="mass" value="" placeholder="Asteroid mass" /><br>
  <label for="x">X position</label>
  <input id='x' type="text" name="x" value="" placeholder="Some Starting x" /><br>
  <label for='y'>Y position</label>
  <input id='y' type="text" name="y" value="" placeholder="Some Starting y" /><br>
  <label for="z">Z position</label>
  <input id='z' type="text" name="z" value="" placeholder="Some Starting z" /><br>
  <label for='xs'>X velocity</label>
  <input id='xs' type="text" name="xs" value="" placeholder="Some Starting x velocity" /><br>
  <label for="ys">Y velocity</label>
  <input id='ys' type="text" name="ys" value="" placeholder="Some Starting y velocity" /><br>
  <label for='zs'>Z velocity</label>
  <input id='zs' type="text" name="zs" value="" placeholder="Some Starting z velocity" /><br>
  <label for='start_date'>Simulation start</label>
  <input id='start_date' type="date" name="start" value="" placeholder="Start date" /><br>
  <label for='end_date'>Simulation end</label>
  <input id='end_date' type="date" name="end" value="" placeholder="End date" /><br>
  <label for='steps'>Simulation step count</label>
  <input id='steps' type="number" min="1" name="steps" value="" placeholder="Steps to calculate" /><br>
  <input type="submit" value="Submit" />
</form>
"""

route("/") do
  html(form)
    # open("index.html") do f
    #   html(read(f,String))
    # end
end
#https://www.matecdev.com/posts/julia-structs.html
Base.@kwdef mutable struct Location
    name::String
    mass::Float32
    x::Float32
    y::Float32
    z::Float32
    xs::Float32
    ys::Float32
    zs::Float32
    start_days_since_2000::Int64
    end_days_since_2000::Int64
    steps::Int64
end

#https://genieframework.github.io/Genie.jl/dev/tutorials/12--Advanced_Routing_Techniques.html
route("/", method = POST) do
    location = Location(
    name=postpayload(:name,"0"),
    mass=parseFloat(postpayload(:mass,"0")),
    x=parseFloat(postpayload(:x,"0")),
    y=parseFloat(postpayload(:y,"0")),
    z=parseFloat(postpayload(:z,"0")),
    xs=parseFloat(postpayload(:xs,"0")),
    ys=parseFloat(postpayload(:ys,"0")),
    zs=parseFloat(postpayload(:zs,"0")),
    start_days_since_2000=parseDate(postpayload(:start, "0")),
    end_days_since_2000=parseDate(postpayload(:end, "0")),
    steps=parseInt(postpayload(:steps, "0"))
    )

    html("Calculating the thing...")
    do_glue(location.name, [location.x location.y location.z], 
    [location.xs location.ys location.zs], location.mass, location.start_days_since_2000, 
    location.end_days_since_2000, location.steps)
    # print(location)
    open("glue_anims/$(location.name).gif") do f
        open("glue_anims/$(location.name)_closeness.png") do f2
            data = base64encode(read(f, String))
            data2 = base64encode(read(f2, String))
            html("""<img src="data:andrew-web/anim_fps15.gif;base64,$data"><br><img src="data:andrew-web/anim_fps15.gif;base64,$data2">""")
            # html(read(f,String))
        end
    end
end



function parseFloat(toParse::String)::Float32
    result = tryparse(Float32,toParse)
    if isnothing(result)
        return 0
    end
    return result
end

function parseInt(toParse::String)::Int64
    result = tryparse(Int64,toParse)
    if isnothing(result)
        return 0
    end
    return result
end

function parseDate(toParse::String)::Int64
    date = Date(Dates.DateTime(toParse, "yyyy-mm-dd"))
    reference_date = Date(2000, 1, 1)
    days_since_2000 = Dates.value(date - reference_date)
    return days_since_2000
end

# gr() 
# Base.show(io::IO, f::Float64) = Printf.@printf io "%1.3f" f
# data = rand(14)
# p=Plots.plot(1:14, data)
# open("index.html", "w") do io
#   show(io, data)
#   show(io, "text/html", p)
# end

# @userplot CirclePlot
# @recipe function f(cp::CirclePlot)
#     x, y, i = cp.args
#     n = length(x)
#     inds = circshift(1:n, 1 - i)
#     linewidth --> range(0, 10, length = n)
#     seriesalpha --> range(0, 1, length = n)
#     aspect_ratio --> 1
#     label --> false
#     x[inds], y[inds]
# end

# n = 150
# t = range(0, 2π, length = n)
# x = sin.(t)
# y = cos.(t)

# anim = @animate for i ∈ 1:n
#     circleplot(x, y, i)
# end

# gif(anim, "anim_fps15.gif", fps = 30)




up(8080,async=false)

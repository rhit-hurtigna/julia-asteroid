# https://www.freecodecamp.org/news/how-to-build-web-apps-in-julia/
# ] add genie (Inside the Julia terminal thingy)
using Genie, Genie.Router,Plots, Printf, Base64
using Genie.Renderer, Genie.Renderer.Html, Genie.Renderer.Json, Genie.Requests

# route("/") do
#     html("Hello World")
# end

form = """
<form action="/" method="POST" enctype="multipart/form-data">
  <input type="text" name="test" value="" placeholder="Some Starting Value" />
  <input type="text" name="lat" value="" placeholder="Some Starting lat" />
  <input type="text" name="lon" value="" placeholder="Some Starting lon" />
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
    test::String
    lat::Float32
    lon::Float32
end

#https://genieframework.github.io/Genie.jl/dev/tutorials/12--Advanced_Routing_Techniques.html
route("/", method = POST) do
    location = Location(test=postpayload(:test, "PlaceholderTest"), lat=parseFloat(postpayload(:lat, "0")), lon=parseFloat(postpayload(:lon, "0")))
    # html("Location  $(location.test), $(location.lat), $(location.lon) created successfully!")
    open("andrew-web/anim_fps15.gif") do f
        data = base64encode(read(f, String))
        html("""<img src="data:andrew-web/anim_fps15.gif;base64,$data">""")
        # html(read(f,String))
    end
end



function parseFloat(toParse::String)::Float32
    result = tryparse(Float32,toParse)
    if isnothing(result)
        return 0
    end
    return result
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

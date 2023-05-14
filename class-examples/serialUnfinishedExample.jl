using Distributed

# Run with julia serialUnfinishedExample.jl


#Timer in current release is bugged, counts some setup time so this negates that
#Ignore this
t = @elapsed begin
    true
end
##

nheads = 0
#Below uses the @elapsed macro to measure the time that occurs
#note the i range has 2 less zeroes than the parallel finished example
t = @elapsed begin
      for i = 1:20000000 #@distributed runs the following line in parallel (from for to end)
        global nheads = nheads + Int(rand(Bool)) #Randomly generates int
      end
end

println("Number of heads: $nheads") # dollar sign format to print
println(t)
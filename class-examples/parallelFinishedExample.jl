using Distributed

# Run with julia parallelExample.jl

addprocs(5) #TODO: Change me to see how the speed changes!

#Timer in current release is bugged, counts some setup time so this negates that
#Ignore this
t = @elapsed begin
  true
end
##

#Below uses the @elapsed macro to measure the time that occurs

t = @elapsed begin
    nheads = @distributed (+) for i = 1:2000000000 #@distributed runs the following line in parallel (from for to end)
      Int(rand(Bool)) #Randomly generates int
    end
end

println("Number of heads: $nheads") # dollar sign format to print
println(t)
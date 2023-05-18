include("glue.jl")

using .Glue

do_glue("test_glue", [0 0 1], [0 0.02 0], 0.02,
    0, 365, 10000)

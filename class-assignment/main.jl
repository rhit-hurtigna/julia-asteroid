using Distributed
using Primes
using Test
using Random

Random.seed!(56789)
addprocs(5)

#
# TODO: make this function run in parallel.
# It currently runs in serial.
#
# INPUTS:
# M, N -- positive integers. M < N
#
# OUTPUTS:
# Number of prime numbers in [M, N].
# The bounds include M and N.
#
function count_primes_parallel(M, N)
    num_primes = 0
    for i = M:N
        if isprime(i)
            num_primes += 1
        end
    end
    num_primes # the last value returns in Julia
end

# Don't modify this -- we use it for testing
function count_primes_serial(M, N)
    num_primes = 0
    for i = M:N
        if isprime(i)
            num_primes += 1
        end
    end
    num_primes
end

@testset "prime counting" begin
    for i = 1:10
        M = rand(1:1000)
        N = M + i * rand(1:1000)
        parallel_count = count_primes_parallel(M, N)
        serial_count = count_primes_serial(M, N)
        @test parallel_count == serial_count
    end
end

#
# TODO: make this function run in parallel.
# It currently runs in serial.
#
# INPUTS:
# A, B -- NxN matrices
# N -- positive integer
#
# OUTPUTS:
# C -- NxN matrix, C = A * B
#
function matr_mult_parallel(A, B, N)
    C = zeros(N, N)
    for row_index = 1:N
        for col_index = 1:N
            row_of_A = A[row_index, :]
            col_of_B = B[:, col_index]
            dot_product_of_both = sum(row_of_A .* col_of_B)
            C[row_index, col_index] = dot_product_of_both
        end
    end
    C
end

matrix_mult_results = @testset "matrix multiplication" begin
    for matr_size = ((2:4:20).*2)
        A = rand(matr_size, matr_size)
        B = rand(matr_size, matr_size)

        parallel_C = matr_mult_parallel(A, B, matr_size)
        actual_C = A * B

        @test maximum(abs.(parallel_C - actual_C)) < 1e-4
    end
end

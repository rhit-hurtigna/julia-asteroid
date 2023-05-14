using Distributed
# Run with julia matrixParallelizedExample.jl
matrix1 = [1 2 3 4 
    5 6 7 8
    9 10 11 12
    13 14 15 16]


function matr_column_sum(A)
    numRows,numCols = size(A)
    result = zeros(1,numCols) #makes a matrix of zeroes of this dimension
    result = @distributed (hcat) for col_index = 1:numCols
        sum = 0
        for row_index = 1:numRows
            sum = sum + A[row_index,col_index]
        end
        sum
    end
    result # last value returns in Julia
end

result = matr_column_sum(matrix1)
println("Starting Matrix ")
display(matrix1) #Fancy way to display more info about matrix
println("Sums of Columns: $result") # dollar sign format to print
println("Should be should be [28 32 36 40]") 


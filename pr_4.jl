"1. Написать функцию, вычисляющую n-ю частичную сумму ряда Телора
Маклорена) функции для произвольно заданного значения аргумента x."
function exp_(x, n)  #
    ans = 1.0  # суммы ряда
    t = 1.0  
    for i in 1:n  
        t *= x / i  
        ans += t  
    end
    return ans  
end

A = [1 2; 3 4]
print(A[0])

"4. Реализовать алгорим, реализующий обратный ход алгоритма Жордана-Гауссаusing LinearAlgebra
"
function  reverse_gauss(A::AbstractMatrix{T}, b::AbstractVector{T}) where T
    x = similar(b)
    N = size(A, 1)
    for k in 0:n-1
        x[N-k] = (b[N-k] - sum(A[N-k, N-k+1:end])) .* x[N-k+1:end]/ A[N-k, N-k]
    end
    return x 
end

"5. Реализовать алгоритм, осуществляющий приведение матрицы матрицы к
ступенчатому виду"
function transform_to_steps!(A::AbstractMatrix; epsilon = 1e-7)
    n = size(A)
    for i in 1:n
        return 0 
    end
end

"6. Реализовать алгоритм, реализующий метод Жордана-Гаусса решение СЛАУ для
произвольной невырожденной матрицы (достаточно хорошо обусловленной)."
function solve_sla(A::AbstractMatrix{T}, b::AbstractVector{T}) where T
    Ab = [A b]
    transform_to_steps!(Ab; epsilon = 10sqrt(eps(T)) maximum(abs,A))
    return reverse_gauss(A, b)
end

"8. Написать функцию, возвращающую ранг произвольной прямоугольной матрицы (реализуется на базе приведения матрицы к ступенчатому виду)."
function rank!(matrix::AbstractMatrix{Float64})
    transform_to_steps!(Matrix)
      epsilon = 1e-8
      i = 1
    while abs(matrix[i,i]) > epsilon
        i+=1
    end
    return i-1
  end

"9. Написать функцию, возвращающую определитель произвольной квадратной матрицы (реализуется на основе приведения матрицы к ступенчатому виду)."



"function transform_to_steps!(A::AbstractMatrix; epsilon = 1e-7)
@inbounds for k ∈ 1:size(A, 1)
absval, Δk = findmax(abs, @view(A[k:end,k]))
(absval <= epsilon) && throw()
Δk > 1 && swap!(@view(A[k,k:end]), @view(A[k+Δk-1,k:end]))
for i ∈ k+1:size(A,1)
    t = A[i,k]/A[k,k]
    @. @views A[i,k:end] = A[i,k:end] - t * A[k,k:end]
end
    end
return A
end"

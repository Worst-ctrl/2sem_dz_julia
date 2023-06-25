#4. Реализовать алгоритм сортировки слияниям

function merge_sort(arr)
    if length(arr) <= 1
        return arr
    end
    mid = length(arr) ÷ 2
    left = merge_sort(arr[1:mid])
    right = merge_sort(arr[mid+1:end])
    return merge(left, right)
end

function merge(left, right)
    result = []
    i = 1
    j = 1
    while i ≤ length(left) && j ≤ length(right)
        if left[i] ≤ right[j]
            push!(result, left[i])
            i += 1
        else
            push!(result, right[j])
            j += 1
        end
    end
    while i ≤ length(left)
        push!(result, left[i])
        i += 1
    end
    while j ≤ length(right)
        push!(result, right[j])
        j += 1
    end
    return result
end

#5 - Вычисление медианы массива на основе процедуры Хоара 

function quickselect_median(l::Array{Float64, 1})
    n = length(l)
    if n % 2 == 1
        return quickselect(l, div(n, 2))
    else
        return 0.5 * (quickselect(l, div(n, 2) - 1) +
                      quickselect(l, div(n, 2)))
    end
end

function quickselect(l::Array{Float64, 1}, k::Int)
    n = length(l)
    @assert 1 ≤ k ≤ n
    if n == 1
        @assert k == 1
        return l[1]
    end

    pivot = rand(l)

    lows = [x for x in l if x < pivot]
    highs = [x for x in l if x > pivot]
    pivots = [x for x in l if x == pivot]

    if k ≤ length(lows)
        return quickselect(lows, k)
    elseif k ≤ length(lows) + length(pivots)
        return pivots[1]
    else
        return quickselect(highs, k - length(lows) - length(pivots))
    end

end


#6 - Сортировка Хоара

function quicksort(array)
    if length(array) ≤ 1
        return array
    end
    
    pivot = rand(array) # выбрать случайный элемент в качестве опорного
    left = [x for x in array if x < pivot]
    middle = [x for x in array if x == pivot]
    right = [x for x in array if x > pivot]
    
    return quicksort(left) * middle * quicksort(right) # объединение отсортированных частей
end

#7. Реализовать алгоритм сортировки за линейное время.
function calc_sort!(A::AbstractVector{<:Integer})
    min_val, max_val = extrema(A)
    num_val = zeros(Int, max_val-min_val+1) # - число всех возможных значений
    for val in A
        num_val[val-min_val+1] += 1
    end  
    k = 0
    for (i, num) in enumerate(num_val)
        A[k+1:k+num] .= min_val+i-1
        k += num
    end
    return A
end

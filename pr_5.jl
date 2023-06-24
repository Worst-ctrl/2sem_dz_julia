#вычисления медианы массива на основе процедуры Хоара 

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


#Сортировка Хоара
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


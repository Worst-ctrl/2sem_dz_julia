function next_repit_plasement!(p::Vector{T}, n::T) where
    T<:Integer
    i = findlast(x->(x < n), p) # используется встроенная функция высшего порядка
    # i - это последнийпервый с конца индекс: x[i] < n, или -
    nothing #если такого индекса нет (p == [n,n,...,n])
    isnothing(i) && (return nothing)
    p[i] += 1
    p[i+1:end] .= 1 # - устанавливаются минимально-возможные значения
    return p
end


#все размещения эл мн - ва
for i in 0:n^k-1
    digits(i; base=n, pad=k) |> println
end


function next_permute!(p::AbstractVector)
    n = length(p)
    k = 0 # или firstindex(p)-1
    for i in reverse(1:n-1) # или
        reverse(firstindex(p):lastindex(p)-1)
        if p[i] < p[i+1]
            k=i
            break
        end
    end
    k == firstindex(p)-1 && return nothing # т.е.
    p[begin]>p[begin+1]>...>p[end]
    #УТВ: p[k] < p[k+1] > p[k+2] >...> p[end]
    i=k+1
    while i<n && p[i+1]>p[k] # i < lastindex(p) && p[i+1] >
        p[k]
        i += 1
    end
    #УТВ: p[i] - наименьшее из всех p[k+1:end], большее p[k]
    p[k], p[i] = p[i], p[k]
    #УТВ: по-прежнему p[k+1]>...>p[end]
    reverse!(@view p[k+1:end])
    return p
end

function test1()
    #Тестирование:
    p=[1,2,3,4]
    println(p)
    while !isnothing(p)
    p = next_permute!(p)
    println(p)
    end
end
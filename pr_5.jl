function shell_sort!(
    a; 
    step_series = (length(a)÷2^i for i in 1:Int(floor(log2(length(a))))) 
)
    for step in step_series
        for i in firstindex(a):lastindex(a)-step
            j = i
            while j >= firstindex(a) && a[j] > a[j+step]
                a[j], a[j+step] = a[j+step], a[j]
                j -= step
            end
        end
    end
    return a
end

function shell_sort_alt!(a)
    n = length(a)
    step_series = (n÷2^i for i in 1:Int(floor(log2(n)))) 
    for step in step_series
        for i in firstindex(a):step-1
            insert_sort!(@view a[i:step:end]) # - сортировка вставками выделенного (прореженного) подмассива
        end
    end
    return a
end

function comb_sort!(a; factor=1.2473309)
    step = length(a)
    while step >= 1
        for i in 1:length(a)-step
            if a[i] > a[i+step]
                a[i], a[i+step] = a[i+step], a[i]
            end
        end
        step = Int(floor(step/factor))
    end
    # Теперь массив почти упорядочен, осталось сделать всего несколько итераций внешнего цикла в bubble_sort!(a)
    bubble_sort!(a)
end

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


@inline function Base.merge!(a1, a2, a3)::Nothing # @inline - делает функцию "встраиваемой", т.е. во время компиляции ее тело будет встроено непосредственно в код вызывающей функции (за счет этого происходит экономия на времени, затрачиваемым на вызов функции; это время очень небольшое, но тем не менее)
    i1, i2, i3 = 1, 1, 1
    @inbounds while i1 <= length(a1) && i2 <= length(a2) # @inbounds - передотвращает проверки выхода за пределы массивов
        if a1[i1] < a2[i2]
            a3[i3] = a1[i1]
            i1 += 1
        else
            a3[i3] = a2[i2]
            i2 += 1
        end
        i3 += 1
    end
    @inbounds if i1 > length(a1)
        a3[i3:end] .= @view(a2[i2:end]) # Если бы тут было: a3[i3:end] = @view(a2[i2:end]), то это привело бы к лишним аллокациям (к созданию промежуточного массива)
    else
        a3[i3:end] .= @view(a1[i1:end])
    end
    nothing
end
```

- Алгоритм сортировки слияниями

```julia
function merge_sort!(a)
    b = similar(a) # - вспомогательный массив того же размера и типа, что и массив a
    N = length(a)
    n = 1 # n - текущая длина блоков
    @inbounds while n < N
        K = div(N,2n) # - число имеющихся пар блоков длины n
        for k in 0:K-1
            merge!(@view(a[(1:n).+k*2n]), @view(a[(n+1:2n).+k*2n]), @view(b[(1:2n).+k*2n]))
        end
        if N - K*2n > n # - осталось еще смержить блок длины n и более короткий остаток
            merge!(@view(a[(1:n).+K*2n]), @view(a[K*2n+n+1:end]), @view(b[K*2n+1:end]))
        elseif 0 < N - K*2n <= n # - оставшуюся короткую часть мержить не с чем
            b[K*2n+1:end] .= @view(a[K*2n+1:end])
        end
        a, b = b, a
        n *= 2
    end
    if isodd(log2(n)) # - если цикл был выполнен нечетное число раз, то b - это исходная ссылка на массив (на внешний массив), и a - это ссылка на вспомогательный массив (локальный)
        b .= a # b = copy(a) - это было бы не то же самое, т.к. при этом получилась бы ссылка на новый массив, который создает функция copy
        a = b
    end
    return a # - исходная ссылка на внешний массив (проверить, что это так, можно с помощью ===)
end
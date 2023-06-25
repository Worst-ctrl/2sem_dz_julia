# № 1 Генерация всех размещений с повторениями из n элементов {1,2,...,n} по k
function next_repit_placement!(p::Vector{T}, n::T) where T<:Integer
    i = findlast(x->(x < n), p) # используется встроенная функция высшего порядка
    # i - это последний(первый с конца) индекс: x[i] < n, или - nothing, если такого индекса нет (p == [n,n,...,n])
    isnothing(i) && (return nothing)
    p[i] += 1
    p[i+1:end] .= 1 # - устанавливаются минимально-возможные значения
    return p
end
 
# № 2 Генерация вcех перестановок 1,2,...,n
function next_permute!(p::AbstractVector)
    n = length(p)
    k = 0 # firstindex(p) - 1
    for i in reverse(1:n - 1) # reverse(firstindex(p):lastindex(p) - 1)
        if p[i] < p[i + 1]
            k = i
            break
        end
    end
    k == firstindex(p) - 1 && return nothing # p[begin] > p[begin + 1] > ... > p[end]
 
    #утв: p[k] < p[k + 1] > p[k + 2] > ... > p[end]
    i = k + 1
    while i < n && p[i + 1] > p[k] # i < lastindex(p) && p[i + 1] > p[k]
        i += 1
    end
    #утв: p[i] - наименьшее из p[k + 1:end], большее p[k]
    p[k], p[i] = p[i], p[k]
    #утв: по-прежнему p[k + 1]>...>p[end]
    reverse!(@view p[k + 1:end])
    return p
end
 
# № 3 Генерация всех всех подмножеств n-элементного множества {1,2,...,n}
 
# № 3.1 Первый способ - на основе генерации двоичных кодов чисел 0, 1, ..., 2^n-1
 
indicator(i::Integer, n::Integer) = reverse(digits(Bool, i; base=2, pad=n))
 
# № 3.2 Второй способ - на основе непосредственной генерации последовательности индикаторов в лексикографическом порядке
 
function next_indicator!(indicator::AbstractVector{Bool})
    i = findlast(x->(x==0), indicator)
    isnothing(i) && return nothing
    indicator[i] = 1
    indicator[i+1:end] .= 0
    return indicator 
end
 
println("2 способ")
println(next_indicator!(indicator(12, 5)))
 в
# № 4 Генерация всех k-элементных подмножеств n-элементного множества {1, 2, ..., n}
 
function next_indicator!(indicator::AbstractVector{Bool}, k)
    # в indicator - ровно k единц, остальные - нули, но это не проверяется! (фактически k - не используется)
    i = lastindex(indicator)
    while indicator[i] == 0
        i -= 1
    end
    #УТВ: indic[i] == 1 и все справа - нули(считаем единицы)
    m = 0 
    while i >= firstindex(indicator) && indicator[i] == 1 
        m += 1
        i -= 1
    end
    if i < firstindex(indicator)
        return nothing
    end
    #УТВ: indicator[i] == 0 и справа m > 0 единиц, причем indicator[i + 1] == 1
    indicator[i] = 1
    indicator[i + 1:end] .= 0
    indicator[lastindex(indicator) - m + 2:end] .= 1
    return indicator 
end
 
# № 5 Генерация всех разбиений натурального числа на положительные слагаемые
 
function next_split!(s ::AbstractVector{Int64}, k)
    k == 1 && return (nothing, 0)
    i = k-1 # - это потому что s[k] увеличивать нельзя
    while i > 1 && s[i-1]>=s[i]
        i -= 1
    end
    #УТВ: i == 1 или i - это наименьший индекс: s[i-1] > s[i] и i < k
    s[i] += 1
    #Теперь требуется s[i+1]... - уменьшить минимально-возможным способом (в лексикографическом смысле) 
    r = sum(@view(s[i+1:k]))
    k = i+r-1 # - это с учетом s[i] += 1
    s[(i+1):(length(s)-k)] .= 1
    return s, k
end
 
#Поиск в глубину
# Граф в виде ассоциативного массива: ключи - вершины графа, а значения - списки смежных вершин

function dfs(graph::AbstractDict, start::T) where T <: Integer
    stack = [start]
    push!(stack, start)
    visited = falses(length(graph))
    visited[start] = true
    while !isempty(stack)
        v = pop!(stack)
        for u in graph[v] 
            if !visited[u]
                visited[u] = true
                push!(stack, u)
            end
        end
    end
    return visited
end



#Поиск в ширину
function bfs(graph::Dict{T, Vector{T}}, start::T) where T<:Integer
    queue = Queue{T}()
    enqueue!(queue, start)
    visited = falses(length(graph))
    visited[start] = true
    while !isempty(queue)
        v = dequeue!(queue)
        for u in graph[v] 
            visited[u] = (!visited[u] ? (enqueue!(queue, u); true) : true)
        end
    end
    return visited
end

# Функция проверки графа на связность
function is_connected_graph(graph::AbstractDict) :: Bool
    res = dfs(graph, 1)
    return all(res)
end
println(is_connected_graph(graph1))


# № 8 Функция поиска компонент связности графа.

function find_connectivity_components(graph::AbstractDict, len = length(graph))
    mark = ones(Bool, len)
    ans = []
    for i in 1:len
        if mark[i]
            t = dfs(graph, i)
            push!(ans, t)
            mark[findall(t)] .= false
        else
            push!(ans, Bool[0])
        end
    end    
    return ans
end
 
println(find_connectivity_components(graph1))
 
# № 9 Функция проверки является ли заданный граф двудольным.

function  isDual(graph::AbstractDict, len = length(graph)) :: Bool
    color = fill(-1, len)
    queue = []
    for i in 1:len
        if color[i] != -1 
            continue
        end
        color[i] = 0
        push!(queue, i)
        while !isempty(queue)
            v = popfirst!(queue)
            if !isnothing(findfirst(isequal(color[v]), color[graph[v]]))
                return false 
            end
            found = graph[v][findall(isequal(-1), color[graph[v]])]
            color[found] .= (color[v] + 1) % 2
            append!(queue, found)
        end
    end
    return true
end


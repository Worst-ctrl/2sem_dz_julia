function isnarcissistic(n::Integer)
    m = string(n)
    k = length(m)
    ans = 0
    mass = []
    for i in m
        push!(mass, parse(Int64, i))
    end
    mass = sort(mass)
    for j in k:1:-1
        print(j)
    end
end

for j in 10:1:-1
    print(j)
end
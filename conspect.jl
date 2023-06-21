greet(name,owner) = string("Hello ", name == owner ? "boss" : "guest")

checkforfactor(base, factor) = base % factor == 0

function checkforfactor(base, factor)
    return base % factor == 0
end
  

h(x...) = sum(x) / length(x)

y = (1, 2, 3)
print(h(y...))
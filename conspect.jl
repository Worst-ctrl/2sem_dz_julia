greet(name,owner) = string("Hello ", name == owner ? "boss" : "guest")

checkforfactor(base, factor) = base % factor == 0

function checkforfactor(base, factor)
    return base % factor == 0
end
  

h(x...) = sum(x) / length(x)

y = (1, 2, 3)
print(h(y...))

function human_years_cat_years_dog_years(human_years) 
    for i in 1:human_years
        pass
    end

end

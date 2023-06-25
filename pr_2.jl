"1. Написать обобщенную функцию, реализующую алгоритм быстрого возведения в степень"
function power(a::T, n::Int) where T
    k=n; p=a; t=1
    #ИНВАРИАНТ: p^k * t == a^n
    while k > 0
        if iseven(k)
            k /= 2 
            p = p * p 
        else
            k -= 1 
            t = t * p 
        end
end
    return p
end
# k == 0 => t = a^n

"2. На база этой функции написать другую функцию, возвращающую n-ый член последовательности Фибоначчи (сложность - O(log n))."

function fibonachi(n)
    return power([0 1; 1 1], n)
end

"3. Написать функцию, вычисляющую с заданной точностью log_a x (при произвольном a, не обязательно, что a>1), методом рассмотренном на лекции 
(описание этого метода можно найти также в книке Борисенко Основы программирования - она выложена в нашей группе в телеграм)."

function log_(a, x) # a - основание логарифма, x - число под логарифмом
    z=x; t=1; y=0
    #ИНВАРИАНТ:  x = z^t * a^y
    while z < 1/a || z > a || t > ε 
        if z < 1/a
            z *= a 
            y -= t
        elseif z > a
            z /= a
            y += t 
        elseif t > ε
            t /= 2 
            z *= z 
        end
    end
end
"4. Написать функцию, реализующую приближенное решение уравнения вида f(x)=0 методом деления отрезка пополам (описание метода см. ниже). "

function bisection(func::Function, bounds, eps = 1e - 4) #bounds - отрезок, в пределах кот лежит корень, func - функция
    a, b = bounds
    if func(a) * func(b) > 0
        return nothing
        end
    x0 = (a + b) / 2
    while abs(a - b) >= eps
        if func(a) * func(x0) > 0
            a = x0 #тк корня на отрезке [a, x0] нет, сдвигаем точку a правее
        else b = x0
        end
        return x0
    end
end

"6. Написать обобщенную функцию, реализующую метод Ньютона приьлиженного решения уравнения вида f(x) = 0"

function newtow(func, fprime, fprime2, bounds, eps = 1*2.6 - 4) #func - функция, fprime - первая производная, fprime2 - вторая производная
    a, b = bounds #границы интервала 
    if func(a) * fprime2(a) > 0
        x0 = a
    elseif func(b) * fprime2(b) > 0
        x0 = b
    else return nothing 
    end
    x = x0 - func(x0) / fprime(x0)
    while abs(x - x0) >= eps
        x0 = x - func(x) / fprime(x)
        x = x0 - func(x0) / fprime(x0)
        return x
    end
end

func(x) = x*x*x - 6 * x + 2
fprime(x) = 3*x*x - 6
fprime2(x) = 6*x
print(newtow(func, fprime, fprime2, [-5, 5]))

#1
using LinearAlgebra

VectorXY{T<:Real} = NamedTuple{(:x, :y), Tuple{T,T}}
VectorXY{T<:Real} = NamedTuple{(:x, :y), }

a = VectorXY{Int}((3,2))
b = VectorXY{Int}((1,5))

Base. +(a::VectorXY{T},b::VectorXY{T}) where T = VectorXY{T}(Tuple(a).+Tuple(b))

Base. -(a::VectorXY{T},b::VectorXY{T}) where T = VectorXY{T}(Tuple(a).-Tuple(b))

Base. *(coeff, a::VectorXY{T}) where T = VectorXY{T}(coeff.*Tuple(a))

# norm(a) - длина вектора
LinearAlgebra.norm(a::Vector2D) = norm(Tuple(a))
 
LinearAlgebra.dot(a::VectorXY{T},b::VectorXY{T}) where T = dot(Tuple(a),Tuple(b))
# dot(a,b)=|a||b|cos(a,b) - скалярное произведение

Base. cos(a::VectorXY{T},b::VectorXY{T}) where T = dot(a,b)/norm(a)/norm(b)

xdot(a::VectorXY{T},b::VectorXY{T}) where T = a.x*b.y-a.y*b.x
# xdot(a,b)=|a||b|sin(a,b) - косое произведение

Base. sin(a::VectorXY{T},b::VectorXY{T}) where T = xdot(a,b)/norm(a)/norm(b)

Segment2D{T <: Real} = NamedTuple{(:A, :B), NTuple{2,Vector2D{T}}}

"2. Написать функцию, проверяющую, лежат ли две заданные точки по одну сторону от заданной прямой (прямая задается некоторым содержащимся в ней отрезком). "

is_one(P₁::VectorXY{T}, P₂::VectorXY{T}, A::VectorXY{T}, B::VectorXY{T}) where T = sin(B-A,P₁-A)*sin(B-A,P₂-A)>0 

" 3. Написать функцию, проверяющую, лежат ли две заданные точки по одну сторону от заданной кривой (кривая задается уравнением вида F(x,y) = 0)"
one_side(F::Function, P::Vector2D, Q::Vector2D)::Bool = ( F(P...) * F(Q...) > 0 )

"4. Написать функцию, возвращающую точку пересечения (если она существует) двух заданных отрезков."
is_in(P::Vector2D, s::Segment2D)::Bool = (s.A.x <= P.x <= s.B.x || s.A.x >= P.x >= s.B.x) && (s.A.y <= P.y <= s.B.y || s.A.y >= P.y >= s.B.y)

function intersection(s1::Segment2D{T}, s2::Segment2D{T})::Union{Vector2D{T},Nothing} where T
	A = [s1.B[2]-s1.A[2] s1.A[1]-s1.B[1]
		s2.B[2]-s2.A[2] s2.A[1]-s2.B[1]]
	b = [s1.A[2]*(s1.A[1]-s1.B[1]) + s1.A[1]*(s1.B[2]-s1.A[2])
		s2.A[2]*(s2.A[1]-s2.B[1]) + s2.A[1]*(s2.B[2]-s2.A[2])]
	x,y = A\b
	if isinner((;x, y), s1)==false || isinner((;x, y), s2)==false
		return nothing
	end
	return (;x, y) #Vector2D{T}((x,y))
end

"5. Написать функцию, проверяющую лежит ли заданная точка внутри заданного многоугольника."

function insidepol(point::Vector2D{T},pol::AbstractArray{Vector2D{T}})::Bool where T
	@assert length(pol) > 2
	sum = zero(Float64)
	# Вычислить алгебраическую (т.е. с учетом знака) сумму углов, между направлениями из заданной точки на каждые две сосоедние вершины многоугольника.
	# Далее воспользоваться тем, что, если полученная сумма окажется равнной нулю, то точка лежит вне многоугольника, а если она окажется равной 360 градусам, то - внутри.
	for i in firstindex(polygon):lastindex(pol)
		sum += angle(pol[i] - point, pol[i % lastindex(pol) + 1] - point)
	end
	return abs(sum) > 3.14
end

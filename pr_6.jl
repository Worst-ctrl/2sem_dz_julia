#1
using LinearAlgebra
VectorXY{T<:Real} = NamedTuple{(:x, :y), Tuple{T,T}}

a = VectorXY{Int}((3,2))
b = VectorXY{Int}((1,5))

Base. +(a::VectorXY{T},b::VectorXY{T}) where T = VectorXY{T}(Tuple(a).+Tuple(b))

Base. -(a::VectorXY{T},b::VectorXY{T}) where T = VectorXY{T}(Tuple(a).-Tuple(b))

Base. *(coeff, a::VectorXY{T}) where T = VectorXY{T}(coeff.*Tuple(a))

#Base.norm(a::VectorXY) = sqrt(a[1] * a[1] + a[2] * a[2])
# norm(a) - длина вектора
 
LinearAlgebra.dot(a::VectorXY{T},b::VectorXY{T}) where T = dot(Tuple(a),Tuple(b))
# dot(a,b)=|a||b|cos(a,b) - скалярное произведение

Base. cos(a::VectorXY{T},b::VectorXY{T}) where T = dot(a,b)/norm(a)/norm(b)

xdot(a::VectorXY{T},b::VectorXY{T}) where T = a.x*b.y-a.y*b.x
# xdot(a,b)=|a||b|sin(a,b) - косое произведение

Base. sin(a::VectorXY{T},b::VectorXY{T}) where T = xdot(a,b)/norm(a)/norm(b)

print(dot(a, b))
function [sol] = prod_vect(v1, v2)
    sol(1) = v1(2)*v2(3)-v1(3)*v2(2);
    sol(2) = -(v1(1)*v2(3)-v1(3)*v2(1));
    sol(3) = v1(1)*v2(2)-v1(2)*v2(1);
end


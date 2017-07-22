%valX -> Valores de X evaluados en la ecuación
%valY -> Valores de Y obtenidos de la ecuación con los valores de X
%it   -> Controlador de la iteración para determinar los denominadores. 
%        Aumenta en 1 por cada vuelta.
function [sol] = dif_div(valX, valY, it)
%Caso base: Cuando el tamaño del vector de valores de Y es 1. Por lo tanto
%ya es el último valor a obtener.
if length(valY) == 1
    sol = valY(1);
else
    %newY -> Nuevos valores de Y obtenidos de la diferencia dividida
    newY = zeros(1,length(valY)-1);
    %Ciclo por todos los valores de Y obtenidos en la recursión anterior
    %para obtener los nuevos
    for i = 1 : length(valY)-1
        newY(i) = (valY(i+1) - valY(i))/(valX(i+it)-valX(i));
    end
    %El resultado será la concatenación del primer valor de newY con 
    %el resultado de la siguiente recursión.
    sol = horzcat(newY(1),dif_div(valX, newY, it+1));
end
end
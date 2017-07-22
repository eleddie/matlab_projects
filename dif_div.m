%valX -> Valores de X evaluados en la ecuaci�n
%valY -> Valores de Y obtenidos de la ecuaci�n con los valores de X
%it   -> Controlador de la iteraci�n para determinar los denominadores. 
%        Aumenta en 1 por cada vuelta.
function [sol] = dif_div(valX, valY, it)
%Caso base: Cuando el tama�o del vector de valores de Y es 1. Por lo tanto
%ya es el �ltimo valor a obtener.
if length(valY) == 1
    sol = valY(1);
else
    %newY -> Nuevos valores de Y obtenidos de la diferencia dividida
    newY = zeros(1,length(valY)-1);
    %Ciclo por todos los valores de Y obtenidos en la recursi�n anterior
    %para obtener los nuevos
    for i = 1 : length(valY)-1
        newY(i) = (valY(i+1) - valY(i))/(valX(i+it)-valX(i));
    end
    %El resultado ser� la concatenaci�n del primer valor de newY con 
    %el resultado de la siguiente recursi�n.
    sol = horzcat(newY(1),dif_div(valX, newY, it+1));
end
end
%x    -> Valor de x a examinar en la ecuaci�n final
%valX -> Valores de X evaluados en la ecuaci�n
%valY -> Valores de Y obtenidos de la ecuaci�n con los valores de X
function [] = interpolacion(x, valX, valY)
clc
%dif -> Vector con los valores superiores de las diferencias divididas
dif = horzcat(valY(1), dif_div(valX, valY, 1));
%eqn -> Variable donde se guardar� la ecuaci�n final en funci�n de X
eqn = '';
for i = 1 : length(valY)
    %a -> Valor actual de los resultados de las diferencias divididas.
    a = int2str(dif(i));
    %Si el valor es mayor a 0 se le a�ade el signo m�s "+"
    if a == '0'
        continue;
    %Si es cero se salta la iteraci�n
    elseif dif(i) > 0
        a = strcat('+',a);
    end
    %Se concatena el valor anterior de "eqn" con el nuevo valor de "a"
    eqn = strcat(eqn,a);
    %Ciclo para a�adir los factores (X-Xj)
    for j = 1 : i-1
        xval = int2str(valX(j));
        if valX(j) > 0
            xval = int2str(-1*valX(j));
        elseif valX(j) < 0
            xval = strcat('+',int2str(-1*valX(j)));
        elseif valX(j) == 0
            xval = '';
        end
        eqn = strcat(eqn,'*(X',xval,')');
    end
end
fprintf('P(x) = %s\n',eqn);
expr = strrep(eqn,'X',int2str(x));
sol = eval(expr);
fprintf('P(%d) = %d\n',x,sol);
end
clc
clear
sist = load('mat.txt');
s = size(sist);
n = s(1);
if (n ~= s(2)-1)
    disp 'La matriz no es cuadrada';
    return;
end
sist
%Dezplazar la matriz para despejar
for i = 1 : n
    for desp = 1 : i - 1
        for j = 1 : n - 1
            tempPos = sist(i,j);
            sist(i,j) = sist(i, j+1);
            sist(i, j+1) = tempPos;
            
        end
    end
    f = sist(i,:);
    sist(i,:) = [f(1) (f(2:n) * -1) f(n+1)];
end
for i = 1 : n
    sist(i,:) = sist(i,:) / sist(i,1);
end
%Comenzar iteraciones
error = 1;
variables = zeros(1,n);
tempVariables = zeros(1,n);
while error > 1e-16
    variables = tempVariables;
    for i = 1 : n
        sumaFila = sist(i,n+1);
        for j = 2 : n
            verificadorPosicion = i + j - 1;
            if verificadorPosicion <= n
                posVariable = verificadorPosicion;
            else
                posVariable = verificadorPosicion - n;
            end
            sumaFila = sumaFila + sist(i,j) * variables(posVariable);
        end
        tempVariables(i) = sumaFila;
    end
    error = max(abs(tempVariables-variables));
end
variables
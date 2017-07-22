clc
sist = load('mat.txt');
s = size(sist);
n = s(1);
if (n ~= s(2)-1)
    disp 'La matriz no es cuadrada';
    return;
end
sist
for i = 1 : n-1
    fMayor = 0;
    dMayor = 0;
    for j = i : n
        if abs(sist(j,i)) > dMayor
            dMayor = abs(sist(j,i));
            fMayor = j;
        end
    end
    if fMayor == 0
        disp 'No existe solucion unica';
        break;
    end
    fila_mayor = sist(i,:);
    sist(i,:) = sist(fMayor,:);
    sist(fMayor,:) = fila_mayor;
    
    for j = i+1:n
        m = sist(j,i)/sist(i,i);
        sist(j,:) = sist(j,:) - m*sist(i,:);
    end
    
end
if sist(n,n) == 0
    disp ('No existe solucion unica');
    return;
end
result = zeros(1,n);
result(n) = sist(n,n+1)/sist(n,n);
for i = n-1:-1:1
    sum = 0;
    for j = i+1:n
        sum = sum + sist(i,j)*result(j);
    end
    result(i) = (sist(i,n+1) - sum)/sist(i,i);
end
result
clear
function [ rest ] = granM( vfo, rest, maximizar )
clc
syms M; fo = 0; X = []; R = []; S = [];

%R, S
vars2add = zeros(length(rest(:,1)),2);

%Se le anaden variables 'Xn' a la funcion objetivo de entrada
for i=1:length(vfo)
    X = [X sym(strcat('x',num2str(i)))];
    fo = fo + vfo(i)*X(i);
end

%cantidad de variables S y R hasta el momento para anadir a las
%restriciones
cantR = 0;
cantS = 0;

for i=1:length(rest(:,1))
    current = rest(i,:);
    operator = current(length(current));
    current = current(1:length(current)-1);
    if operator == 1%Si el operador es '='
        cantR = cantR + 1;
        vars2add(i,1) = cantR;
        %Se anade una variable R
        R = [R sym(strcat('r',num2str(length(R)+1)))];
        %Se le anaden las variables X a las restricciones de entrada, las
        %variables R y se coloca la igualdad en la ultima posicion
        current = [X.*current(1:length(current)-1) R(length(R)) current(length(current))];
        %Se coloca el primer termino del vector como la expresion
        %matematica y el segundo como la igualdad
        %Ej --> [3x,2y,R1,3] --> [3x+2y+R1,3]
        current = [sum(current(1:length(current)-1)) current(length(current))];
        %Se despeja la R ingresada y se reemplaza en la funcion objetivo
        fo = fo - maximizar * M * solve(eq(current(1),current(2)), R(length(R)));
    elseif operator == 2%Si el operador es '>='
        cantR = cantR + 1;
        cantS = cantS + 1;
        vars2add(i,1) = cantR;
        vars2add(i,2) = -cantS;
        %Se anade una variable R
        R = [R sym(strcat('r',num2str(length(R)+1)))];
        %Se anade una variable S
        S = [S sym(strcat('s',num2str(length(S)+1)))];
        %Se le anaden las variables X a las restricciones de entrada, las
        %variables R, las variables S y se coloca la igualdad en la ultima posicion
        current = [X.*current(1:length(current)-1) -S(length(S)) R(length(R)) current(length(current))];
        %Se coloca el primer termino del vector como la expresion
        %matematica y el segundo como la igualdad
        %Ej --> [3x,2y,R2,S1,3] --> [3x+2y+R1+S1,3]
        current = [sum(current(1:length(current)-1)) current(length(current))];
        %Se despeja la R ingresada y se reemplaza en la funcion objetivo
        fo = fo - M * solve(eq(current(1),current(2)), R(length(R)));
    else%Si el operador es '<='
        cantS = cantS + 1;
        vars2add(i,2) = cantS;
        %Se anade una variable S
        S = [S sym(strcat('s',num2str(length(S)+1)))];
    end
end

r2add = zeros(length(vars2add(:,1)),cantR);
s2add = zeros(length(vars2add(:,1)),cantS);
for i=1:length(vars2add(:,1))
    modifier = 1;
    if vars2add(i,1) > 0
        r2add(i,vars2add(i,1)) = 1;
    end
    if vars2add(i,2) < 0
        modifier = -1;
        vars2add(i,2) = -vars2add(i,2);
    end
    if vars2add(i,2) > 0
        s2add(i,vars2add(i,2)) = modifier*1;
    end
end

rest(:,length(rest(1,:))) = [];
igualdad = rest(:,length(rest(:,1)));
rest(:,length(rest(1,:))) = [];
rest = [rest s2add r2add igualdad];

%Hace factor comun en la funcion objetivo con respecto a las variables
%principales
for i=length(X):-1:1
    if i <= length(S)
        fo = collect(fo,S(i));
    end
    fo = collect(fo,X(i));
end

%Separa el factor comun en elementos por "+" y "-" y los coloca en un arreglo
%Ej: 3x+4y-5m --> [3x,4y,-5m]
cfo = children(fo);
cfo = [cfo(1) children(cfo(2))];

%Cantidad de variables S que tiene la funcion objetivo
cantS = 0;

%Ordena la funcion objetivo para que las variables principales queden de
%primero, luego las variables S y por ultimo el termino independiente
for i=1:length(cfo)
    var = symvar(cfo(i),1);%Obtiene la variable de interes del elemento actual
    if var == M
        %Si la variable es la M (termino independiente) lo coloca de ultimo
        %en el arreglo
        fom(length(cfo)) = cfo(i);
    elseif strfind(char(var),'x') == 1%Si la variable es X, coloca el elemento en la
        %posicion del numero de la variable. Ej X1 --> Posicion 1
        index = str2num(strtok(char(var),'x'));
        fom(index) = cfo(i)/var;
    elseif strfind(char(var),'s') == 1%Si la variable es S, coloca el elemento en la
        %posicion del numero de la variable mas las variables principales.
        %Ej S1 --> Posicion 1 + cantidad de variables principales
        index = length(vfo) + str2num(strtok(char(var),'s'));
        fom(index) = cfo(i)/var;
        cantS = cantS+1;
    end
end
%Se anaden los coeficientes de las variables S (que faltan) y R.
fom = [fom(1:length(fom)-1) zeros(1,length(S)-cantS) zeros(1,length(R)) 0];

%----------------Comienzo del simplex------------------
bigValueM = 1e+10;
z = -fom;
vectorT = vpa(zeros(1, length(rest(:,1))));
%vectorTnombre=[3,4,5,6];
if maximizar == 1
    minOrMax = min(subs(z,bigValueM));
    menorZ = find(subs(z,bigValueM)==minOrMax,1);
    condicion = subs(z(menorZ),bigValueM) < 0;
else
    minOrMax = max(subs(z,bigValueM));
    menorZ = find(subs(z,bigValueM)==minOrMax,1);
    condicion = subs(z(menorZ),bigValueM) > 0;
end

while condicion
    vectorSale = rest(:,length(rest))' ./ rest(:,menorZ)';
    menorVSale = find(vectorSale(:)==min(vectorSale));
    vectorT(menorVSale) = fom(menorZ);
    %vectorTnombre(menorVSale) = menorZ;
    rest(menorVSale,:) = rest(menorVSale,:) / rest(menorVSale, menorZ);
    rest(menorVSale,isnan(rest(menorVSale,:))) = 0;
    for i = 1 : length(rest(:,1))
        if i == menorVSale
            continue;
        end
        rest(i,:) = rest(i,:) - (rest(menorVSale,:) * rest(i, menorZ));
    end
    for i=1 : length(fom)
        sumaCol = sum(vectorT .* rest(:,i)');
        z(i) = sumaCol - fom(i);
    end
    if maximizar == 1
        minOrMax = min(subs(z,bigValueM));
        menorZ = find(subs(z,bigValueM)==minOrMax,1);
        condicion = subs(z(menorZ),bigValueM) < 0;
    else
        minOrMax = max(subs(z,bigValueM));
        menorZ = find(subs(z,bigValueM)==minOrMax,1);
        condicion = subs(z(menorZ),bigValueM) > 0;
    end
end

end
%Elabore una funcion que permita obtener el punto de maximizacion
%recibiendo el vector de la funcion objetivo, cuatro restricciones
%y la cantidad de variables

%Objetivo:      f1A + f2B  0 0 0 0 = N
%Restriccion1:  f1A + f2B > N
%Restriccion3:  3A + 2B > 1
%(3 2 1)
%1 2 0
%1 3 18
%1 1 8
%2 1 14


function [mat] = maximizar(objetivo, rest1, rest2, rest3, rest4, cantVar)
clc
objetivo = [objetivo(1:length(objetivo)-1) zeros(1, cantVar) objetivo(length((objetivo)))];
%objetivoNombre = {'P1','P2','T1','T2','T3','T4'};
objetivoNombre = {'P1','P2','T1','T2','T3','T4'};
rest1 = [rest1(1:length(rest1)-1) 1 0 0 0 rest1(length((rest1)))];
rest2 = [rest2(1:length(rest2)-1) 0 1 0 0 rest2(length((rest2)))];
rest3 = [rest3(1:length(rest3)-1) 0 0 1 0 rest3(length((rest3)))];
rest4 = [rest4(1:length(rest4)-1) 0 0 0 1 rest4(length((rest4)))];

mat = [rest1; rest2; rest3; rest4];
objetivoMod = -objetivo;
vectorT = zeros(1, cantVar);
vectorTnombre=[3,4,5,6];
menorFOM = find(objetivoMod(:)==min(objetivoMod));
while objetivoMod(menorFOM) < 0
    vectorSale = mat(:,length(mat))' ./ mat(:,menorFOM)';
    menorVSale = find(vectorSale(:)==min(vectorSale));
    vectorT(menorVSale) = objetivo(menorFOM);
    vectorTnombre(menorVSale) = menorFOM;
    mat(menorVSale,:) = mat(menorVSale,:) / mat(menorVSale, menorFOM);
    mat(menorVSale,isnan(mat(menorVSale,:))) = 0;
    for i = 1 : cantVar
        if i == menorVSale
            continue;
        end
        mat(i,:) = mat(i,:) - (mat(menorVSale,:) * mat(i, menorFOM));
    end
    mat(4,:) = zeros(1,length(objetivo));
    for i=1 : length(objetivo)
        sumaCol = sum(vectorT .* mat(:,i)');
        objetivoMod(i) = sumaCol - objetivo(i);
    end
    menorFOM = find(objetivoMod(:)==min(objetivoMod));
end
fprintf('%s = %d\n',char(objetivoNombre(vectorTnombre(1))) ,fix(mat(1,length(mat))));
fprintf('%s = %d\n',char(objetivoNombre(vectorTnombre(2))) ,fix(mat(2,length(mat))));
fprintf('%s = %d\n',char(objetivoNombre(vectorTnombre(3))) ,fix(mat(3,length(mat))));
fprintf('%s = %d\n',char(objetivoNombre(vectorTnombre(4))) ,fix(mat(4,length(mat))));
end
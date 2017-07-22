function [solucion]=metodo_jacobi_EASG(M,E)
%M = load('mat.txt');
%E = 1e-8;
clc;
q = char(39);
s = size(M);
n = s(1);
D = zeros(1,n);
error = 100;
for i = 1 : n
    eval(strcat('x',int2str(i),' = D(',int2str(i),');'));
end
k=0;
fprintf('Iteracion\t Variables\n');
while k<1000
    k = k + 1;
    for i = 1 : n
        ecuacion = strcat(int2str(M(i,n+1)),' - (');
        for j = 1 : n
            if i ~= j
                ecuacion = strcat(ecuacion,'+ M(',int2str(i),',',int2str(j),') * D(',int2str(j),')');
            end
        end
        ecuacion = strcat('(',ecuacion,'))/M(',int2str(i),',',int2str(i),')');
        ecuacion = strcat('x',int2str(i),' = ',ecuacion,';');
        eval(ecuacion);
        cond = strcat('if error > x',int2str(i), '- D(',int2str(i),') error = x',int2str(i), '- D(',int2str(i),'); end');
        eval(cond);
    end
    
    iteracion = strcat(int2str(k),'\t\t%9.6f');
    vars = '';
    for i = 1 : n
        eval(strcat('D(',int2str(i),') = x',int2str(i),';'));
        vars = strcat(vars,',x',int2str(i));
        iteracion = strcat(iteracion, '\t%9.6f');
    end
    iteracion = strcat(q,iteracion,q,vars);
    it = strcat('fprintf(',iteracion,')');
    fprintf('\n');
    eval(it);
    if error< E
        k = 1000;
    end
    
end
solucion = D;
end
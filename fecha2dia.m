function [ diaSemana ] = fecha2dia( dia, mes, ano )
clc
total = 0;
siglos = [5 3 1 0 -2];
meses = [6 2 2 5 0 3 5 1 4 6 2 4];
if mod(ano,4) == 0 && mod(ano,100) > 0 || mod(ano,400) == 0
    if mes <= 2
        total = -1;
    end
end
valSiglo = siglos(mod(fix(ano/100),10) - 6);
anoMSiglo = ano - fix(ano/100) * 100;
totAno = fix(1/4 * anoMSiglo) + anoMSiglo;
total = total + valSiglo + meses(mes) + dia + totAno;
diaSemana = mod(total,7);
end
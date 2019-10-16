function [A] = diff_finies(A)
% Fonction différente
% i : lignes; j : colonnes
% on traite les cas particuliers dans la fonction

copyA=A;

for i=1:25
    for j=1:20
        A(i,j)=valdiff(copyA,i,j);
    end
end
end


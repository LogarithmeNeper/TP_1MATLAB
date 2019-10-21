%Méthode de Gauss-Seidel pour résoudre AX = B avec X l'inconnue
%
% Expression en LaTeX: x_i^{(m+1)}=\frac{b_i - \sum_{j=1}^{i-1} a_{ij} x_j^{(m+1)} - \sum_{j=i+1}^{n} a_{ij} x_j^{(m)}}{a_{ii}}
%
function [X] = gauss_seidel(A, B, X0, it)

    %Matrice triangulaire inférieure L + matrice diagonale D dans A = D + L + U
    M = tril(A);
    %X0 de départ quelconque
    X = X0;
    
    if(~conditions_initiales(A, M))
       fprintf("Conditions initiales non valides, la méthode de Gauss-Seidel ne peut pas converger.\n");
       return
    end
    
    n = size(X0,1);
    
    %Le X de l'itération précédente
    Xk = X;
    
    for k=1:it
        for i=1:n
            
            s = 0;
            
            for j=1:n
                if(j < i)
                    s = s + A(i, j) * X(j);
                elseif(j > i)
                    s = s + A(i, j) * Xk(j);
                end
            end
            
            X(i) = (B(i) - s) / A(i, i);
        end
        
        Xk = X;
    end

end


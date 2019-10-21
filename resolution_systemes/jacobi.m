%Méthode de Jacobi pour résoudre AX = B avec X l'inconnue
%
% Expression en LaTeX: x_i^{(m+1)}=\frac{b_i - \sum_{\substack{j=1 \\ j \neq i}}^{n} a_{ij} x_j^{(m)} }{a_{ii}}
%
function [X] = jacobi(A, B, X0, nb_iterations)
    
    %Matrice diagonale D dans A = D + L + U
    M = diag(diag(A));
    %X0 de départ quelconque
    X = X0;
    
    if(~conditions_initiales(A, M))
       fprintf("Conditions initiales non valides, la méthode de Jacobi ne peut pas converger.\n");
       return
    end
    
    n = size(X0,1);
    
    %Le X de l'itération précédente
    Xk = X;
    
    for k=1:nb_iterations
        for i=1:n
            
            s = 0;
            
            for j=1:n
                if(j ~= i)
                    s = s + A(i, j) * Xk(j);
                end
            end
            
            X(i) = (B(i) - s) / A(i, i);
        end
        
        Xk = X;
    end

end


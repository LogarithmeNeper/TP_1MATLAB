%Méthode de Relaxation pour résoudre AX = B avec X l'inconnue
%
% Expression en LaTeX: x_i^{(m+1)}=x_i^{(m)}+\omega*\frac{b_i - \sum_{j=1}^{i-1} a_{ij} x_j^{(m+1)} - \sum_{j=i+1}^{n} a_{ij} x_j^{(m)}}{a_{ii}}
%
function [X] = relaxation(A, B, X0, epsilon)
    
    %Matrice triangulaire inférieure L + matrice diagonale D dans A = D + L + U
    M = tril(A);
    %X0 de départ quelconque
    X = X0;
    
    w = omega_optimal(A);
    
    if(w <= 0 || w >= 2)
       fprintf("Conditions initiales non valides, on s'arrête ici.\n");
       return
    end
    
    n = size(X0,1);
    
    %Le X de l'itération précédente
    Xk = X;
    
    while(1)
        
        for i=1:n
            s = 0;
            
            for j=1:n
                if(j < i)
                    s = s + A(i, j) * X(j);
                elseif(j >= i)
                    s = s + A(i, j) * Xk(j);
                end
            end
            
            X(i) = Xk(i) + w / A(i, i) * (B(i) - s);
        end
        
        if(abs(A * X - B) <= epsilon)
            return;
        end
        
        Xk = X;
        
    end

end


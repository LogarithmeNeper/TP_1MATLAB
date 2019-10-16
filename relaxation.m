function [X] = relaxation(A, B, X0, it)
    
    M = tril(A);
    X = X0;
    
    if(~conditions_initiales(A, M))
       fprintf("Conditions initiales non valides, on s'arrête ici.\n");
       return
    end
    
    w = omega_optimal(A);
    
    n = size(X0,1);
    
    %Le X de l'itération précédente
    Xk = X;
    
    for k=1:it
        
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
        
        Xk = X;
        
    end

end


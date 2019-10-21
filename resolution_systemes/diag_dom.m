function [ Y ] = diag_dom( X )
    
    Y = 1;
    
    %On parcourt les lignes
    for i=1:size(X, 1)
        
        %Somme de la ligne i
        sommeLigne = sum(abs(X(i,:)));
        %Coeff sur la diagonale
        coeffDiag = abs(X(i,i));
        
        if( coeffDiag <= sommeLigne - coeffDiag )
            Y = 0;
            return
        end
    end
end


function [w] = omega_optimal(A)

    D=diag(diag(A));
    L=tril(A) - D;
    U=triu(A) - D;

    %On optimise la valeur de omega
    %Pour avoir convergence il faut 0 < omega < 2
    minR = 9999;
    
    for w_i=0:0.01:2
        PI=inv(D+w_i*L)*((1-w_i)*D-w_i*U);
        r = rayon_spectral(PI);
        if(r < minR)
            minR = r;
            w = w_i;
        end
    end

end


function [ rho ] = rayon_spectral( X )

    rho = 0;
    vp = eig(X);
    
    %On parcourt les valeurs propres
    for i=1:size(vp,1)
        %On prend la norme max
        rho = max(rho, norm(vp(i, 1)));
    end
    
end


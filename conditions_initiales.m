function [X] = conditions_initiales(A, M)
    N = M-A;
    PI = inv(M) * N;
    %fprintf('Diagonale dominante ? %d\n', diag_dom(A));
    %fprintf('Rayon spectral < 1 ? %d\n', rayon_spectral(PI) < 1);
    X = diag_dom(A) && rayon_spectral(PI);
end


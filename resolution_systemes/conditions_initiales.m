%Retourne vrai ou faux selon si les conditions initiales sont respectées
% - A est inversible
% - A est une matrice à diagonale strictement dominante
% - Le rayon spectral de la matrice PI est strictement inférieur à 1
function [X] = conditions_initiales(A, M)
    N = M-A;
    PI = inv(M) * N;
    X = det(A) ~= 0 && diag_dom(A) && rayon_spectral(PI);
end


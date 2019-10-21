%Pour traiter le problème du chauffage de la plaque par l'intermédiaire des deux groupes de
%quatre points (I,J,K,L) et (M,N,O,P), on fera évoluer la température de la plaque pendant une
%unité de temps (ce qui fera diminuer la température des deux groupes de quatre points
%(I,J,K,L) et (M,N,O,P). On simulera ensuite le chauffage en remettant ces points à 500°C et
%on recommencera l'opération autant de fois qu'il le faut pour que l'équilibre soit atteint.

clc;
clear;

A = generer_matrice_laplacien();
U = generer_plateau_initial();

fprintf("Calcul de l'équilibre...\r\n")

t = 0;
dt = 1; %en secondes
epsilon = 10e-8;

while(1)
    %On passe deux unités de temps (évolution libre + chauffage)
    t = t + dt;
    
    %Evolution libre de la température
    prevU = U;
    U = expm(A * dt) * U;
    
    %Chauffage des points IJKL et MNOP
    U = reshape(U, [20 25]);
    % Points chauds IJKL à 500°
    U(5:6, 21:22) = 500;
    % Points chauds MNOP à 500°
    U(15:16, 10:11) = 500;
    U = reshape(U, [500 1]);
    
    dU = U - prevU;
    
    if(abs(dU / dt) < epsilon)
        break;
    end
end

fprintf("Equilibre atteint après %.2f secondes, précision de %e°C.\r\n", t, epsilon)
fprintf("Ordre de grandeur: %.2e secondes.\r\n", 10^round(log10(t)))
fprintf("Température à l'équilibre %.2f°C\r\n", max(U))

fprintf("Lancement de l'animation...\r\n")
U = generer_plateau_initial();
animer_graphique(A, U, dt, t, 10)

% ===================================================== %
%                                                       %
%                                                       %
%           ENSEMBLE DES METHODES UTILITAIRES           %
%                                                       %
%                                                       %
% ===================================================== %

% ================================================================
%   Dessine et anime la matrice U sous forme de graphique coloré
% ================================================================
function animer_graphique(A, U, dt, t, vitesse)
figure(1);
s = surf(reshape(U, [20 25]), 'FaceColor', 'interp');
title(sprintf("Simulation de la répartition de la chaleur au cours du temps\r\n(t=%.2fs, accéléré x%.1f)",  0, vitesse));
xlabel('X');
ylabel('Y');
xlim([1 25]);
ylim([1 20]);
zlabel('Température');
view(2);
set(gca, 'Ydir', 'reverse');
colormap(jet);
colorbar();

for i=0:dt:t
    title(sprintf("Simulation de la répartition de la chaleur au cours du temps\r\n(t=%.2fs/%.2fs, accéléré x%.1f)",  i, t, vitesse));
    U = expm(A * dt) * U;
    M = reshape(U, [20, 25]);
    set(s, 'ZData', M);
    drawnow
    pause(dt / vitesse);
end

end

% ============================================
%   Génère le plateau dans son état initial
% ============================================
function [U] = generer_plateau_initial()
U = zeros(20, 25);

U = reshape(U, [20 25]);
% Points chauds IJKL à 500°
U(5:6, 21:22) = 500;
% Points chauds MNOP à 500°
U(15:16, 10:11) = 500;

%On transforme le plateau en vecteur colonne
U = reshape(U, [500, 1]);
end


% =================================================
%   Génère la matrice du Laplacien de température
% =================================================
function [A] = generer_matrice_laplacien()
A = zeros(500, 500);

%On parcourt les lignes de la matrice
for i=1:500
    %Coordonnées sur le plateau (20x25)
    [i1, j1] = indiceVersCoords(i);
    
    nbVoisins = 0;
    
    %On parcourt les colonnes de la matrice pour appliquer un coeff
    %pour prendre en compte les voisins
    for j=1:500
        [i2, j2] = indiceVersCoords(j);
        v = voisins(i1, j1, i2, j2);
        nbVoisins = nbVoisins + v;
        A(i, j) = v;
    end
    
    A(i, i) = -nbVoisins;
    
end
end

% =========================================================================
%Renvoie les coordonnées de l'intersection correspondant a l'indice donnee
%en parametre.
%Les intersections sont listées colonnes par colonnes, ainsi
%l'intersection 1 correspond aux coords (j=1, i=1), l'intersection 2
%correspond aux coords (j=1, i=2).
% =========================================================================
function [i, j] = indiceVersCoords(indice)
i = mod(indice - 1, 20) + 1;
j = floor((indice - 1) / 20) + 1;
end

% ===========================================================================
%Retourne vrai si les deux intersections (i1, j1) et (i2, j2) sont voisines
% ===========================================================================
function [b] = voisins(i1, j1, i2, j2)

b = 0;

delta_i = abs(i1 - i2);
delta_j = abs(j1 - j2);

%---------------------------------------
%On gère le cas général, les intersections adjacentes
%---------------------------------------

%On vérifie que les intersections sont côte à côte, l'expression équivalente à
%un xor évite de prendre les diagonales en compte
if((delta_i == 1 && delta_j == 0) || (delta_i == 0 && delta_j == 1))
    b = 1;
end

%---------------------------------------
%On gère les cas particuliers
%---------------------------------------

%Raccord entre la partie en haut à gauche et la ligne en pointillés
if(((j1 == 1 && j2 == 19) || (j2 == 1 && j1 == 19)) && i1 > 1 && i1 <= 10 && i1 == i2)
    b = 1;
    %Raccord entre la partie bas à gauche et la partie bas à droite
elseif(((j1 == 1 && j2 == 25) || (j1 == 25 && j2 == 1)) && i1 >= 11 && i1 == i2)
    b = 1;
    %Rainure au milieu du terrain
elseif(((i1 == 10 && i2 == 11) || (i1 == 11 && i2 == 10)) && j1 <= 12 && j1 == j2)
    b = 0;
end

end
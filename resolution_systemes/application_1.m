%Dans ce problème on impose une température aux bords à 100°C et des
%points chauds IJKL et MNOP à 500°C. Ces températures ne varient pas
%On cherche l'équilibre, càd le moment où tout point correspond à la
%moyenne de ses voisins d'après l'expression du Laplacien de la température.

clc;
clear;

A = generer_matrice_laplacien();
U = generer_plateau_initial();

epsilon = 10e-8;
X0 = zeros(500, 1);

%On résout AX = U de manière itérative
X = relaxation(A, U, X0, epsilon);

tracer_graphique(X);

% ===================================================== %
%                                                       %
%                                                       %
%           ENSEMBLE DES METHODES UTILITAIRES           %
%                                                       %
%                                                       %
% ===================================================== %

% =======================================================
%   Dessine la matrice U sous forme de graphique coloré
% =======================================================
function tracer_graphique(U)
    figure(1);
    surf(reshape(U, [20 25]), 'FaceColor', 'interp');
    title("Graphique de l'équilibre du système thermique");
    xlabel('X');
    ylabel('Y');
    xlim([1 25]);
    ylim([1 20]);
    zlabel('Température');
    view(2);
    set(gca, 'Ydir', 'reverse');
    colormap(jet);
    colorbar();
end

% ============================================
%   Génère le plateau dans son état initial
% ============================================
function [U] = generer_plateau_initial()
    U = zeros(20, 25);

    %On met tous les bords à 100°C
    U(1,:) = 100;
    U(20,:) = 100;
    U(1:11, 25) = 100;
    U(10, 1:13) = 100;
    U(11, 1:13) = 100;

    % Points chauds IJKL à 500°
    U(5:6, 21:22) = 500;
    % Points chauds MNOP à 500°
    U(15:16, 10:11) = 500;

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
        
        %Cas des bordures où il n'y a aucune variation de
        %température
        if(i1 == 1 || i1 == 20 || (i1 <= 11 && j1 == 25) || (i1 == 10 && j1 <= 13) || (i1 == 11 && j1 <= 13))
            A(i, i) = 1;
        %Cas des points chauds IJKL où du/dt=0 car il n'y a aucune variation de
        %température
        elseif((i1 == 5 && j1 == 21) || (i1 == 6 && j1 == 21) || (i1 == 5 && j1 == 22) || (i1 == 6 && j1 == 22))
              A(i, i) = 1;
        %Cas des points chauds MNOP où du/dt=0 car il n'y a aucune variation de
        %température
        elseif((i1 == 15 && j1 == 10) || (i1 == 15 && j1 == 11) || (i1 == 16 && j1 == 10) || (i1 == 16 && j1 == 11))
              A(i, i) = 1;
        %Cas des cases standards
        else
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
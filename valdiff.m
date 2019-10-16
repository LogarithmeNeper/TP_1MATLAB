function [valeur] = valdiff(A,i,j)
%On a Du=0 donc avec les différences finies on
%exprime la valeur de A(i,j) fonction des temp.
%précédentes
% Cas particuliers compris.

casPart=0;

%premiere ligne
if(i==1)
    casPart=1;
    if(j==1)
        valeur=(A(i+1,j)+A(i,j+1)+A(i,19))/3;
    elseif(j==19)
        valeur=(A(i,j-1)+A(i,j+1)+A(i+1,j)+A(i,1))/4;
    elseif(j==25)
        valeur=(A(i+1,j)+A(i,j-1))/2;
    else
        valeur=(A(i,j-1)+A(i,j+1)+A(i+1,j))/3;    
    end
end

%premiere colonne
if(j==1)
    casPart=1;
    if(i==1)
        valeur=(A(i+1,j)+A(i,j+1)+A(i,19))/3; %deja traite au cas precedent
    elseif((i>1)&&(i<10))
        valeur=(A(i+1,j)+A(i,j+1)+A(i-1,j)+A(i,19))/4;
    elseif(i==10)
        valeur=(A(i-1,j)+A(i,j+1)+A(i,19))/3;
    elseif(i==11)
        valeur=(A(i+1,j)+A(i,j+1)+A(i,25))/3;
    elseif((i>11)&&(i<20))
        valeur=(A(i-1,j)+A(i+1,j)+A(i,j+1)+A(i,25))/4;
    elseif(i==20)
        valeur=(A(i-1,j)+A(i,j+1)+A(i,25))/3;
    end
end

%dernière colonne
if(j==25)
    casPart=1;
    if(i==1)
        valeur=(A(i+1,j)+A(i,j-1))/2;
    elseif((i>1)&&(i<12))
        valeur=(A(i-1,j)+A(i+1,j)+A(i,j-1))/3;
    elseif((i>11)&&(i<20))
        valeur=(A(i-1,j)+A(i+1,j)+A(i,j-1)+A(i,1))/4;
    else
        valeur=(A(i-1,j)+A(i,j-1)+A(i,1))/3;
    end
end

%derniere ligne
if(i==20)
    casPart=1;
    if(j==1)
        valeur=(A(i-1,j)+A(i,j+1)+A(i,25))/3; %deja traite
    elseif((j>1)&&(j<25))
        valeur=(A(i-1,j)+A(i,j-1)+A(i,j+1))/3;
    else
        valeur=(A(i-1,j)+A(i,j-1)+A(i,1))/3; %deja traite
    end
end

%raccordement j=19
if(j==19)
    casPart=1;
    if(i==1)
        valeur=(A(i,j-1)+A(i,j+1)+A(i+1,j)+A(i,1))/4; %deja traite
    elseif((i>0)&&(i<11))
        valeur=(A(i,j-1)+A(i,j+1)+A(i+1,j)+A(i,1)+A(i-1,j))/5;
    else
        casPart=0;
    end
end

%element
if(i==10)
    casPart=1;
    if(j==1)
        valeur=(A(i-1,j)+A(i,j+1)+A(i,19))/3;
    elseif((j>1)&&(j<13))
        valeur=(A(i,j-1)+A(i,j+1)+A(i-1,j))/3;
    else
        casPart=0;
    end
end

%element2
if(i==11)
    casPart=1;
    if(j==1)
        valeur=(A(i+1,j)+A(i,j+1)+A(i,19))/3;
    elseif((j>1)&&(j<13))
        valeur=(A(i,j-1)+A(i,j+1)+A(i+1,j))/3;
    else
        casPart=0;
    end
end
   
%casgeneral

if(casPart==0)
    valeur=(A(i+1,j)+A(i-1,j)+A(i,j+1)+A(i,j-1))/4;
end
end


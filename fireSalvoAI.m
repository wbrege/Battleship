function [updated_shipBoardH, updated_guessBoardAI, nShotsH] = fireSalvoAI(shipBoardH, guessBoardAI, nShotsAI)
%This function fires the salvo for the AI player

%Prep some other variables
height = size(guessBoardAI,1);
width = size(guessBoardAI,2);
numSheets = size(guessBoardAI,3);

%First check if there have been any hits
if (sum(sum(sum(guessBoardAI == 2))) == 0)
    %Find random co-ordinates to fire at then break
    shotsX = repmat(randperm(width), 1, nShotsAI);
    shotsY = repmat(randperm(height), 1, nShotsAI);
    shotsZ = repmat(randperm(numSheets), 1, nShotsAI);
else %Targetted fire
    %Find co-ordinates where shots have been landed
    [targetX targetY targetZ] = ind2sub([height width numSheets], find(guessBoardAI == 2));
    
    
end

%Update the board
ii = 1;
while ii <= nShotsAI
    %Check for miss
    if (shipBoardH(shotsX(ii), shotsY(ii), shotsZ(ii)) == 0)
        shipBoardH(shotsX(ii), shotsY(ii), shotsZ(ii)) = -1;
        guessBoardAI(shotsX(ii), shotsY(ii), shotsZ(ii)) = -1;
        ii = ii + 1;
    %Check for already shot
    elseif ((shipBoardH(shotsX(ii), shotsY(ii), shotsZ(ii)) == -1) || (shipBoardH(shotsX(ii), shotsY(ii), shotsZ(ii)) == 3))
        %Find a valid replacement shot
        while ((shipBoardH(shotsX(ii), shotsY(ii), shotsZ(ii)) == -1) || (shipBoardH(shotsX(ii), shotsY(ii), shotsZ(ii)) == 3))
            shotsX(ii) = randperm(width, 1);
            shotsY(ii) = randperm(height, 1);
            shotsZ(ii) = randperm(numSheets, 1);
        end
    elseif (shipBoardH(shotsX(ii), shotsY(ii), shotsZ(ii)) == 1)
        shipBoardH(shotsX(ii), shotsY(ii), shotsZ(ii)) = 3;
        guessBoardAI(shotsX(ii), shotsY(ii), shotsZ(ii)) = 2;
        ii = ii + 1;
    end
end

%Finally prepare our output variables
updated_shipBoardH = shipBoardH;
updated_guessBoardAI = guessBoardAI;
%Find a way to calculate the number of Human shots remaining
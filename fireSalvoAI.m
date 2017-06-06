function [updated_shipBoardH, updated_guessBoardAI, nShotsH] = fireSalvoAI(shipBoardH, guessBoardAI, nShotsAI)
%Team: William Brege & Lauren Anthony
%Author: William Brege
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
    [hitsY, hitsX, hitsZ] = ind2sub([height width numSheets], find(guessBoardAI == 2));
    
    %Prep the target arrays
    targetX = [];
    targetY = [];
    targetZ = [];
    ii = 1;
    
    
    while ii <= size(hitsX, 1) %Check every hit
        %First check for neighbouring hits
        for xx = [hitsX(ii)+1 hitsX(ii)-1]
            %Check for out of bounds
            if (xx > width) || (xx < 1)
                continue;
            end
            
            if (guessBoardAI(hitsY(ii), xx, hitsZ(ii)) == 2)
                %Update target co-ordinates with the entire row
                for jj = (xx+1):width
                    targetX = [targetX jj];
                    targetY = [targetY hitsY(ii)];
                    targetZ = [targetZ hitsZ(ii)];
                end
                for jj = (xx-2):-1:1
                    targetX = [targetX jj];
                    targetY = [targetY hitsY(ii)];
                    targetZ = [targetZ hitsZ(ii)];
                end
                
                %Find and remove other hits from this row from the hits
                %arrays so we do not check them twice
                checkY = (hitsY == hitsY(ii));
                checkZ = (hitsZ == hitsZ(ii));
                removeIdx = (checkY == checkZ);
                hitsX(removeIdx) = [];
                hitsY(removeIdx) = [];
                hitsZ(removeIdx) = [];
                ii = 1; %Reset loop
                
                break;
            end
        end
        
        %Check if all hits have been checked
        if isempty(hitsX)
            break; %Escape loop
        end
        
        for yy = [hitsY(ii)+1 hitsY(ii)-1]
            if (yy > height) || (yy < 1)
                continue;
            end
            
            if (guessBoardAI(yy, hitsX(ii), hitsZ(ii)) == 2)
                for jj = (yy+1):height
                    targetX = [targetX hitsX(ii)];
                    targetY = [targetY jj];
                    targetZ = [targetZ hitsZ(ii)];
                end
                for jj = (yy-2):-1:1
                    targetX = [targetX hitsX(ii)];
                    targetY = [targetY jj];
                    targetZ = [targetZ hitsZ(ii)];
                end
                
                checkX = (hitsX == hitsX(ii));
                checkZ = (hitsZ == hitsZ(ii));
                removeIdx = (checkX == checkZ);
                hitsX(removeIdx) = [];
                hitsY(removeIdx) = [];
                hitsZ(removeIdx) = [];
                ii = 1;
                
                break;
            end
        end
        
        if isempty(hitsX)
            break;
        end
        
        for zz = [hitsZ(ii)+1 hitsZ(ii)-1]
            if (zz > numSheets) || (zz < 1)
                continue;
            end
            
            if (guessBoardAI(hitsY(ii), hitsX(ii), zz) == 2)
                for jj = (zz+1):numSheets
                    targetX = [targetX hitsX(ii)];
                    targetY = [targetY hitsY(ii)];
                    targetZ = [targetZ jj];
                end
                for jj = (zz-2):-1:1
                    targetX = [targetX hitsX(ii)];
                    targetY = [targetY hitsY(ii)];
                    targetZ = [targetZ jj];
                end
                
                checkY = (hitsY == hitsY(ii));
                checkX = (hitsX == hitsX(ii));
                removeIdx = (checkY == checkX);
                hitsX(removeIdx) = [];
                hitsY(removeIdx) = [];
                hitsZ(removeIdx) = [];
                ii = 1;
                
                break;
            end
        end
        
        if isempty(hitsX)
            break;
        end
        
        %Else for lone hit
        if (isempty(targetX))
            for xx = [hitsX(ii)+1 hitsX(ii)-1]
                if (xx > width) || (xx < 1)
                    continue;
                end
            
                %Check if valid target
                if (guessBoardAI(hitsY(ii), xx, hitsZ(ii)) ~= -1)
                    %Update target co-ordinates with every surrounding
                    %valid space
                    targetX = [targetX xx];
                    targetY = [targetY hitsY(ii)];
                    targetZ = [targetZ hitsZ(ii)];
                end
            end
            for yy = [hitsY(ii)+1 hitsY(ii)-1]
                if (yy > height) || (yy < 1)
                    continue;
                end
                
                if (guessBoardAI(yy, hitsX(ii), hitsZ(ii)) ~= -1)
                    targetX = [targetX hitsX(ii)];
                    targetY = [targetY yy];
                    targetZ = [targetZ hitsZ(ii)];
                end
            end
            for zz = [hitsZ(ii)+1 hitsZ(ii)-1]
                if (zz > numSheets) || (zz < 1)
                    continue;
                end
                
                if (guessBoardAI(hitsY(ii), hitsX(ii), zz) ~= -1)
                    targetX = [targetX hitsX(ii)];
                    targetY = [targetY hitsY(ii)];
                    targetZ = [targetZ zz];
                end
            end
        end
        ii = ii + 1;
    end
    
    %Fill any empty shots
    if (size(targetX,2) < nShotsAI)
        while (size(targetX,2) < nShotsAI)
            targetX = [targetX randperm(width, 1)];
            targetY = [targetY randperm(height, 1)];
            targetZ = [targetZ randperm(numSheets, 1)];
        end
    end
    
    %Convert list of targets to list of shots
    shotsX = targetX(1:nShotsAI);
    shotsY = targetY(1:nShotsAI);
    shotsZ = targetZ(1:nShotsAI);
end

%Update the board
ii = 1;
while ii <= nShotsAI
    %Check for miss
    if (shipBoardH(shotsY(ii), shotsX(ii), shotsZ(ii)) == 0)
        shipBoardH(shotsY(ii), shotsX(ii), shotsZ(ii)) = -1;
        guessBoardAI(shotsY(ii), shotsX(ii), shotsZ(ii)) = -1;
        ii = ii + 1;
    %Check for already shot
    elseif ((shipBoardH(shotsY(ii), shotsX(ii), shotsZ(ii)) == -1) || (shipBoardH(shotsY(ii), shotsX(ii), shotsZ(ii)) == 2) || (shipBoardH(shotsY(ii), shotsX(ii), shotsZ(ii)) == 3))
        %Find a valid replacement shot
        while ((shipBoardH(shotsY(ii), shotsX(ii), shotsZ(ii)) == -1) || (shipBoardH(shotsY(ii), shotsX(ii), shotsZ(ii)) == 2) || (shipBoardH(shotsY(ii), shotsX(ii), shotsZ(ii)) == 3))
            shotsX(ii) = randperm(width, 1);
            shotsY(ii) = randperm(height, 1);
            shotsZ(ii) = randperm(numSheets, 1);
        end
    elseif (shipBoardH(shotsY(ii), shotsX(ii), shotsZ(ii)) == 1)
        shipBoardH(shotsY(ii), shotsX(ii), shotsZ(ii)) = 2;
        guessBoardAI(shotsY(ii), shotsX(ii), shotsZ(ii)) = 2;
        ii = ii + 1;
    end
end

%Check for sunken ships
[hitsY, hitsX, hitsZ] = ind2sub([height width numSheets], find(guessBoardAI == 2));
for ii = 1:size(hitsX, 1)
    %Check for out of bounds
    if ((hitsX(ii)+4) <= width)
        %Check for block of 5 hits in X,Y,Z directions
        if all(shipBoardH(hitsY(ii), hitsX(ii):(hitsX(ii)+4), hitsZ(ii)) == 2)
            shipBoardH(hitsY(ii), hitsX(ii):(hitsX(ii)+4), hitsZ(ii)) = 3;
            guessBoardAI(hitsY(ii), hitsX(ii):(hitsX(ii)+4), hitsZ(ii)) = 3;
            continue;
        end
    end
    
    
    if ((hitsY(ii)+4) <= height)
        if all(shipBoardH(hitsY(ii):(hitsY(ii)+4), hitsX(ii), hitsZ(ii)) == 2)
            shipBoardH(hitsY(ii):(hitsY(ii)+4), hitsX(ii), hitsZ(ii)) = 3;
            guessBoardAI(hitsY(ii):(hitsY(ii)+4), hitsX(ii), hitsZ(ii)) = 3;
            continue;
        end
    end
    
    
    if ((hitsZ(ii)+4) <= numSheets)
        if all(shipBoardH(hitsY(ii), hitsX(ii), hitsZ(ii):(hitsZ(ii)+4)) == 2)
            shipBoardH(hitsY(ii), hitsX(ii), hitsZ(ii):(hitsZ(ii)+4)) = 3;
            guessBoardAI(hitsY(ii), hitsX(ii), hitsZ(ii):(hitsZ(ii)+4)) = 3;
            continue;
        end
    end
    
end

%Finally prepare our output variables
updated_shipBoardH = shipBoardH;
updated_guessBoardAI = guessBoardAI;
nShotsH = (7 - floor(sum(sum(sum(shipBoardH == 3))))/5);
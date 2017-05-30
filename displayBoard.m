function displayBoard(shipBoard, guessBoard)
%Team: William Brege and Lauren Anthony
%Author: William Brege
%Displays a board showing where your ships are and a board showing where
%you guess the opponents ships are

%shipBoard and guessBoard should be the same size
numSheets = size(shipBoard,3);
width = size(shipBoard,2);
height = size(shipBoard,1);

%Start with shipBoard
%Prepare the meshgrid
[x,y] = meshgrid(1:width,1:height);

figure;
%Lets start printing!
for ii = 1:numSheets
    %Prepare indexes for this sheet
    shipIndex = (shipBoard(:,:,ii) == 1);
    missIndexShip = (shipBoard(:,:,ii) == -1);
    sunkIndex = (shipBoard(:,:,ii) == 3);
    
    %Plot the points
    subplot(1,numSheets,ii);
    plot(x(shipIndex)+0.5, height-y(shipIndex)+0.5,'ks','MarkerSize', 20, 'MarkerFaceColor', 'k');
    hold on;
    plot(x(missIndexShip)+0.5, height-y(missIndexShip)+0.5,'kx','MarkerSize', 20);
    plot(x(sunkIndex)+0.5, height-y(sunkIndex)+0.5,'ks','MarkerSize', 20, 'MarkerFaceColor', 'r');
    
    %Make it look a little prettier
    axis([1 (width+1) 0 height]);
    grid on;
    set(gca,'XTickLabel','');
    set(gca,'YTickLabel','');
end

%Next we'll prepare the guessBoard
figure;
for ii = 1:numSheets
    %Prepare indexes for this sheet
    hitIndex = (guessBoard(:,:,ii) == 2);
    missIndexGuess = (guessBoard(:,:,ii) == -1);
    
    %Plot the points
    subplot(1,numSheets,ii);
    plot(x(hitIndex)+0.5, height-y(hitIndex)+0.5,'ks','MarkerSize', 20, 'MarkerFaceColor', 'g');
    hold on;
    plot(x(missIndexGuess)+0.5, height-y(missIndexGuess)+0.5,'kx','MarkerSize', 20);
    
    %Make it look a little prettier
    axis([1 (width+1) 0 height]);
    grid on;
    set(gca,'XTickLabel','');
    set(gca,'YTickLabel','');
end

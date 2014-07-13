% Skript zu Bearbeitung von Aufgabe 10.1.c
clear all, close all;

% Parametersetup
xMin = -2*pi;           % Intervallsgrenzen
xMax = 2*pi;    

numData = 400;          % Anzahl Lerndaten
numBasisFuncs = 16;     % Anzahl Basisfunktionen

numGridPts = 100;       % Anzahl der Punkte fuer das Raster zur Bildung des MSE

targetFunc = @(x) cos(x);     % Zielfunktion


% Parametervektor mit 0 initialisieren
paramVec = zeros(1,numBasisFuncs);

% Raster fuer Bestimmung des MSE
mseGrid = linspace(xMin, xMax, numGridPts);
mse = zeros(1,numData);

% Zielwerte
yTarget = targetFunc(mseGrid);
xVis = linspace(xMin,xMax,1000);
targetVisualise = targetFunc(xVis);

% Figure maximiert erstellen
figure('units','normalized','outerposition',[0 0 1 1]);

% Durch alle Lerndaten gehen
for i=1:numData
    
    % Ziehen eines zufälligen Lerndatums
    xLearn = xMin + (xMax - xMin)*rand; 
    yLearn = targetFunc(xLearn);
    
    % Lernen des neuen Parametervektors
    paramVec = paramNew(xLearn, yLearn,paramVec);
    
    % Ausgabe mit aktuellen Parametern
    out = evalPhi(mseGrid,numBasisFuncs) * paramVec';
    
    % MSE bestimmen
    mse(i) = 1/numGridPts * sum((yTarget' - out).^2);
    
    % Plot der Ausgabe und der Zielfunktion
    subplot(2,1,1);
    hold;
    plot(mseGrid,out,'g');
    plot(xVis,targetVisualise,'r');
    axis([xMin,xMax,-1,1]);
    
    % Plot des MSE
    subplot(2,1,2);
    plot(mse);
    axis([1,numData,0,10]);
    ylim('auto');
    xlabel('Anzahl Lerndaten');
    ylabel('MSE zur Zielfunktion');

    drawnow;
end

% Plot fuer finale Ansicht
subplot(2,1,1);
hold;
plot(mseGrid,out,'g');
plot(xVis,targetVisualise,'r');
axis([xMin,xMax,-1,1]);
legend('Zielfunktion cos(x)','Approximation');
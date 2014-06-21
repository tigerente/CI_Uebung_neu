% Skript zur Bearbeitung von Aufgabe 7.1.a
clear all, close all;

% Parametersetup
xMinValue = 0;              % Untere Grenze Wertebereich x-Werte
xMaxValue = 2*pi;           % Oberer Grenze Wertebereich x-Werte
numTrain = 100;             % Anzahl der Trainingsdaten
numHiddenLayers = 5;        % Anzahl an verdeckten Schichten 
func = @(x) sin(x);         % Zielfunktion, die eingelernt werden soll

% Trainingsdaten erstellen

trainX = zeros(1,numTrain);
for i=1:numTrain
    trainX(i) = xMinValue + (xMaxValue-xMinValue).*rand;
end
trainY = func(trainX);

% Array fuer Definintion der Netztopologie erstellen
topoArray = zeros(1,numHiddenLayers);
mid = floor(numHiddenLayers/2)+1;
for i=1:mid
    topoArray(i) = ((numHiddenLayers+1)/2 +1) - i;
end
topoArray(mid:end) = 1:(numHiddenLayers+1)/2;
 
% Netz erstellen
net = newff([xMinValue,xMaxValue;min(trainY),max(trainY)],[xMinValue,xMaxValue;min(trainY),max(trainY)],topoArray);

% Fenster nicht anzeigen lassen
net.trainParam.showWindow = true;
   
% Netz trainieren
[net,results] = train(net, [trainX;trainY], [trainX;trainY]);


% 



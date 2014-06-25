% Skript zur Bearbeitung von Aufgabe 7.1.a und 7.1.b
clear all, close all;

% Parametersetup
xMinValue = 0;              % Untere Grenze Wertebereich x-Werte
xMaxValue = 2*pi;           % Oberer Grenze Wertebereich x-Werte
numTrain = 100;             % Anzahl der Trainingsdaten
numHiddenLayers = 7;        % Anzahl an verdeckten Schichten (Muss ungerade sein!!)
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
net.trainParam.showWindow = false;
   
% Netz trainieren
[net,results] = train(net, [trainX;trainY], [trainX;trainY]);

% Ausgabe des Netzes testen (fuer Aufgabenteil b)
% Dafuer Gewichte bis zur Mittelschicht auf 0 setzen
% -> Eingabegewichte auf 0 setzen
net.IW{1,1}(:) = 0;

% -> LayerWeights und Biasgewichte auf 0 setzen
for i=1:floor(numHiddenLayers/2)
    net.LW{i+1,i}(:) = 0;
    net.b{i}(:) = 0;
end


% Ausgabedaten den Netzes bestimmen
testIn = linspace(-1,1);
testOut = zeros(2,numel(testIn));

% Fuer jeden Eingabewert...
for i=1:numel(testIn)
    
    % ...Biasgewicht zur mittleren Schicht auf Eingabe setzen
    net.b{round(numHiddenLayers/2)} = testIn(i);
   
    % Ausgabe des Netzes simulieren 
    testOut(:,i) = sim(net,[0;0]);
end


% Plot des Tests
figure;
hold on;
plot(testOut(1,:),testOut(2,:),'--r');
plot(trainX,trainY,'og');
axis([0,2*pi,-1,1]);
set(gca,'XTick',[0,pi,2*pi]);
set(gca,'XTickLabel',{'0','pi','2*pi'});
legend('Augabe des Netzes', 'Trainingswerte');






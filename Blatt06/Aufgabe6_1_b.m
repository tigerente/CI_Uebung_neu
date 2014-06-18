% Skript zur Bearbeitung von Aufgabe 6.1 b
clear all, close all;

% Parametersetup
xMinValue = 0;          % Untere Intervallsgrenze der x-Werte
xMaxValue = 4*pi;       % Obere Intervallsgrenze der x-Werte

yMinValue = 0;          % Untere Intervallsgrenze der y-Werte
yMaxValue = 5;          % Obere Intervallsgrenze der y-Werte

numTrain = 500;         % Anzahl an Trainingsdaten
numValidate = 100;      % Anzahl an Validierungsdaten
numTest = 1000;         % Anzahl an Testdaten

numHiddenLayers = 3;    % Anzahl verdeckter Schichten
numNeuronsLayer1 = 5;   % Anzahl Neuronen in verdeckter Schicht 1
numNeuronsLayer2 = 5;   % Anzahl Neuronen in verdeckter Schicht 2
numNeuronsLayer3 = 2;   % Anzahl Neuronen in verdeckter Schicht 3

func = @(x,y) sin(x).*(0.01.*y.^4+0.3.*y.^3-2.*y.^2+y);         % Zielfunktion des Trainigs

trainMethods = {'traingd' 'traingdm' 'traingdx' 'trainrp' 'traincgf' 'traincgp' 'traincgb' 'trainscg' 'trainbfg' 'trainoss' 'trainlm'};
lineStyles = {'r' 'g' 'b' 'k' 'c' 'm' 'y' ':r' ':g' ':b' ':y'};

% Trainings-, Validierungs- und Testdaten erstellen
trainX = linspace(xMinValue,xMaxValue, numTrain);
trainY = linspace(yMinValue,yMaxValue, numTrain);
trainOut = func(trainX,trainY);

validateX = linspace(xMinValue,xMaxValue, numValidate);
validateY = linspace(yMinValue,yMaxValue, numValidate);
validateOut = func(validateX,validateY);

testX = linspace(xMinValue,xMaxValue, numTest);
testY = linspace(yMinValue,yMaxValue, numTest);
testOut = func(testX,testY);

% Netz erstellen
net = newff([xMinValue,xMaxValue;yMinValue,yMaxValue],[min(testOut),max(testOut)],[numNeuronsLayer1,numNeuronsLayer2,numNeuronsLayer3]);

% Daten aufteilen 
net.divideFcn = 'divideind';
net.divideParam.trainInd = 1:numTrain;
net.divideParam.valInd = numTrain+(1:numValidate);
net.divideParam.testInd = numTrain+numValidate+(1:numTest);
    
% Speichervariable der Testfehler üeber die Epochen der einzelnen
% Trainingsmethoden
testErrors = cell(numel(trainMethods),1);

% Durch alle Trainingsmethoden iterieren
for i=1:numel(trainMethods)
        
    % Trainingsmethode festlegen
    net.trainFcn = trainMethods{i};
    
    % Fenster nicht anzeigen lassen
    net.trainParam.showWindow = false;
   
    % Netz trainieren
    [net,results] = train(net, [trainX,validateX,testX;trainY,validateY,testY], [trainOut,validateOut,testOut]);
    
    % Testfehler ueber Epochen speichern
    testErrors{i} = results.tperf;

    % Netz auf initiale Gewichtskonfiguration zuruecksetzen
    net = revert(net);

end

% Plot der Testfehler der Einzelnen Trainingsmethoden
figure;
hold on;
for i=1:numel(trainMethods)
    plot(testErrors{i},lineStyles{i});
end
hold off;
legend('traingd','traingdm','traingdx','trainrp','traincgf','traincgp','traincgb','trainscg','trainbfg','trainoss','trainlm');
xlabel('Anzahl der Epochen');
ylabel('Testfehler');
axis([0, 1000, 0, 10]);
axis 'autoy';



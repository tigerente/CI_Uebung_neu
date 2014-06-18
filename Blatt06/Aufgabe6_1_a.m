% Skript zur Bearbeitung von Aufgabe 6.1 a
clear all, close all;

% Parametersetup
minValue = -2*pi;           % Untere Intervallsgrenze der Trainingsdaten
maxValue = 2*pi;            % Obere Intervallsgrenze der Trainingsdaten
numTrain = 20;              % Anzahl an Trainingsdaten
numValidate = 10;           % Anzahl an Validierungsdaten
numTest = 100;              % Anzahl an Testdaten
numHiddenNeurons = 6;       % Anzahl Neuronen in verdeckter Schicht
func = @(x) cos(x);         % Zielfunktion des Trainigs
trainMethods = {'traingd' 'traingdm' 'traingdx' 'trainrp' 'traincgf' 'traincgp' 'traincgb' 'trainscg' 'trainbfg' 'trainoss' 'trainlm'};
lineStyles = {'r' 'g' 'b' 'k' 'c' 'm' 'y' ':r' ':g' ':b' ':y'};

% Trainings-, Validierungs- und Testdaten erstellen
trainX = linspace(minValue,maxValue, numTrain);
trainY = func(trainX);
validateX = linspace(minValue,maxValue, numValidate);
validateY = func(validateX);
testX = linspace(minValue,maxValue, numTest);
testY = func(testX);

% Netz mit 'numHiddenNeurons' Neuronen in verdeckter Schicht erstellen
net = newff([minValue,maxValue], [-1 1], numHiddenNeurons);
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
    net.trainParam.showWindow = 0;
   
    % Netz trainieren
    [net,results] = train(net, [trainX,validateX,testX], [trainY,validateY,testY]);
    
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



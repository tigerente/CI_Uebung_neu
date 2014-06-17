%% I) VORBEREITUNG

%Parameter-Setup
minVal = -2 * pi;
maxVal = 2 * pi;
nrTrain = 60;
nrValidate = 60;
nrTest = 200;
f = @(x) cos(x);
noise = true;
alpha = 0.01; % Rauschfaktor
regRatio = 0.01; % Regularisierungsfaktor

%Validierungsdaten erstellen: linear
validateX = linspace(minVal,maxVal, nrValidate);
validateY = f(validateX);

%Testdaten erstellen: linear
testX = linspace(minVal,maxVal, nrTest);
testY = f(testX);

%Trainingsdaten erstellen: zufaellig
trainX = rand(1,nrTrain) * (maxVal-minVal) + minVal;
trainY = f(trainX);

%Rauschen
if (noise == true)
    validateY = validateY + alpha * randn(1,nrValidate);
    testY = testY + alpha * randn(1,nrTest);
    trainY = trainY + alpha * randn(1,nrTrain);
end

%MLP mit 25 Neuronen in verdeckter Schicht erstellen
net = newff([minVal,maxVal], [-1 1], 25);

% Daten-Aufteilung
net.divideFcn = 'divideind';

% Abbruchbedingungen:
net.trainParam.epochs = 2000;
net.trainParam.min_grad = 0;
net.trainParam.goal = 0;

%Anzeige des Fensters deaktivieren
net.trainParam.showWindow = 1;

% Datenreihe fuer Plots
plotX = linspace (minVal,maxVal,1000);

%% II.1) REFERENZ: Keine Massnahme gegen Overfitting
% Kopie anlegen
net1 = net;
%Aufteilung der Daten in Training/Test
net1.divideParam.trainInd = 1:nrTrain;
net1.divideParam.valInd = [];
net1.divideParam.testInd = nrTrain+(1:nrTest);

%Training des MLPs
[net1,tr] = train(net1, [trainX testX], [trainY testY]);

%Ausgabe des Netzes bestimmen
predY = sim(net1,plotX);

%% II.2) Early Stopping
% Kopie anlegen
net2 = net;
%Aufteilung der Daten in Training/Validierung/Test
net2.divideParam.trainInd = 1:nrTrain;
net2.divideParam.valInd = nrTrain+(1:nrValidate);
net2.divideParam.testInd = nrTrain+nrValidate+(1:nrTest);

%Training des MLPs
[net2,tr] = train(net2, [trainX validateX testX], [trainY validateY testY]);

%Ausgabe des Netzes bestimmen
predY = sim(net2,plotX);

%% II.3) REGULARISIERUNG
% Kopie anlegen
net3 = net;
%Aufteilung der Daten in Training/Test
net3.divideParam.trainInd = 1:nrTrain;
net3.divideParam.valInd = [];
net3.divideParam.testInd = nrTrain+(1:nrTest);

%Performance-Function
net3.performFcn = 'mse';
net3.performParam.regularization = regRatio;

%Training des MLPs
[net3,tr] = train(net3, [trainX testX], [trainY testY]);

%Ausgabe des Netzes bestimmen
predY = sim(net3,plotX);

%% III) AUSWERTUNG

%Testfehler plotten und letzten Wert auf der Konsole ausgeben
plotperf(tr);
testError = tr.tperf(end);
trainingsError = tr.perf(end);
disp(['Testfehler: ' num2str(testError)])
disp(['Trainingsfehler: ' num2str(trainingsError)])

%Ausgabe und Zielfunktion plotten

figure;
plot(trainX, trainY, '.', plotX,f(plotX), plotX, predY)
xlabel('Eingabe')
ylabel('Ausgabe')
legend('Trainingsdaten', 'Zielfunktion','Fit')

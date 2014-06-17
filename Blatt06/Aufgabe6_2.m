%Parameter-Setup
minVal = -2 * pi;
maxVal = 2 * pi;
nrTrain = 60;
nrValidate = 60;
nrTest = 200;
f = @(x) cos(x);
noise = true;
alpha = 0.01;

%Verhinderung von Overfitting
NONE = 0;   % Referenz
EAST = 1;   % Early Stopping
REGL = 2;   % Regularisierung
regRatio = 0.1;

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

for antiOverfit = [NONE, EAST, REGL]
    %MLP mit 25 Neuronen in verdeckter Schicht erstellen
    net = newff([minVal,maxVal], [-1 1], 25);
    
    %Aufteilung der Daten in Training/Validierung/Test
    net.divideFcn = 'divideind';
    net.divideParam.trainInd = 1:nrTrain;
    net.divideParam.valInd = [];
    if (antiOverfit == EAST) % Validierungsmenge nur bei Early Stopping
        net.divideParam.valInd = nrTrain+(1:nrValidate);
    end
    net.divideParam.testInd = nrTrain+nrValidate+(1:nrTest);
    
    %Performance-Function
    net.performFcn = 'mse';
    if (antiOverfit == REGL) % Regularisierung
        net.performParam.regularization = regRatio;
    end
    
    % Abbruchbedingungen:
    net.trainParam.epochs = 2000;
    net.trainParam.min_grad = 0;
    net.trainParam.goal = 0;
    
    %Anzeige des Fensters deaktivieren
    net.trainParam.showWindow = 1;

    %Training des MLPs
    [net,tr] = train(net, [trainX validateX testX], [trainY validateY testY]);

    %Testfehler merken
    testError = tr.tperf(end);
    disp(['Testfehler: ' num2str(testError)])

    %Ausgabe des Netzes bestimmen
    plotX = linspace (minVal,maxVal,1000);
    predY = sim(net,plotX);

    %Ausgabe und Zielfunktion plotten

    figure;
    plot(trainX, trainY, '.', plotX,f(plotX), plotX, predY)
    xlabel('Eingabe')
    ylabel('Ausgabe')
    legend('Trainingsdaten','Zielfunktion','Fit')

end

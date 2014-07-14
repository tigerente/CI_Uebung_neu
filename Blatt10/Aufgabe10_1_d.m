% Skript zur Bearbeitung von Aufgabe 10.1.d
clear all, close all;

% Parametersetup
minTrainData = 2;               % Minimale Anzahl an Trainingsdaten
maxTrainData = 20;            % Maximale Anzahl an Trainindsdaten

minBasisFuncs = 2;              % Minimale Anzahl an Basisfunktionen
maxBasisFuncs = 10;            % Maximale Anzahl an Basisfunktionen

numRuns = 25;                   % Anzahl an Laeufen pro Konstellation

trainFunc = @(x) cos(x);        % Zielfunktion

% Speichervariablen fuer Ergebnisse
meanMSE = zeros(maxBasisFuncs-1,maxTrainData-1); 

% Anzahl Basisfunktionen variieren
for b = minBasisFuncs:maxBasisFuncs
   
    % Anzahl Trainingsdaten variieren
    for t=minTrainData:maxTrainData
       
        % Zwischenspeicher der einzelnen Laeufe
        tmpMSE = zeros(1,numRuns);
        
        % Mehrere Runs pro Konstellation
        for r=1:numRuns
            
            % Training durchfuehren
            tmpMSE(r) = executeTraining(b,t,trainFunc,-2*pi,2*pi);
        end
        
        % MSE mitteln
        meanMSE(b-1,t-1) = mean(tmpMSE);
    end
end

% Darstellung der Daten
figure('units','normalized','outerposition',[0 0 1 1]);
surf(meanMSE);
xlabel('Anzahl Trainingsdaten');
ylabel('Anzahl Basisfunktionen');
zlabel('MSE zur Zielfunktion cos(x)');
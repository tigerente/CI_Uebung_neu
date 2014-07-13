function mse = executeTraining(numBasis, numData, targetFunc, xMin, xMax)
%EXECUTETRAINING (numBasis, numData, targetFunc)
% Fuehrt dem Algorithmus alle Trainingsdaten vor und gibt den anschlieﬂend 
% berechneten MSE zurueck
% PARAMETER:   
%   numBasis:       Anzahl Basisfunktionen
%   numData:        Anzahl Trainingsdaten, die vorgefuehrt werden
%   targetFunc:     functionhandle auf die Zielfunktion
%   xMin:           Untere Intervallgrenze der Trainingswerte
%   xMax:           Obere Intervallgrenze der Trainingswerte
%
% RETURN:
%   mse:            der MSE zur Zielfunktion nach Abschluss des Trainings


% AbtastRaster fuer Bildung des MSE
mseGrid = linspace(xMin,xMax,200);

% Zielwerte fuer Bildung des MSE
target = targetFunc(mseGrid);

% Parametervecktor mit 0 initialisieren
paramVec = zeros(1,numBasis);


% Alle Daten praesentieren
for i=1:numData
   
    % Ziehen eines zuf‰lligen Lerndatums
    xLearn = xMin + (xMax - xMin)*rand; 
    yLearn = targetFunc(xLearn);
    
    % Lernen des neuen Parametervektors
    paramVec = paramNew(xLearn, yLearn,paramVec);   
end

% Bestimmen des MSE
out = evalPhi(mseGrid,numBasis) * paramVec';
mse = 1/numel(mseGrid) * sum((target' - out).^2);

end


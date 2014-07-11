function paramNew = paramNew(x,y,param)
%PARAMNEW(x,y,param)
% Berechnet den neuen Parameterverktor nach dem
% Passive-Aggressive-Algorithmus
% PARAMETER:
%   x:      x-Wert im Eingangsraum
%   y:      Vorgegebener y-Wert, der erreicht werden soll
%   param:  aktueller Parameterverktor
%
% RETURN:
%   paramNew:   mit Hilfe des Lerndatums (x,y) aktualisierter ParameterVektor

% Alte Phis berechnen
phiOld = evalPhi(x,numel(param));

% Vorhersage mit altem ParameterVektor berechnen
yPredict = param' * phiOld;

% Berechnung des neuen ParameterVektors
paramNew = param +((y-yPredict) * phiOld)/(phiOld' * phiOld); 


end


function cutValues = cutTrapez(xIn, cutHeight, trapezParams)
%CUTTRAPEZ(cutHeight, trapezParams)
% Schneidet eine Trapezfunktion in einer bestimmten Hoehe 'cutHeight' ab
% und berechnet anschließend den Zugehoerigkeitswert von einer Eingabe 
% PARAMETER: 
%   xIN:            Eingabewert, dessen Zugehoerigkeit berechnet werden
%                   soll
%   cutHeight:      Hoehe, in der die Trapezfunktion abgeschnitten werden
%                   soll
%   trapezParams:   Array mit Werten, die das Trapez beschreiben

% Trapezparameter auslesen
a = trapezParams(1);
b = trapezParams(2);
c = trapezParams(3);
d = trapezParams(4);

% Steigung des Anstiegs der Trapezfunktion
if(a == b)
    rise = 0; 
else
    rise = 1/(b-a);    
end

% Steigung des Abfalls der Trapezfunktion
if(c == d)
    fall = 0; 
else
    fall = -1/(d-c); 
end

% Ergebnis der Trapezfunktion
cutValues = (((xIn * rise)-(a*rise)) .* (cutHeight*(xIn>=a & xIn<b))) + (cutHeight.*(xIn>=b & xIn<=c)) + (((xIn*fall)-(d*fall)).*((cutHeight*(xIn>=c & xIn<=d)))); 


end


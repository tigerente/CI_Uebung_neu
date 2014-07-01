function result = trapez(xIn,trapezParams)
%TRAPEZ(xIn,trapezParams)
% Berechnet die Ausgabe einer Trapezfunktion, welche durch die Parameter in
% 'trapezParams' beschrieben wird
% PARAMETER:
%   xIn:            Der Eingabevektor mit Werten, deren Funktionswerte
%                   berechnet werden sollen
%   trapezParams:   Array der Parameter, die die Trapezfunktion 
%                   charakterisieren (z.B. [1,2,4,5])

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
result =  (((xIn * rise)-(a*rise)) .* (xIn>=a & xIn<b)) + (1.*(xIn>=b & xIn<c)) + (((xIn*fall)-(d*fall)).*((xIn>=c & xIn<=d))); 

end


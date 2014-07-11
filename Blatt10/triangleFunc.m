function outValues = triangleFunc(xIn, params)
%TRIANGLEFUNC(xIn, params)
% Berechnet den Wert einer Dreiecksfunktion an den Stellen in 'xIn'
% PARAMETER:
%   xIn:        x-Werte als nrData x 1-Matrix, an denen der Wert der 
%               Dreiecksfunktion ausgerechnet werden soll
%   params:     Parameter der Dreiecksfunktion (a,b,c):
%               a: Start des Anstiegs der Funktion
%               b: Peak der Funktion
%               c: Ende des Abfalls der Funktion

% Auslesen der Funktionsparameter
a = params(1);
b = params(2);
c = params(3);

% Berechne die Steigungen der Flanken
% Anstieg der Funktion
if (a==b)
     rise = 0;
else
    rise = 1/(b-a);
end

% Abfall der Funktion
if (b==c)
     fall = 0;
else
    fall = -1/(c-b);
end

% Berechnung der Ausgabe der Funktion
outValues = (((xIn * rise)-(a*rise)) .* (xIn>=a & xIn<b)) + (1.*(xIn==b)) + (((xIn*fall)-(c*fall)).*((xIn>b & xIn<=c))); 

end


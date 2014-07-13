function out = evalPhi(x,N)
%EVALPHI(x,N)
% Wertet die Basisfunktionen an den Punkten in Eingabe x aus
% Wertebereich für x ist hierbei [-2pi,2pi]
% PARAMETER:
%   x:          Punkte in nrData x 1-Matrix, an denen die Basisfunktionen ausgwertet werden
%               sollen
%   N:          Anzahl der gleichverteilten dreieckigen Basisfunktionen 
%               N muss groesser 1 sein!
%
% RETURN:
%   out:        nrData x N-Matrix fuer den Wert jeder Basisfuntkion an
%               jedem gewuenschten x-Wert


% Wertebereich festlegen
xMin = -2*pi;
xMax = 2*pi;

% Positionen der Peaks der Basisfunktionen festlegen
if (N==1)
    stepWidth = (4*pi);
else
    stepWidth = (4*pi)/(N-1);
end
peaks = zeros(1,N);

for i=1:N
    peaks(i) = xMin + (i-1)*stepWidth;
end

% Ausgabe jeder Basisfunktion berechnen
out = zeros(numel(x),N);
for i=1:N
   
    % Parameter der Baisfunktion festlegen
    if(i == 1)
        params = [peaks(i),peaks(i),xMax];    
    elseif(i == N)
        params = [peaks(i-1),peaks(i),peaks(i)];
    else
        params = [peaks(i-1),peaks(i),peaks(i+1)];
    end
    
    out(:,i) = triangleFunc(x,params);
end

end


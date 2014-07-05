function U = fuzzyCMeans (x, C, m, epsilon)
% fuzzyCMEans Clustert die uebergebenen Daten mit Hilfe des
% Fuzzy-C-Means-Algorithmus
%
% Input-Parameter:
%   x:          zu clusternde Daten als N x D Matrix. Jede Zeile entspricht
%               einem Datum, die Spalten sind die Dimensionen.
%   C:          Anzahl an Clustern
%   m:          Unschaerfegrad
%   epsilon:    Abbruchgenauigkeit                   
%
% Output-Parameter:
%   U:  Ermittelte Cluster-Zugehoerigkeiten als C x N Matrix. Jede Spalte
%       entspricht einem Datum, die Spalten sind die Cluster.

N = size (x,1);
D = size(x,2);

d = zeros(C,N); % Abstaende
s = zeros(C,1); % Zwischenspeicher

% Zufaellige Initialisierung der Zugehoerigkeitsmatrix:
U = rand(C, N);

% Clustering-Schleife
finished = false;
while ~ finished
    % Prototypen neu positionieren:
    U_m = U .^ m; % Potenzieren (Unschaerfe)
    V = (U_m * x) ./ repmat(sum (U_m, 2), 1, D);
    
    % Zugehoerigkeiten aktualisieren:
    U_ = U; % Alte Zugehoerigkeiten speichern
    for i = 1:C % Abstaende berechnen
        for k = 1:N
            diff = x(k,:)-V(i,:);
            d(i,k) = sqrt(dot(diff, diff));
        end
    end
    for i = 1:C % Berechnung der neuen Zugehoerigkeiten
        for k = 1:N
            for j = 1:C
                s(j) = d(i,k) / d(j,k);
                s(j) = s(j) ^ (2 / (m-1));
            end
            U (i,k) = 1 / sum(s);
        end
    end
    
    % Abbruchbedingung (Maximumsnorm der Zugehoerigkeits-Aenderung)
    delta_U = abs(U-U_);
    if (max(delta_U(:)) < epsilon)
        finished = true;
    end
end
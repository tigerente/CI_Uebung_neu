function memb = param2fuzzify(param)
%PARAM2FUZZIFY(param)
% Ueberfuehrt Zugehoerigkeitsfunktionen in functionHandles
% PARAMETER:
%   param:      4x1 cellArray mit den Trapezfunktionsparametern aller Variablen (T,H,W,I).
%               Jede cell haelt eine Matrix mit nx4 Eintraegen, wobei n die
%               Anzahl der Fuzzymengen der einzelnen Variable ist. Die 4
%               steht fuer die Trapezfunktionsparameter
% 
% RETURN:
%   memb:       4x1 cellArray mit nx1 cellArrays enthalten, in denen die
%               functionHandles der einzelnen Zugehoerigkeitsfunktionen stehen

% 'memb' deklarieren
memb = cell(4,1);

% Alle cells von 'param' durchlaufen
for i=1:4
    % Die Matrix mit Parametern der Trapezfunktionen fuer weitere
    % Bearbeitung auslesen
    paramMatrix = param{i};
    
    % Anzahl der Fuzzymengen
    numFuzzy = size(paramMatrix,1);
    
    % CellArrays fuer die einzelnen fnctionHandles erzeugen
    paramCell = cell(numFuzzy,1);
    
    % Durch alle Zeilen jeder der 4 Parametermatrizen gehen
    for j=1:numFuzzy
        
        % Trapezparameter auslesen
        a = paramMatrix(j,1);
        b = paramMatrix(j,2);
        c = paramMatrix(j,3);
        d = paramMatrix(j,4);
        
        % functionHandle mit Trapezfunktion erzeugen
        functionHandle = @(x) trapez(x, [a, b, c, d]);
       
        % functionHandle in cellArray ablegen
        paramCell{j} = functionHandle;
    end
    
    % Einzelne cellArrays in 'memb' ablegen
    memb{i} = paramCell;
end

end


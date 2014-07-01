function out = mamdani(input,fuzzify,ruleBase,defuzzify,range,defuzzyRes)
%MAMDANI Wertet ein Mamdani-Fuzzy-System aus.
% Eingabe-Parameter:
%       input:      Angabe der drei erklaerenden Variablen als
%                   (nrData x 3)-Matrix. Eintraege: Indizes der
%                   Fuzzy-Mengen. 
%                   Zeilen: Datensaetze
%                   Spalten: Praemissen-Variablen (T, H, W)
%       fuzzify:    (4 x 1)-Cell-Array der Zugehoerigkeitsfunktionen fuer
%                   die Fuzzy-Mengen alle vier Variablen (T, H, W, I).
%                   Eintraege sind (ni x 1)-Cell-Arrays, wobei ni die
%                   Anzahl der Fuzzy-Mengen fuer Variable i sind. Die
%                   Eintraege dieser Cell-Arrays sind function_handles der
%                   Zugehoerigkeitsfunktionen.
%       ruleBase:   Fuzzy-Regelsatz (und-verknuepft) als (nrRules x 4)-
%                   Matrix. Eintraege: Indizes der Fuzzy-Mengen
%                   Zeilen: Regeln
%                   Spalten: 1, 2, 3: Praemissen (T, H, W)
%                                  4: Konklusion (I)
%       defuzzify:  Methode zur Defuzzifizierung als String.
%                   'lom': Left-Of-Maximum
%                   'mom': Mean-Of-Maximum
%                   'rom': Right-Of-Maximum
%                   'cog': Center-Of-Gravity
%       range:      Wertebereich der Defuzzifikation.
%                   range(1): Minimum
%                   range(2): Maximum
%       defuzzyRes: Aufloesung der Defuzzifizierung. Anzahl an
%                   Rasterpunkten.
% Ausgabe-Parameter:
%       out:        Ausgabe der exakten Werte der defuzzifizierten
%                   Konklusionen als (nrData x 1)-Matrix

nrData = size(input,1);
nrRules = size(ruleBase,1);

conclusion = cell(nrRules,1);
out = zeros(nrData,1);

% Gehe alle Datensaetze durch
for d = 1 : nrData
    % Eingaben fuzzifizieren
    i_T = input(d, 1); % Indizes der Fuzzy-Mengen (Inputs)
    i_H = input(d, 2);
    i_W = input(d, 3);
    input_T = fuzzify {1}{i_T}; % Zugehoerigkeitsfunktionen (Inputs)
    input_H = fuzzify {2}{i_H};
    input_W = fuzzify {3}{i_W};

    % Gehe alle Regeln durch
    for r = 1 : nrRules
        % Praemissen fuzzifizieren:
        p_T = ruleBase(r,1); % Indizes der Fuzzy-Mengen (Praemissen)
        p_H = ruleBase(r,2);
        p_W = ruleBase(r,3);
        praem_T = fuzzify {1}{p_T}; % Zugehoerigkeitsfunktionen (Praemissen)
        praem_H = fuzzify {2}{p_H};
        praem_W = fuzzify {3}{p_W};
        
        % Schnittmengen aus Praemissen und Eingaben bilden:
        S_T = intersect(input_T, praem_T);
        S_H = intersect(input_H, praem_H);
        S_W = intersect(input_W, praem_W);
        
        % Aktivierungen der Praemissien bestimmen
        [~, act_T] = fminsearch(@(x) S_T(x)*(-1), 1);
        [~, act_H] = fminsearch(@(x) S_H(x)*(-1), 1);
        [~, act_W] = fminsearch(@(x) S_W(x)*(-1), 1);
        act_T = act_T * (-1);
        act_H = act_H * (-1);
        act_W = act_W * (-1);
        
        % Und-Verknuepfung der drei Praemissen-Terme:
        act = min([act_T, act_H, act_W]);
        
        % Konklusion fuzzifizieren:
        c = ruleBase(r,4);
        concl = fuzzify {4}{c};
        
        % Aktivierung der Konklusion bestimmen (Fuzzy-Inferenz)
        conclusion{r} = conclude (act, concl);
    end
    
    % Konklusion aller konjugierten Regeln bestimmen:
    united_conclusion = unite (conclusion);
    
    
    % Defuzzifikation
    raster = linspace(range(1), range(2), defuzzyRes);
    values = united_conclusion (raster);
    
    if (strcmp(defuzzify, 'cog'))
        out(d) = trapz(raster, raster .* values) / trapz(raster, values);
    else
        maximum = max(values);
        max_pos = find (values == maximum);
        if (strcmp(defuzzify, 'lom'))
            out(d) = raster(max_pos(1));
        end
        if (strcmp(defuzzify, 'mom'))
            out(d) = mean(raster(max_pos));
        end
        if (strcmp(defuzzify, 'rom'))
            out(d) = raster(max_pos(end));
        end
    end

end

end


function out = mamdani(input,fuzzify,ruleBase,defuzzify,range,defuzzyRes)
%MAMDANI Wertet ein Mamdani-Fuzzy-System aus.
% Eingabe-Parameter:
%       input:      Angabe der drei erklaerenden Variablen als Index der
%                   Fuzzy-Mengen. (nrData x 3)-Matrix.
%                   Zeilen: Datensaetze.
%                   Spalten: Variablen (T, H, W)
%       fuzzify:    (4 x 1)-Cell-Array der Zugehoerigkeitsfunktionen fuer
%                   die Fuzzy-Mengen alle vier Variablen (T, H, W, I).
%                   Eintraege sind (ni x 1)-Cell-Arrays, wobei ni die
%                   Anzahl der Fuzzy-Mengen für Variable i sind. Die
%                   Eintraege dieser Cell-Arrays sind function_handles der
%                   Zugehoerigkeitsfunktionen.
%       ruleBase:   Fuzzy-Regelsatz (und-verknüpft) als (nrRules x 4)-
%                   Matrix. Eintraege: Indizes der Fuzzy-Mengen
%                   Zeilen: Regeln
%                   Spalten: 1, 2, 3: Prämissen (T, H, W)
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
%       out:        Ausgabe des exakten Wertes der Konklusion.

end


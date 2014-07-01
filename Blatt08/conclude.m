function conclusion = conclude(act, concl)
%CONCLUDE Bildet die Fuzzy-Inferenz ab.
% Eingabeparameter:
%   act:        Aktivierung der Regel
%   concl:      Zugehoerigkeitsfunktion des Konlusionsterms
% Ausgabeparameter:
%   conclusion: Zugehoerigkeitsfunktion der tatsaechlichen Konklusion

conclusion =  @(x) concl(x) .* (concl(x) <= act) + act .* (concl(x) > act);
end


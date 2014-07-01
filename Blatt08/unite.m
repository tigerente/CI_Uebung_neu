function u = unite(funcs)
%UNITE Bildet die Fuzzy-Vereinigung beliebig vieler
%Fuzzy-Mengen.
% Eingabe: (nrFuncs x 1)-Cell Array, wobei nrFuncs die Anzahl der zu
% vereinigenden Fuzzy-Mengen angibt. Eintraege: function_handles der
% Zugehoerigkeitsfunktionen der Fuzzy-Mengen.
% Ausgabe: function_handle u. stellenweise Maximums-Funktion aller
% uebergebenen Zugehoerigkeitsfunktionen.

nrFuncs = size(funcs, 1);

f = funcs{1};
for i = 2: nrFuncs
    g = funcs{i};
    u =  @(x) f(x) .* (f(x) >= g(x)) + g(x) .* (f(x) < g(x));
    f = u;
end

end


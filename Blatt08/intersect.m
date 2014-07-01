function h = intersect(f, g)
%INTERSECT berechnet die Fuzzy-Schnittmenge zweier
%Fuzzy-Mengen.
% Eingabe: zwei function_handles f und g
% Ausgabe: function_handle h. stellenweise Minimums-Funktion von f und g

h =  @(x) f(x) .* (f(x) <= g(x)) + g(x) .* (f(x) > g(x));
end


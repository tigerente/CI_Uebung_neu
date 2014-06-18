% Einfache Integration der Mackey-Glass-DGL mit Standardparametern
% x0 - Startwert für x(t = 0)
% xt0 - Startwert für x(t < 0)
% len - Anzahl der zeitschritte die berechnet werden sollen
%
% x - Verlauf der betrachteten Größe
function x = mackeyglass(x0, xt0, len)

%Parameter
beta = 0.2; eta = 1; n = 10; tau = 17; gamma = 0.1;
df = @(x, xt, dt) (beta*eta^n*xt)/(eta^n+xt^n)-gamma * x * dt;

%Ausgabe initialisieren
x = ones(len,1)*x0;

%inkrementell die Ausgabe berechnen
for i=2:len
    if((i-tau) < 1)
        xt = xt0;
    else
        xt = x(i-tau);
    end
    x(i) = x(i-1) + df(x(i-1), xt, 1);
end
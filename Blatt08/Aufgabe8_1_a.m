% Skript zur Bearbeitung von Aufgabe 8.1.a
clear all, close all;

% Daten erzeugen mit Skript
generateFuzzyData;

% Plot der Fuzzymengen
figure('units','normalized','outerposition',[0 0 1 1])
% Temperatur
subplot(2,2,1);
plot(x_T,y_T);
xlabel('Temperatur in �C');
ylabel('Zugeh�rigkeit');
legend('kalt','etwas kalt','mild','sommerlich warm','Hitze','gro�e Hitze','Location','West');
legend('boxoff');


% Luftfeuchtigkeit
subplot(2,2,2);
plot(x_H,y_H);
xlabel('Luftfeuchtigkeit in % ');
ylabel('Zugeh�rigkeit');
legend('extrem trocken','trocken','klamm','schw�l','nass','Location','East');
legend('boxoff');


% Windgeschwindigkeit
subplot(2,2,3);
plot(x_W,y_W);
xlabel('Windgeschwindigkeit in km/h');
ylabel('Zugeh�rigkeit');
legend('windstill','leichte Brise','windig','sturm','Location','East');
legend('boxoff');

% WWI
subplot(2,2,4);
plot(x_WWI,y_WWI);
xlabel('WetterWohlf�hlndex');
ylabel('Zugeh�rigkeit');
legend('furchtbar','unangenehm','gut aushaltbar','wunderbar','Location','East');
legend('boxoff');


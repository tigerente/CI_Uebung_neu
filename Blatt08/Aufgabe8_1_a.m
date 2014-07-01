% Skript zur Bearbeitung von Aufgabe 8.1.a
clear all, close all;

% Daten erzeugen mit Skript
generateFuzzyData;

% Plot der Fuzzymengen
figure('units','normalized','outerposition',[0 0 1 1])
% Temperatur
subplot(2,2,1);
hold on;
for i=1:size(y_T,1)
    plot(x_T,y_T);
end
hold off;
xlabel('Temperatur in °C');
ylabel('Zugehörigkeit');
legend('kalt','etwas kalt','mild','sommerlich warm','Hitze','große Hitze','Location','West');
legend('boxoff');


% Luftfeuchtigkeit
subplot(2,2,2);
hold on;
for i=1:size(y_H,1)
    plot(x_H,y_H);
end
hold off;
xlabel('Luftfeuchtigkeit in % ');
ylabel('Zugehörigkeit');
legend('extrem trocken','trocken','klamm','schwül','nass','Location','East');
legend('boxoff');


% Windgeschwindigkeit
subplot(2,2,3);
hold on;
for i=1:size(y_W,1)
    plot(x_W,y_W);
end
hold off;
xlabel('Windgeschwindigkeit in km/h');
ylabel('Zugehörigkeit');
legend('windstill','leichte Brise','windig','sturm','Location','East');
legend('boxoff');

% WWI
subplot(2,2,4);
hold on;
for i=1:size(y_WWI,1)
    plot(x_WWI,y_WWI);
end
hold off;
xlabel('WetterWohlfühlndex');
ylabel('Zugehörigkeit');
legend('furchtbar','unangenehm','gut aushaltbar','wunderbar','Location','East');
legend('boxoff');


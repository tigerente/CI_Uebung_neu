% Skript zur Bearbeitung von Aufgabe 8.1.a

% Festlegung der Fuzzymengen mit Parametern [a,b,c,d]
% TEMPERATUR (T) im Intervall [0°C,40°C]:
intervall_T =       [0,40];
kalt =              [0,0,8,10];
etwasKalt =         [8,10,15,17];
mild =              [15,17,22,24];
sommerlichWarm =    [22,24,28,30];
hitze =             [28,30,35,37];
grosseHitze =       [35,37,40,40];

% LUFTFEUCHTIGKEIT (H) im Intervall [0%,100%]:
intervall_H =       [0,100];
extremTrocken =     [0,0,15,20];
trocken =           [15,20,35,40];
klamm =             [35,40,55,60];
schwuel =           [55,60,75,80];
nass =              [75,80,100,100];

% WINDGESCHWINDIGKEIT (W) im Intervall [0km/h,100km/h]
intervall_W =       [0,100];
windstill =         [0,0,8,10];
leichteBrise =      [8,10,20,25];
windig =            [20,25,50,55];
sturm =             [50,55,100,100];

% WWI im Intervall [0,10]
intervall_WWI =     [0,10];
furchtbar =         [0,0,2,2.5];
unangenehm =        [2,2.5,4.5,5];
gutAushaltbar =     [4.5,5,7,7.5];
wunderbar =         [7,7.5,10,10];

% Daten der Fuzzymengen fuer Plot erzeugen
% T
x_T = linspace(intervall_T(1),intervall_T(2),1000);
y_T = zeros(6,numel(x_T));
y_T(1,:) = trapez(x_T,kalt);
y_T(2,:) = trapez(x_T,etwasKalt);
y_T(3,:) = trapez(x_T,mild);
y_T(4,:) = trapez(x_T,sommerlichWarm);
y_T(5,:) = trapez(x_T,hitze);
y_T(6,:) = trapez(x_T,grosseHitze);

% H
x_H = linspace(intervall_H(1),intervall_H(2),1000);
y_H = zeros(5,numel(x_H));
y_H(1,:) = trapez(x_H, extremTrocken);
y_H(2,:) = trapez(x_H, trocken);
y_H(3,:) = trapez(x_H, klamm);
y_H(4,:) = trapez(x_H, schwuel);
y_H(5,:) = trapez(x_H, nass);

% W
x_W = linspace(intervall_W(1),intervall_W(2),1000);
y_W = zeros(4,numel(x_W));
y_W(1,:) = trapez(x_W, windstill);
y_W(2,:) = trapez(x_W, leichteBrise);
y_W(3,:) = trapez(x_W, windig);
y_W(4,:) = trapez(x_W, sturm);

% WWI
x_WWI = linspace(intervall_WWI(1),intervall_WWI(2),1000);
y_WWI = zeros(4,numel(x_WWI));
y_WWI(1,:) = trapez(x_WWI, furchtbar);
y_WWI(2,:) = trapez(x_WWI, unangenehm);
y_WWI(3,:) = trapez(x_WWI, gutAushaltbar);
y_WWI(4,:) = trapez(x_WWI, wunderbar);

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


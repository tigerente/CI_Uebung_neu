% Erstellt die Datenstruktur der Fuzzymengen fuer Aufgabe 8.1

% Festlegung der Fuzzymengen mit Parametern [a,b,c,d]
% TEMPERATUR (T) im Intervall [0�C,40�C]:
intervall_T =       [0,40];
kalt =              [0,0,8,10];
etwasKalt =         [8,10,15,17];
mild =              [15,17,22,24];
sommerlichWarm =    [22,24,30,32];
hitze =             [30,32,35,37];
grosseHitze =       [35,37,40,40];
no_T =              [0,0,40,40]; % Dummy fuer fehlende Angabe

% LUFTFEUCHTIGKEIT (H) im Intervall [0%,100%]:
intervall_H =       [0,100];
extremTrocken =     [0,0,15,20];
trocken =           [15,20,35,40];
klamm =             [35,40,55,60];
schwuel =           [55,60,75,80];
nass =              [75,80,100,100];
no_H =              [0,0,100,100]; % Dummy fuer fehlende Angabe

% WINDGESCHWINDIGKEIT (W) im Intervall [0km/h,100km/h]
intervall_W =       [0,100];
windstill =         [0,0,2,4];
leichteBrise =      [2,4,20,25];
windig =            [20,25,50,55];
sturm =             [50,55,100,100];
no_W =              [0,0,100,100]; % Dummy fuer fehlende Angabe

% WWI im Intervall [0,10]
intervall_WWI =     [0,10];
furchtbar =         [0,0,2,2.5];
unangenehm =        [2,2.5,4.5,5];
gutAushaltbar =     [4.5,5,7,7.5];
wunderbar =         [7,7.5,10,10];

% Daten der Fuzzymengen fuer Plot erzeugen
% Temperatur
x_T = linspace(intervall_T(1),intervall_T(2),1000);
y_T = zeros(6,numel(x_T));
y_T(1,:) = trapez(x_T,kalt);
y_T(2,:) = trapez(x_T,etwasKalt);
y_T(3,:) = trapez(x_T,mild);
y_T(4,:) = trapez(x_T,sommerlichWarm);
y_T(5,:) = trapez(x_T,hitze);
y_T(6,:) = trapez(x_T,grosseHitze);

% Luftfeuchtigkeit
x_H = linspace(intervall_H(1),intervall_H(2),1000);
y_H = zeros(5,numel(x_H));
y_H(1,:) = trapez(x_H, extremTrocken);
y_H(2,:) = trapez(x_H, trocken);
y_H(3,:) = trapez(x_H, klamm);
y_H(4,:) = trapez(x_H, schwuel);
y_H(5,:) = trapez(x_H, nass);

% Windgeschwindigkeit
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

% Skript zur Bearbeitung von Aufgabe 8.1.a
clear all, close all;

% Daten erzeugen mit Skript
generateFuzzyData;

% Anzahl der Regeln
numRules = 16;

ruleResults = zeros(1,numRules);
conclusion = zeros(numRules,numel(x_WWI));

% Eingaben an das FuzzySystem:
T_In = 30;      % Temperatur 30°C
H_In = 50;      % Feuchtigkeit 50%
W_In = 3;       % Winggeschwindigkeit 3 km/h

% Regel 1
ruleResults(1) = min(trapez(T_In,kalt),trapez(H_In,klamm));
conclusion(1,:) = cutTrapez(x_WWI,ruleResults(1),furchtbar);

% Regel 2
ruleResults(2) = min(trapez(T_In,sommerlichWarm),trapez(W_In,leichteBrise));
conclusion(2,:) = cutTrapez(x_WWI,ruleResults(2),wunderbar);

% Regel 3
ruleResults(3) = min(trapez(T_In,grosseHitze),trapez(W_In,windstill));
conclusion(3,:) = cutTrapez(x_WWI,ruleResults(3),furchtbar);

% Regel 4
ruleResults(4) = trapez(T_In,mild);
conclusion(4,:) = cutTrapez(x_WWI,ruleResults(4),gutAushaltbar);

% Regel 5
ruleResults(5) = min(trapez(T_In,hitze),trapez(H_In,schwuel));
conclusion(5,:) = cutTrapez(x_WWI,ruleResults(5),furchtbar);

% Regel 6
ruleResults(6) = trapez(H_In,extremTrocken);
conclusion(6,:) = cutTrapez(x_WWI,ruleResults(6),unangenehm);

% Regel 7
ruleResults(7) = min(trapez(T_In,etwasKalt),trapez(W_In,windstill));
conclusion(7,:) = cutTrapez(x_WWI,ruleResults(7),gutAushaltbar);

% Regel 8
ruleResults(8) = min(trapez(T_In,sommerlichWarm),trapez(W_In,sturm));
conclusion(8,:) = cutTrapez(x_WWI,ruleResults(8),gutAushaltbar);

% Regel 8_1
ruleResults(9) = min(trapez(T_In,kalt),trapez(W_In,sturm));
conclusion(9,:) = cutTrapez(x_WWI,ruleResults(9),furchtbar);

% Regel 8_2
ruleResults(10) = min(trapez(T_In,etwasKalt),trapez(W_In,sturm));
conclusion(10,:) = cutTrapez(x_WWI,ruleResults(10),furchtbar);

% Regel 8_3
ruleResults(11) = min(trapez(T_In,mild),trapez(W_In,sturm));
conclusion(11,:) = cutTrapez(x_WWI,ruleResults(11),unangenehm);

% Regel 8_4
ruleResults(12) = min(trapez(T_In,hitze),trapez(W_In,sturm));
conclusion(12,:) = cutTrapez(x_WWI,ruleResults(12),unangenehm);

% Regel 8_5
ruleResults(13) = min(trapez(T_In,grosseHitze),trapez(W_In,sturm));
conclusion(13,:) = cutTrapez(x_WWI,ruleResults(13),furchtbar);

% Regel 9
ruleResults(14) = min(trapez(T_In,kalt),trapez(W_In,windig));
conclusion(14,:) = cutTrapez(x_WWI,ruleResults(14),furchtbar);

% Regel 10
ruleResults(15) = min(trapez(T_In,kalt),trapez(H_In,trocken));
conclusion(15,:) = cutTrapez(x_WWI,ruleResults(15),gutAushaltbar);

% Regel 10_1
ruleResults(16) = min(trapez(T_In,kalt),trapez(H_In,nass));
conclusion(16,:) = cutTrapez(x_WWI,ruleResults(16),unangenehm);


% Plot der zusammengefuehrten Regeln
finalMemberFunc = zeros(1,numel(x_WWI));
for i=1:numel(x_WWI)
    finalMemberFunc(i) = max(conclusion(:,i));
end

figure;
plot(x_WWI, finalMemberFunc);
axis([0,10,0,1]);
xlabel('WetterWohlfühlndex');
ylabel('Zugehörigkeit');
legend('Zusammengeführte Zugehörigkeitsfunktion');
legend('boxoff');



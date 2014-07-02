% Skript zur Bearbeitung von Aufgabe 8.1.c
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
plotRule(1,3,0,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(1,:),ruleResults(1),'REGEL 1');

% Regel 2
ruleResults(2) = min(trapez(T_In,sommerlichWarm),trapez(W_In,leichteBrise));
conclusion(2,:) = cutTrapez(x_WWI,ruleResults(2),wunderbar);
plotRule(4,0,2,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(2,:),ruleResults(2),'REGEL 2');


% Regel 3
ruleResults(3) = min(trapez(T_In,grosseHitze),trapez(W_In,windstill));
conclusion(3,:) = cutTrapez(x_WWI,ruleResults(3),furchtbar);
plotRule(6,0,1,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(3,:),ruleResults(3),'REGEL 3');

% Regel 4
ruleResults(4) = trapez(T_In,mild);
conclusion(4,:) = cutTrapez(x_WWI,ruleResults(4),gutAushaltbar);
plotRule(3,0,0,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(4,:),ruleResults(4),'REGEL 4');

% Regel 5
ruleResults(5) = min(trapez(T_In,hitze),trapez(H_In,schwuel));
conclusion(5,:) = cutTrapez(x_WWI,ruleResults(5),furchtbar);
plotRule(5,4,0,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(5,:),ruleResults(5),'REGEL 5');

% Regel 6
ruleResults(6) = trapez(H_In,extremTrocken);
conclusion(6,:) = cutTrapez(x_WWI,ruleResults(6),unangenehm);
plotRule(0,1,0,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(6,:),ruleResults(6),'REGEL 6');

% Regel 7
ruleResults(7) = min(trapez(T_In,etwasKalt),trapez(W_In,windstill));
conclusion(7,:) = cutTrapez(x_WWI,ruleResults(7),gutAushaltbar);
plotRule(2,0,1,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(7,:),ruleResults(7),'REGEL 7');

% Regel 8
ruleResults(8) = min(trapez(T_In,sommerlichWarm),trapez(W_In,sturm));
conclusion(8,:) = cutTrapez(x_WWI,ruleResults(8),gutAushaltbar);
plotRule(4,0,4,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(8,:),ruleResults(8),'REGEL 8');

% Regel 8_1
ruleResults(9) = min(trapez(T_In,kalt),trapez(W_In,sturm));
conclusion(9,:) = cutTrapez(x_WWI,ruleResults(9),furchtbar);
plotRule(1,0,4,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(9,:),ruleResults(9),'REGEL 8_1');

% Regel 8_2
ruleResults(10) = min(trapez(T_In,etwasKalt),trapez(W_In,sturm));
conclusion(10,:) = cutTrapez(x_WWI,ruleResults(10),furchtbar);
plotRule(2,0,4,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(10,:),ruleResults(10),'REGEL 8_2');

% Regel 8_3
ruleResults(11) = min(trapez(T_In,mild),trapez(W_In,sturm));
conclusion(11,:) = cutTrapez(x_WWI,ruleResults(11),unangenehm);
plotRule(3,0,4,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(11,:),ruleResults(11),'REGEL 8_3');

% Regel 8_4
ruleResults(12) = min(trapez(T_In,hitze),trapez(W_In,sturm));
conclusion(12,:) = cutTrapez(x_WWI,ruleResults(12),unangenehm);
plotRule(5,0,4,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(12,:),ruleResults(12),'REGEL 8_4');

% Regel 8_5
ruleResults(13) = min(trapez(T_In,grosseHitze),trapez(W_In,sturm));
conclusion(13,:) = cutTrapez(x_WWI,ruleResults(13),furchtbar);
plotRule(6,0,4,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(13,:),ruleResults(13),'REGEL 8_5');

% Regel 9
ruleResults(14) = min(trapez(T_In,kalt),trapez(W_In,windig));
conclusion(14,:) = cutTrapez(x_WWI,ruleResults(14),furchtbar);
plotRule(1,0,3,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(14,:),ruleResults(14),'REGEL 9');

% Regel 10
ruleResults(15) = min(trapez(T_In,kalt),trapez(H_In,trocken));
conclusion(15,:) = cutTrapez(x_WWI,ruleResults(15),gutAushaltbar);
plotRule(1,2,0,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(15,:),ruleResults(15),'REGEL 10');

% Regel 10_1
ruleResults(16) = min(trapez(T_In,kalt),trapez(H_In,nass));
conclusion(16,:) = cutTrapez(x_WWI,ruleResults(16),unangenehm);
plotRule(1,5,0,x_T,x_H,x_W,x_WWI,y_T,y_H,y_W,conclusion(16,:),ruleResults(16),'REGEL 10_1');

% Plot der zusammengefuehrten Regeln
finalMemberFunc = zeros(1,numel(x_WWI));
for i=1:numel(x_WWI)
    finalMemberFunc(i) = max(conclusion(:,i));
end

figure;
plot(x_WWI, conclusion(2,:));
axis([0,10,0,1]);
xlabel('WetterWohlfühlndex');
ylabel('Zugehörigkeit');
legend('Zusammengeführte Zugehörigkeitsfunktion');
legend('boxoff');







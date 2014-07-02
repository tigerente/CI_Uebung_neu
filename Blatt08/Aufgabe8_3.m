% Skript zur Bearbeitung von Aufgabe 8.3
clear all, close all;

% Daten erzeugen mit Skript
generateFuzzyData;

%   param:      4x1 cellArray mit den Trapezfunktionsparametern aller Variablen (T,H,W,I).
%               Jede cell haelt eine Matrix mit nx4 Eintraegen, wobei n die
%               Anzahl der Fuzzymengen der einzelnen Variable ist. Die 4
%               steht fuer die Trapezfunktionsparameter

% Fuzzy-Mengen der 4 Variablen anlegen:
param = cell(4,1);
param {1} = [kalt; etwasKalt; mild; sommerlichWarm; hitze; grosseHitze; no_T];
param {2} = [extremTrocken; trocken; klamm; schwuel; nass; no_H];
param {3} = [windstill; leichteBrise; windig; sturm; no_W];
param {4} = [furchtbar; unangenehm; gutAushaltbar; wunderbar];

member_funcs = param2fuzzify(param);

% Regelbasis anlegen:
rulebase = [1,3,5,1;
            4,6,2,4;
            6,6,1,1;
            3,6,5,3;
            5,4,5,1;
            7,1,5,2;
            2,6,1,3;
            4,6,4,3;
            1,6,4,1;
            2,6,4,1;
            3,6,4,2;
            5,6,4,2;
            6,6,4,1;
            1,6,3,1;
            1,2,5,3;
            1,5,5,2];

% Beispiel-Input anlegen:
input = [1,3,5;
         1,1,2;
         4,2,2];

output = mamdani(input, member_funcs, rulebase, 'lom', [0, 10], 100);
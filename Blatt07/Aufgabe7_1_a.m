% Skript zur Bearbeitung von Aufgabe 7.1.a
clear all, close all;

% Parametersetup
xMinValue = 0;              % Untere Grenze Wertebereich x-Werte
xMaxValue = 2*pi;           % Oberer Grenze Wertebereich x-Werte

numTrain = 100;             % Anzahl der Trainingsdaten

func = @(x) sin(x);         % Zielfunktion, die eingelernt werden soll

% Trainings-, Validierungs- und Testdaten erstellen
trainX = linspace(xMinValue,xMaxValue, numTrain);
trainY = func(trainX);




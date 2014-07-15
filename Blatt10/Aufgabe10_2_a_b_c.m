% Teilaufgabe auswaehlen:
aufgabe = 'a';
%aufgabe = 'b';
%aufgabe = 'c';

% UOSLib zum Suchpfad hinzufuegen:
addpath('UOSLib');
addpath('UOSLib/src');
addpath('UOSLib/src/algorithms');

% Allgemeine Parameter:
mode = 1;
livePlot = false;
fastmode = false;
quiet = true;
rSeed = 12345;
start = 0;
nrNoise = 3; % Anzahl verschiedener Rauschwerte

% Teilaufgaben-spezifische Parameter:
if (aufgabe == 'a')
    targetFunc = struct('target', 'sine', 'ND', 300, 'NG', 100, 'noise', 0.0, 'minPath', false);
    model = struct('kind', 'GLT', 'base', 'gauss', 'N', 15);
end
if (aufgabe == 'b')
    targetFunc = struct('target', 'sine', 'ND', 300, 'NG', 100, 'noise', 0.0, 'minPath', false);
    model = struct('kind', 'Poly', 'N', 15);
end
if (aufgabe == 'c')
    targetFunc = struct('target', 'relearn', 'ND', 600, 'NG', 100, 'noise', 0.0, 'minPath', false);
    model = struct('kind', 'GLT', 'base', 'gauss', 'N', 15);
end

% Vorbereitung
noiseGrid = linspace (0, 0.1, nrNoise);
col = ['r', 'g', 'b'];
errorNames = {'CL', 'DL', 'GL'};
methodNames = {'PA', 'RLS', 'IRMA'};
pl = zeros(1,3);

% Variiere Rausch-Werte:
for noise = 1:nrNoise
    targetFunc.noise = noiseGrid(noise);
    % Variiere Lernmethoden:
    for method = 1:3
        if (method == 1)
            learnMethod = 'PA';
            algSetup.variant = 0;
            algSetup.a = 0;
        end
        if (method == 2)
            learnMethod = 'RLS';
            algSetup.S = 100;
            algSetup.g = 1;
        end
        if (method == 3)
            learnMethod = 'IRMA';
            algSetup.s = 0.1;
            algSetup.tau = 0.0;
            algSetup.variant = 1;
            algSetup.maxstiff = 10;
        end
        performance = icl_base(mode, learnMethod, algSetup, model, start, targetFunc, livePlot, fastmode, quiet, rSeed);
        % Erstelle Plots fuer aktuellen Rausch-Wert und aktuelle Lernmethode
        % Gehe drei Fehlerarten (CL, DL, GL) durch:
        for error = 1:3
            % Subplot-Zeile: Fehler-Art
            % Subplot-Spalte: Rausch-Wert
            subplot(3, nrNoise, (error-1)*nrNoise + noise);
            if (method > 1), hold on, end;
            % Linienfarbe: Lernmethode
            if (aufgabe == 'a' || aufgabe == 'c')
                % normale Achsen
                pl(method) = plot(performance(error,:), 'Color', col(method));
            else
                % logarithmische Fehler-Achse
                pl(method) = semilogy(performance(error,:), 'Color', col(method));
            end
            if (method > 1), hold off, end;
            % Beschriftungen:
            if (error == 1)
                title(['noise = ' num2str(noiseGrid(noise))]);
            end
            if (error == 3)
                xlabel('t');
            end
            if (noise == 1)
                ylabel (errorNames(error));
            end
        end
    end
end
% Legende:
legend(pl, methodNames);
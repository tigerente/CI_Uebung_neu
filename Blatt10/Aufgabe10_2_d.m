% UOSLib zum Suchpfad hinzufuegen:
addpath('UOSLib');
addpath('UOSLib/src');
addpath('UOSLib/src/algorithms');

% Allgemeine Parameter:
mode = 1;
rSeed = 12345;
start = 0;

% Teilaufgaben-spezifische Parameter:
%livePlot = false;
livePlot = true;
%fastmode = false;
fastmode = true;
%quiet = true;
quiet = false;
targetFunc = struct('target', 'sine', 'ND', 300, 'NG', 100, 'noise', 0.0, 'minPath', true);
model = struct('kind', 'GLT', 'base', 'gauss', 'N', 15);

% Vorbereitung
col = ['r', 'g', 'b'];
errorNames = {'CL', 'DL', 'GL'};
methodNames = {'PA', 'RLS', 'IRMA'};
pl = zeros(1,3);

% Variiere Lernmethoden:
for method = 2:3
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
        subplot(3, 1, error);
        if (method > 1), hold on, end;
        % Linienfarbe: Lernmethode
        pl(method) = plot(performance(error,:), 'Color', col(method));
        if (method > 1), hold off, end;
        % Beschriftungen:
        xlabel('t');
        ylabel (errorNames(error));
    end
end

% Legende:
legend(pl, methodNames);
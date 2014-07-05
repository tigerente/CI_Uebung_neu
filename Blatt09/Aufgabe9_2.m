% Parameter-Setup:
C = 3;              % Anzahl der Cluster
epsilon = 0.1;      % Abbruchgenauigkeit
R = 1;              % Anzahl an Runs (a)
disp_det = true;    % Details der Auswertung anzeigen (a)
M = 1.5;            % Unschaerfe (a)
%R = 100;            % Anzahl an Runs (b)
%disp_det = false;   % Details der Auswertung anzeigen (b)
%M = [1.3 1.5 1.7];  % Unschaerfe (b)

clc
for m = M
    correct = zeros(R,3);
    max_idx = zeros(R,3);
    doublet = zeros(R,1);
    
    display(['Unschaerfe: ' num2str(m)])
    for r = 1 : R; % Runs (wegen Zufall)
        if (disp_det)
            display(['Run ' num2str(r)])
        end
        % Daten einlesen:
        iris = csvread('iris.data');

        % Arten trennen:
        art_idx = cell(1,3);
        for i = 1:3
            art_idx{i} = find (iris(:,5) == i);
        end

        % Clusterung ausfuehren:
        U = fuzzyCMeans (iris(:,1:4), C, m, epsilon);
        [~,clusters] = max(U);

        % Ergebnis ueberpruefen:
        art_clusters = cell(1,3); % Anzahlen der Clusterzuordnungen je Art
        for i = 1:3
            art_clusters{i} = histc(clusters(art_idx{i}), 1:3); 
            if (disp_det == true)
                display(['Von den Individuen der Art ' num2str(i) ...
                ' gehören ' num2str(art_clusters{i}(1)) ' zu Cluster 1, '...
                num2str(art_clusters{i}(2)) ' zu Cluster 2 und ' ...
                num2str(art_clusters{i}(3)) ' zu Cluster 3.'])
            end
            [correct(r,i), max_idx(r,i)] = max(art_clusters{i});
        end
        if (max(histc(max_idx(r,:), 1:3))>1) % doppelt belegte Cluster
            doublet(r) = 1;
        end
    end
    
    display(['Insgesamt wurden durchschnittlich ' num2str(mean(sum(correct,2)))...
        ' Individuen einem Hauptcluster zugeordnet.']);
    display(['Es gab ' num2str(sum(doublet))...
    ' Faelle von doppelt belegten Hauptclustern.']);
    display(' ');
end
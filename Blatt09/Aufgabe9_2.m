% Parameter-Setup:
C = 3;              % Anzahl der Cluster
epsilon = 0.1;     % Abbruchgenauigkeit
R = 25;             % Anzahl an Runs
disp_det = false;   % Details der Auswertung anzeigen

correct = zeros(R,3);

clc
for m = [5.5 6 6.5];   % Unschaerfe
    display(['Unschaerfe: ' num2str(m)])
    for r = 1 : R; % Runs (wegen Zufall)
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
        art_clusters = cell(1,3);
        for i = 1:3
            art_clusters{i} = histc(clusters(art_idx{i}), 1:3); 
            if (disp_det == true)
                display(['Von den Individuen der Art ' num2str(i) ...
                ' gehören ' num2str(art_clusters{i}(1)) ' zu Cluster 1, '...
                num2str(art_clusters{i}(2)) ' zu Cluster 2 und ' ...
                num2str(art_clusters{i}(3)) ' zu Cluster 3.'])
            end
            correct(r, i) = max(art_clusters{i});
        end
    end
    
    display(['Insgesamt werden durchschnittlich ' num2str(mean(sum(correct,2)))...
        ' Individuen korrekt zugeordnet.']);
    display(' ');
end
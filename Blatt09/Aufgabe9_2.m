% Parameter-Setup:
m = 1.1;            % Unschaerfe
epsilon = 0.01;     % Abbruchgenauigkeit

% Daten einlesen:
iris = csvread('iris.data');

% Arten trennen:
art_idx = cell(1,3);
for i = 1:3
    art_idx{i} = find (iris(:,5) == i);
end

% Clusterung ausfuehren:
clusters = fuzzyCMeans (iris, m, epsilon);

% Ergebnis ueberpruefen:
art_clusters = cell(1,3);
for i = 1:3
    art_clusters{i} = histc(clusters(art_idx{i}), 1:3); 
    display(['Von den Individuen der Art ' num2str(i) ' gehören ' ...
        num2str(art_clusters{i}(1)) ' zu Cluster 1, ' num2str(art_clusters{i}(2)) ...
        ' zu Cluster 2 und ' num2str(art_clusters{i}(3)) ' zu Cluster 3.'])
end
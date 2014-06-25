% Test der besten Topologie des Autoencodernetzes

% Anzahl an runs pro Topologie
numRuns = 25;

% Topolofien, die getestet werden sollen
topologies = [3,5,7,9,11];

errors = zeros(1,numel(topologies));

% Jede Topologie testen
for t=1:numel(topologies)

    tmpErrors = zeros(1,numRuns);
    for i=1:numRuns
        tmpErrors(i) = bestTopology(topologies(t));
    end
    % Mittlerer RMSE ueber alle 25 Runs
    errors(t) = mean(tmpErrors);
end

% Plot der Daten
figure;
plot(errors,'o-r');
xlabel('Anzahl verdeckte Schichten');
ylabel('mittlerer RMSE über 25 Läufe');
set(gca,'XTick',[1,2,3,4,5]);
set(gca,'XTickLabel',{'3','5','7','9','11'});

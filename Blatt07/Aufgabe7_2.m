%% ALLGEMEIN
% Parametrierung
nTrain = 300;
nTest = 1000;
tau = 17;
nNeurons = 10;

% Zeitreihe anlegen:
t = 1 : nTrain + nTest;
x = mackeyglass(1,0,nTrain + nTest + 1)';
x_t = x(1 : nTrain + nTest);
x_t_minus_tau = [zeros(1,tau), x(1 : nTrain + nTest - tau)];
x_t_plus_1 = x(2 : nTrain + nTest + 1);

input = [x_t; x_t_minus_tau];
output = x_t_plus_1; % VORSICHT: Indizes um 1 verschoben

% MLP erzeugen:
minX = min(x);
maxX = max(x);
net = newff([minX, maxX; minX, maxX], [minX, maxX], nNeurons);

% Training:
[net, tr] = train(net, input(1:2, 1:nTrain), output(1:nTrain));

%% AUFGABE a)

% Simulation:
sim_a = net(input);

% Fehler berechnen und anzeigen:
errors_a = output(nTrain+1 : nTrain+nTest)-sim_a(nTrain+1 : nTrain+nTest);
MSE = mse(errors_a);
display(['a) MSE: ' num2str(MSE)])

%% AUFGABE b)
% Naiver Ansatz 1: x(t+1) = x(t)
sim_b_1 = x_t;
errors_b_1 = output(nTrain+1 : nTrain+nTest) - sim_b_1(nTrain+1 : nTrain+nTest);
MSE = mse(errors_b_1);
display(['b1) MSE: ' num2str(MSE)])

% Naiver Ansatz 2: x(t+1) = x(t) + (x(t) - x(t-1))
x_t_minus_1 = [0, x(1 : nTrain + nTest - 1)];
sim_b_2 = 2 * x_t - x_t_minus_1;
errors_b_2 = output(nTrain+1 : nTrain+nTest) - sim_b_2(nTrain+1 : nTrain+nTest);
MSE = mse(errors_b_2);
display(['b2) MSE: ' num2str(MSE)])

%% AUFGABE c)
% Simulation:
sim_c = [x_t_plus_1(1:nTrain), zeros(1,nTest)];
for T = (nTrain + 1 : nTrain + nTest)
    sim_c(T) = net([sim_c(T-1); sim_c(T-tau-1)]);
end

% Plot:
figure
plot (t, output, t(nTrain+1 : nTrain + nTest), sim_c(nTrain+1 : nTrain + nTest))
title(['Vorhersage über ' num2str(nTest) ' Zeitschritte'])
xlabel('t')
ylabel('x(t+1)')
legend('tatsächlicher Verlauf', 'Vorhersage')

% Fehler berechnen und anzeigen:
errors_c = output(nTrain+1 : nTrain+nTest) - sim_c(nTrain+1 : nTrain+nTest);
MSE = mse(errors_c);
display(['c) MSE: ' num2str(MSE)])
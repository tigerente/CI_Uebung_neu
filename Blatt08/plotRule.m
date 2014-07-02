function void = plotRule(T, H, W, x_T, x_H, x_W, x_WWI, y_T,y_H,y_W, conclusion, cutHeight, titleOfFig)
%PLOTRULE Summary of this function goes here
%   Detailed explanation goes here


% figure('name',title);
figure('name',titleOfFig,'units','normalized','outerposition',[0 0 1 1])
% Wenn eine Temperatur in der Regel relevant
if T ~= 0
    subplot(1,4,1);
    hold on;
    plot(x_T,y_T(T,:));
    hx = graph2d.constantline(30, 'LineStyle',':', 'Color',[.7 .7 .7]);
    changedependvar(hx,'x');
    legend('Zugehörigkeitsfunktion Temperatur','Eingabe','Location','NorthOutside');
    hold off;
    title('TEMPERATUR');
    xlabel('Temperatur in °C');
    ylabel('Zugehörigkeit');
    axis([0,40,0,1.25]);
end

% Wenn eine Feuchtigkeit in der Regel relevant
if H ~= 0
    subplot(1,4,2);
    hold on;
    plot(x_H,y_H(H,:));
    hx = graph2d.constantline(50, 'LineStyle',':', 'Color',[.7 .7 .7]);
    changedependvar(hx,'x');
    legend('Zugehörigkeitsfunktion Luftfeuchte','Eingabe','Location','NorthOutside');
    hold off;
    title('LUFTFEUCHTE');
    xlabel('Luftfeuchtigkeit in %');
    ylabel('Zugehörigkeit');
    axis([0,100,0,1.25]);
end

% Wenn eine Windgeschwindigkeit in der Regel relevant
if W ~= 0
    subplot(1,4,3);
    hold on;
    plot(x_W,y_W(W,:));
    hx = graph2d.constantline(3, 'LineStyle',':', 'Color',[.7 .7 .7]);
    changedependvar(hx,'x');
    legend('Zugehörigkeitsfunktion Windgeschwindigkeit','Eingabe','Location','NorthOutside');
    hold off;
    title('WINDGESCHWINDIGKEIT');
    xlabel('Windgeschwindigkeit in km/h');
    ylabel('Zugehörigkeit');
    axis([0,100,0,1.25]);
end

% Plot der resultierenden Aktivierungsfunktion
subplot(1,4,4);
plot(x_WWI,conclusion);
if(cutHeight ~= 0)
hy = graph2d.constantline(cutHeight, 'Color',[.7 .7 .7]);
changedependvar(hy,'y');
end
legend('resultierende Aktivierung');
hold off;
title('WWI');
xlabel('WWI');
ylabel('Zugehörigkeit');
axis([0,10,0,1.25]);
    

end


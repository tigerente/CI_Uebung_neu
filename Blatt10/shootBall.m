%function to execute and display one shot
%
% angle1 - angle of player one canon
% angle2 - angle of player two canon
% castle1 - x-y-position of first castle
% castle2 - x-y-position of second castle
% shooter - wich player should shoot
% speed - speed of canonball
% show - true to activate display of game
%
% hitCastle - true if the enemy castle was hit
% speeds - speed of the canon ball over time
% position - position where the ball dropped
function [hitCastle, position, ILS] = shootBall(angle1, angle2, castle1, castle2, shooter, speed, show, ILS, icl_learn, range)

castle_width = 6;

castle_pos = [castle1; castle2];

v0 = speed;


if(shooter == 1)
    cball_s = [castle_pos(1,1)+6 castle_pos(1,2)+3];
    sangle = angle1;
else
    cball_s = [castle_pos(2,1) castle_pos(2,2)+3];
    sangle = pi-angle2;
%     v0 = -v0;
end
state = [cball_s v0*cos(sangle) v0*sin(sangle)];
stateEst = state;
hitGround = false;
hitCastle = false;
t = 0;
dt = 0.1;

tmp = ILS{1};
ILSx = tmp;
tmp = ILS{2};
ILSy = tmp;
traj = zeros(0,2);
idx = 1;
while((~hitGround))
    %Calculate state update
    dstate = dglKugel(state)*dt;
    %Train ILS
    dataIn = state(2:end); % [y,vx,vy]
    for i=1:3
        dataIn(i) = rt(dataIn(i),range(i,:));
    end
    ypX = icl_predict(dataIn,ILSx,1);
    ypY = icl_predict(dataIn,ILSy,1);
    yp1 = icl_predict(dataIn,ILS{1},1);
    ILS{1} = icl_learn(ILS{1},dataIn,state(3)+dstate(3),yp1,1);
    yp2 = icl_predict(dataIn,ILS{2},1);
    ILS{2} = icl_learn(ILS{2},dataIn,state(4)+dstate(4),yp2,1);
    %Update state
    state = state + dstate;
    %Update state estimation
    stateEst(1:2) = stateEst(1:2) + stateEst(3:4)*dt;
    stateEst(3:4) = [ypX ypY];
    traj(idx,:) = stateEst(1:2);
    %Calculate new canon ball position
    cball = state(1:2);
    cballEst = stateEst(1:2);
    if((cball(1) < 50 && cball(2) < castle_pos(1,2)) || (cball(1) > 50 && cball(2) < castle_pos(2,2)))
        hitGround = true;
    end
    if(shooter == 1)
        if(cball(1) > castle_pos(2,1) && cball(1) < castle_pos(2,1)+castle_width && cball(2) < castle_pos(2,2)+4 && cball(2) > castle_pos(2,2))
            hitCastle = true;
            show = false;
        end
    else
        if(cball(1) > castle_pos(1,1) && cball(1) < castle_pos(1,1)+castle_width && cball(2) < castle_pos(1,2)+4 && cball(2) > castle_pos(1,2))
            hitCastle = true;
            show = false;
        end
    end
    
    if(show)
        clf
        %Canonball
        rectangle('Position',[cball-0.5 1 1],'Curvature',[1,1],'FaceColor',[0.3 0.3 0.3])
        hold on
        %Canonball estimation
        rectangle('Position',[cballEst-0.5 1 1],'Curvature',[1,1],'FaceColor',[1 0.3 0.3])
        plot(traj(:,1),traj(:,2),'k--')
        %Hill 1
        patch([0 50 50 0],[0 0 castle_pos(1,2) castle_pos(1,2)], [0 0.9 0]);
        %Castle 1
        patch(castle_pos(1,1)+[0 1 1 0], castle_pos(1,2)+[0 0 4 4],[0.2 0.2 0.6]);
        patch(castle_pos(1,1)+[1 5 5 1], castle_pos(1,2)+[0 0 3 3],[0.2 0.2 0.6]);
        patch(castle_pos(1,1)+[5 6 6 5], castle_pos(1,2)+[0 0 4 4],[0.2 0.2 0.6]);
        %Canon 1
        v = [-1 -0.5; 1 -0.5; 1 0.5; -1 0.5];
        alpha = -angle1;    %rotation of canon body
        for i=1:4           %rotate every vertex and translate to position
            v(i,:) = v(i,:)*[cos(alpha) -sin(alpha); sin(alpha) cos(alpha)];
        end
        patch(castle_pos(1,1)+6+v(:,1), castle_pos(1,2)+3+v(:,2),[0.1 0.1 0.1]);
        
        %Hill 2
        patch([50 100 100 50],[0 0 castle_pos(2,2) castle_pos(2,2)], [0 0.9 0]);
        %Castle 2
        patch(castle_pos(2,1)+[0 1 1 0], castle_pos(2,2)+[0 0 4 4],[0.6 0.2 0.2]);
        patch(castle_pos(2,1)+[1 5 5 1], castle_pos(2,2)+[0 0 3 3],[0.6 0.2 0.2]);
        patch(castle_pos(2,1)+[5 6 6 5], castle_pos(2,2)+[0 0 4 4],[0.6 0.2 0.2]);
        %Canon 2
        v = [-1 -0.5; 1 -0.5; 1 0.5; -1 0.5];
        alpha = angle2;    %rotation of canon body
        for i=1:4           %rotate every vertex and translate to position
            v(i,:) = v(i,:)*[cos(alpha) -sin(alpha); sin(alpha) cos(alpha)];
        end
        patch(castle_pos(2,1)+v(:,1), castle_pos(2,2)+3+v(:,2),[0.1 0.1 0.1]);
        
        hold off
        axis([0 100 0 30])
        pause(0.01)
    end
    t = t+dt;
    idx = idx + 1;
end

position = cball(1);
    function out = dglKugel(state)
        cw = 0.5; % Luftreibungsterm
        W = 3; % Wind
        M = 0.02896; g = 9.81; R = 8.314; T = 300;
        c = -M*g/R/T;
        x = state(1); vx = state(3);
        y = state(2); vy = state(4);
        p = exp(c*y);
%         p = 1;
        G = g*exp(-y/30);
        G = g;
        W = W*sin(y/30*2*pi)*y/15;
        
        out = [vx vy -W-vx*p*cw -G-vy*p*cw];
        if y<-300
            out(2) = 0;
            out(4) = 0;
        end
    end
    function out = rt(x,range)
        span = range(2)-range(1);
        out = (x-range(1))/span*20-10;
    end
end
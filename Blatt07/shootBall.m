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
function [hitCastle, speeds, position] = shootBall(angle1, angle2, castle1, castle2, shooter, speed, show, trajectory)

if(nargin < 8), trajectory = []; end

castle_width = 6;
speeds = [];

castle_pos = [castle1; castle2];

v0 = min(max(speed, 15), 30);
angle1 = min(max(angle1,0.2), 1);
angle2 = min(max(angle2,0.2), 1);

if(shooter == 1)
    cball_s = [castle_pos(1,1)+6 castle_pos(1,2)+3];
    sangle = angle1;
else
    cball_s = [castle_pos(2,1) castle_pos(2,2)+3];
    sangle = angle2;
    v0 = -v0;
end

hitGround = false;
hitCastle = false;
t = 0;

while((~hitGround))
    clf
    
    %Calculate new canon ball position
    if(t > 0)
        speeds = [speeds; v0*cos(sangle) abs(v0)*sin(sangle)-9.81*t];
    end
    cball = cball_s + [v0*t*cos(sangle) abs(v0)*t*sin(sangle)-9.81/2*t^2];
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

        if(~isempty(trajectory))
            plot(trajectory(1,:), 3+trajectory(2,:), '.-k')
        end
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
        pause(0.001)
    end
    t = t+0.1;
end

position = cball(1);
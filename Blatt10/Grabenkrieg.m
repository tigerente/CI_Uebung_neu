%main game routine, acting for both players alternating and counting the
%results
function [wins, ILS] = Grabenkrieg(ILS,learnMethod,algSetup,numberOfGames,show,range)
% UOSLib einbinden
addpath('src')
addpath('src/algorithms')
if nargin<2
    numberOfGames = 100;
end
if nargin<3
    show = true;
end
wins = [0 0];
ind = 1;

icl_initILS = fcnchk(['icl_initILS_' learnMethod]);
icl_learn = fcnchk(['icl_learn_' learnMethod]);
dim = 3;
ILS{1} = icl_initILS(ILS{1}, dim, algSetup);
ILS{2} = icl_initILS(ILS{2}, dim, algSetup);

for z=1:numberOfGames
    %choose castle positions randomly
    castle1 = [rand*(50-6) rand*9];
    castle2 = [rand*(50-6)+50 rand*9];
    %initial actions
    angle1 = 0; angle2 = pi/4;
    speed1 = 50; speed2 = 30;
    
    hitCastle = false;
    
    while(true)
        shooter = 1;
        %get new shooting direction and strength from MLP
        %shoot with current configuration MLP player
        [angle1 speed1] = evalShooter(ILS, castle1 + [6 0], castle2 + [3 0], range);
        [hitCastle, position, ILS] = shootBall(angle1, angle2, castle1, castle2, shooter, speed1, show, ILS, icl_learn, range);
        %accumulate training data over all games
        
        if(hitCastle)
            break;
        end
        ind = ind+1;
        
        shooter = 2;
        angle2 = rand*0.8+0.2;
        speed2 = rand*30+10;
        %get new shooting direction and strength
        %shoot with current configuration naive player
        [hitCastle, position, ILS] = shootBall(angle1, angle2, castle1, castle2, shooter, speed2, show, ILS, icl_learn, range);
        if(hitCastle)
            break;
        end
        
    end
    disp(['Player ' num2str(shooter) ' won game ' num2str(z) '!']);
    
    wins(shooter) = wins(shooter) + 1;
end
disp(['Shooter 1 won ' num2str(wins(1)) ' times, shooter 2 won ' num2str(wins(2)) ' times!']);
end
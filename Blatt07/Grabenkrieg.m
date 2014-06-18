%main game routine, acting for both players alternating and counting the
%results
numberOfGames = 100;
show = true;
wins = [0 0];
train_data = cell(0);
ind = 1;

for z=1:numberOfGames
    %choose castle positions randomly
    castle1 = [rand*(50-6) rand*9];
    castle2 = [rand*(50-6)+50 rand*9];
    %initial actions
    angle1 = 0; angle2 = 0;
    speed1 = rand*30; speed2 = rand*30;

    hitCastle = false;
    
    while(true)
        if(length(train_data) > 150)
            show = true;
        else
            show = false;
        end
        shooter = 1;
        %get new shooting direction and strength from MLP
        %shoot with current configuration MLP player
        [angle1 speed1 trajectory] = trainAndEvalShooter(train_data, castle1 + [6 0], castle2 + [3 0]);
        [hitCastle, speeds] = shootBall(angle1, angle2, castle1, castle2, shooter, speed1, show, trajectory);
        %accumulate training data over all games
        train_data{ind} = speeds;
        if(hitCastle)
            break;
        end
        ind = ind+1;

        shooter = 2;
        %get new shooting direction and strength
        %shoot with current configuration naive player
        [hitCastle, speeds, position] = shootBall(angle1, angle2, castle1, castle2, shooter, speed2, show);
        if(hitCastle)
            break;
        end
        %simple agend adaptation
        if(((castle1(1)+3)-position) < 0) %shot too near
            if(rand < 0.5)
                speed2 = speed2/0.8;
            else
                angle2 = (pi/4)*0.3+angle2*0.7;
            end
        else                       %shot too far
            if(rand < 0.5)
                speed2 = speed2*0.8;
            else
                angle2 = 0*0.3+angle2*0.7;
            end
        end
    end
    disp(['Player ' num2str(shooter) ' won game ' num2str(z) '!']);

    wins(shooter) = wins(shooter) + 1;
end
disp(['Shooter 1 won ' num2str(wins(1)) ' times, shooter 2 won ' num2str(wins(2)) ' times!']);
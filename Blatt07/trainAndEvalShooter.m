%function to train and eval an intelligent player
%
%train_data - training data accumulated up to now
%             for every shot the speeds of the canonball are saved
%             in a cell array
% ownPosition - x-y-position of own castle (x: right end, y:ground)
% target - x-y-position of target (x:center, y:ground)
function [angle speed trajectory] = trainAndEvalShooter(train_data, ownPosition, target)

%Zufällige Aktion als Fallback
%angle is limited to [0.2 1]
angle = rand*0.8+0.2;
%speed is limited to [15 30]
speed = rand*15+15;

trajectory = [];
    
end
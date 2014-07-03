% simulate multiple drivers
% driver := function_handle (or cell-array: {fh_1,fh_2,...,fh_n})
%      n := Iterations; int
%   show := visualize; bool
function fit = simCar(driver,n,show)
if(nargin < 3)
	show = false;
end
if (nargin < 2)
	n = 1000;
end
%parameters
dt = 0.1;
mindist = 5;
popSize = size(driver,1);
%start position
pos = ones(popSize,1)*[10 10];
phi = ones(popSize,1)*pi/2;
vel = ones(popSize,1)*0;
if show
	clrmap = colormap(jet(popSize));
end
%track to drive
track = [20 20; 60 25; 100 10; 140 15; 180 20; 180 50; 170 125; 130 130; 130 60; 70 60; 80 80; 85 120; 70 130; 20 130];
last = ones(popSize,1)*0;
next = mod(last,size(track,1))+1;
next2 = mod(next,size(track,1))+1;

fit = zeros(popSize,1);

%iterate through n time steps
for j=1:n
	%driver action
	action = getAction([pos phi vel], [track(next,:) track(next2,:)],driver);
	
	%restrict actions
	action = max(-1,min(1, action));
	
	%calculate physics
	simplePhysics();
	
	%test if target was hit
	hit = sum(abs(track(next,:)-pos).^2,2).^0.5<mindist;
	next = mod(next-1+hit,size(track,1))+1;
	next2 = mod(next,size(track,1))+1;
	fit = fit + hit;
	
	%visualization
	if(show)
		visualize()
	end
end


	% map position, target and fhandle to action
	function action = getAction(pos,target,param)
		action = zeros(popSize,2);
		dx1 = target(:,1)-pos(:,1);
		dx2 = target(:,3)-pos(:,1);
		dy1 = target(:,2)-pos(:,2);
		dy2 = target(:,4)-pos(:,2);
		phit1 = atan2(dy1,dx1);
		phit2 = atan2(dy2,dx2);
		r1 = (([dx1 dy1].^2)*ones(2,1)).^0.5;
		r2 = (([dx2 dy2].^2)*ones(2,1)).^0.5;
		in = [...
            pos(:,1)...
            pos(:,2)...
            pos(:,4)...
            pos(:,3)...
            phit1-pos(:,3)...
            phit2-pos(:,3)...
            r1...
            r2...
            ];
        if popSize==1 && isa(param,'function_handle')
            action(1,:) = param(in);
        else
            for i=1:popSize
                action(i,:) = param{i}(in);
            end
        end
    end


	function simplePhysics()
        steerInfluence = (abs(vel)<1).*abs(vel).^2+(1<=abs(vel)).*(abs(vel)<5)+(5<=abs(vel)).*(1-(abs(vel)-5)/5).^2;
		phi = phi + 0.28*action(:,2)*steerInfluence;
		phi(phi>pi) = phi(phi>pi)-2*pi;
		phi(phi<-pi) = phi(phi<-pi)+2*pi;
		vel = max(-10,min(10, vel*0.95 + 10*action(:,1)*dt));
		pos = pos + dt.*[vel.*cos(phi) vel.*sin(phi)];
    end


	function visualize()
		clf
		hold on
		%plot track
		plot([track(:,1); track(1,1)], [track(:,2); track(1,2)], '-oy', 'MarkerFaceColor','y', 'MarkerSize', 10)
		
		%plot car-body
		F_dim = [7 4];
		%set body vertices
		l = -F_dim(1)/2;
		r = F_dim(1)/2;
		u = F_dim(2)/2;
		d = -F_dim(2)/2;
		v0 = [l d; r d; r u; l u];
		for k=1:popSize
			alpha = -phi(k);    %rotation of body
			v = v0*[cos(alpha) -sin(alpha); sin(alpha) cos(alpha)] + ones(4,1)*pos( k,1:2);
			%draw a patch for the body
			patch(v(:,1), v(:,2),clrmap(k,:));
		end
		axis([0 200 0 150])
		pause(0.05)
	end
end













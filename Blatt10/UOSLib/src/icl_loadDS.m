% This is the data generator module to generate learning tasks.
%
%*Copyright © 2013 Universität Osnabrück
%*This file is part of the UOSLIB,
%*
%*UOSLIB is free software; you can redistribute it and/or modify it under
%*the terms of the GNU General Public License as published by the Free
%*Software Foundation; either version 3 of the License, or (at your option)
%*any later version.
%*
%*UOSLIB is distributed in the hope that it will be useful, but WITHOUT ANY
%*WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
%*FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
%*details.
%*
%*You should have received a copy of the GNU General Public License along
%*with this program; if not, write to the Free Software Foundation, Inc.,
%*59 Temple Place - Suite 330, Boston, MA  02111-1307, USA
%
% It supports various ways of getting benchmark data for experiments.
% Several synthetic sources are implemented to generate data with specific
% properties and a general interface to loading datasets from files is
% given.
% For synthetic datasets besides the training data, ground truth data (i.e.
% without noise, and equally distributed) is generated to compare the
% results.
% For datasets from files some parameters are ignored, as they only make
% sense for automatic generation (e.g. the number of training data).
% All inputs are scaled to be in [-10,10], and all outputs in [-1,1].
%
% @author Andreas Buschermöhle (andbusch(at)uos.de)
% @author Jens Hülsmann (jehuelsm(at)uos.de)
% @date 2013-1-29
% @version 1.6
%
% @input mode - operating mode (regression=1, classification=2)
%
% @input func - string, describing function to generate, you can choose from
%
%                 - 'sine'         : Sine function, 1D,
%                                    y = sin(x)
%
%                 - 'linear'       : linear function, 1D,
%                                    y = 0.1*x
%
%                 - 'poly'         : 6th order polynomial function, 1D
%
%                 - 'nonlin'       : nonlinear function, 1D,
%                                    y = 2*abs(x).*exp(-abs(x/2))-1
%
%                 - 'linear2'      : linear function, 2D,
%                                    y = 0.03*x(1)+0.07*x(2)
%
%                 - 'twocircles'   : min distance to corners function, 2D,
%                                    y = (min((norm(x-[-10 10])), (norm(x-[10 -10])))-11.39)/11.3
%
%                 - 'crossedridge' : crossed ridge function, 2D,
%                                    y = 1.6211*max([exp(-0.3*x(1)^2), exp(-0.09*x(2)^2), 1.25*exp(-0.1*(x(1)^2+x(2)^2))])-1
%
%                 - 'spiral'       : spiral loop, 2D (typical
%                                    classification task)
%
%                 - 'linear3'      : linear function, 3D,
%                                    y = 0.1*x(1)+0.3*x(2)-0.1*x(3)
%
%                 - 'highdimlin'   : linear hyperplane, 20D,
%                                    y = randn(1,dim)*x'
%
%                 - 'highdimnonlin': squareroot hyperplane, 20D,
%                                    y = randn(1,dim)*sqrt(abs(x))'
%
%                 - 'relearn'      : 3d-order-polynomial changing after
%                                    half of training data, 1D
%
%                 - 'drift'        : 7d-order-polynomial drifting from one
%                                    to another. Frist third first
%                                    polynomial, last third second
%                                    polynomial in between gradual drift.
%
%                 - 'dataset...'   : if the string starts with dataset (as
%                 a subfolder), the string will be interpreted as a relativ
%                 path to a file. The file should contain columns of inputs
%                 and one column of the target output with
%                 space-seperation.
%
% @input ND - integer > 0, number of data samples
%
% @input NG - integer >= 0, number of ground truth data samples per
%             dimenson -> a regular grid is generated
%
% @input noise - double >= 0, variance of additive gaussian noise in
%                standard deviations
%
% @input minPath - boolean, if true, the data followos a fixed path trough
%                  the training data with minimal distance between
%                  subsequent training data, starting at x_i=-10 for all i,
%                  otherwise no sorting is done, i.e. the data is random
%
% @return data - double matrix, training dataset
%
% @return groundTruth - double matrix, ground truth dataset on a regular
%                       grid (only for synthetic data)
%
% @return dim - integer > 0, number of input dimensions

function [data groundTruth dim] = icl_loadDS(mode, func, ND, NG, noise, minPath)
%default parameters
if(nargin < 6), minPath = false; end
if(nargin < 5), noise = 0; end
if(nargin < 4), error('Not enough arguments passed!'); end

%dataset generation
if(strcmp(func,'sine'))
    data(:,1) = rand(ND,1)*20-10;
    data(:,2) = sin(data(:,1));
    groundTruth(:,1) = linspace(-10,10,NG);
    groundTruth(:,2) = sin(groundTruth(:,1));
    dim = 1;
elseif(strcmp(func,'linear'))
    data(:,1) = rand(ND,1)*20-10;
    data(:,2) = 0.1*data(:,1);
    groundTruth(:,1) = linspace(-10,10,NG);
    groundTruth(:,2) = 0.1*groundTruth(:,1);
    dim = 1;
elseif(strcmp(func,'poly'))
    data(:,1) = rand(ND,1)*20-10;
    c = [1 -2/10 3/100 -1/1000 2/10000 -4/100000 -2/1000000];
    data(:,2) = c(1) + c(2)*data(:,1) + c(3)*data(:,1).^2 + c(4)*data(:,1).^3 + c(5)*data(:,1).^4 + c(6)*data(:,1).^5 + c(7)*data(:,1).^6;
    data(:,2) = (data(:,2)+3)/14;
    groundTruth(:,1) = linspace(-10,10,NG);
    groundTruth(:,2) = c(1) + c(2)*groundTruth(:,1) + c(3)*groundTruth(:,1).^2 + c(4)*groundTruth(:,1).^3 + c(5)*groundTruth(:,1).^4 + c(6)*groundTruth(:,1).^5 + c(7)*groundTruth(:,1).^6;
    groundTruth(:,2) = (groundTruth(:,2)+3)/14;
    dim = 1;
elseif(strcmp(func,'nonlin'))
    data(:,1) = rand(ND,1)*20-10;
    data(:,2) = 2*abs(data(:,1)).*exp(-abs(data(:,1)/2))-1;
    groundTruth(:,1) = linspace(-10,10,NG);
    groundTruth(:,2) = 2*abs(groundTruth(:,1)).*exp(-abs(groundTruth(:,1)/2))-1;
    dim = 1;
elseif(strcmp(func,'linear2'))
    data = zeros(ND,3);
    data(:,1:2) = rand(ND,2)*20-10;
    data(:,3) = 0.03*data(:,1)+0.07*data(:,2);
    groundTruth = zeros(NG*NG,3);
    groundTruth(:,1) = repmat(linspace(-10,10,NG),1,NG);
    groundTruth(:,2) = sort(repmat(linspace(-10,10,NG),1,NG)); %neat trick to generate a grid
    groundTruth(:,3) = 0.03*groundTruth(:,1)+0.07*groundTruth(:,2);
    dim = 2;
elseif(strcmp(func,'twocircles'))
    data = zeros(ND,3);
    data(:,1:2) = rand(ND,2)*20-10;
    for i=1:ND
        data(i,3) = (min((norm(data(i,1:end-1)-[-10 10])), (norm(data(i,1:end-1)-[10 -10])))-11.39)/11.3;
    end
    groundTruth = zeros(NG*NG,3);
    groundTruth(:,1) = repmat(linspace(-10,10,NG),1,NG);
    groundTruth(:,2) = sort(repmat(linspace(-10,10,NG),1,NG));%neat trick to generate a grid
    for i=1:size(groundTruth,1)
        groundTruth(i,3) = (min((norm(groundTruth(i,1:end-1)-[-10 10])), (norm(groundTruth(i,1:end-1)-[10 -10])))-11.3)/11.3;
    end
    dim = 2;
elseif(strcmp(func,'crossedridge'))
    data = zeros(ND,3);
    data(:,1:2) = rand(ND,2)*20-10;
    for i=1:ND
        data(i,3) = 1.6211*max([exp(-0.3*data(i,1)^2), exp(-0.09*data(i,2)^2), 1.25*exp(-0.1*(data(i,1)^2+ data(i,2)^2))])-1;
    end
    groundTruth = zeros(NG*NG,3);
    groundTruth(:,1) = repmat(linspace(-10,10,NG),1,NG);
    groundTruth(:,2) = sort(repmat(linspace(-10,10,NG),1,NG));
    for i=1:size(groundTruth,1)
        groundTruth(i,3) = 1.6211*max([exp(-0.3*groundTruth(i,1)^2), exp(-0.09*groundTruth(i,2)^2), 1.25*exp(-0.1*(groundTruth(i,1)^2+ groundTruth(i,2)^2))])-1;
    end
    dim = 2;
elseif(strcmp(func,'spiral'))
    t = linspace(0,6*pi,1000);
    x = t.*cos(t)/2;
    y = t.*sin(t)/2;
    x0=5;
    y0=5;
    data =zeros(ND,3);
    data(:,1:2)=rand(ND,2)*20-10;
    for j = 1:ND
        for i = 1:length(t)
            n(i) = norm([x(i) y(i)]-[data(j,1) data(j,2)]);
        end
        data(j,3)=max(min(2,min(n))-1,-1);
    end
    groundTruth = zeros(NG*NG,3);
    groundTruth(:,1) = repmat(linspace(-10,10,NG),1,NG);
    groundTruth(:,2) = sort(repmat(linspace(-10,10,NG),1,NG));
    for j = 1:size(groundTruth,1)
        for i = 1:length(t)
            n(i) = norm([x(i) y(i)]-[groundTruth(j,1) groundTruth(j,2)]);
        end
        groundTruth(j,3)=max(min(2,min(n))-1,-1);
    end
    dim = 2;
elseif(strcmp(func,'linear3'))
    data(:,1) = rand(ND,1)*20-10;
    data(:,2) = rand(ND,1)*20-10;
    data(:,3) = rand(ND,1)*20-10;
    data(:,4) = 0.1*data(:,1)+0.3*data(:,2) -0.1*data(:,3);
    groundTruth(:,1) = linspace(-10,10,NG);
    groundTruth(:,2) = linspace(-10,10,NG);
    groundTruth(:,3) = linspace(-10,10,NG);
    groundTruth(:,4) = 0.1*groundTruth(:,1)+0.3*groundTruth(:,2) -0.1*groundTruth(:,3);
    dim = 3;
elseif(strcmp(func,'highdimlin'))
    dim = 20;
    w = randn(1,dim);
    data = zeros(ND,dim+1);
    data(:,1:dim) = rand(ND,dim)*20-10;
    for i=1:ND
        data(i,dim+1) = w*data(i,1:dim)';
    end
    groundTruth = zeros(NG,dim+1);
    groundTruth(:,1:dim) = rand(NG,dim)*20-10;
    for i=1:NG
        groundTruth(i,dim+1) = w*groundTruth(i,1:dim)';
    end
elseif(strcmp(func,'highdimnonlin'))
    dim = 20;
    w = randn(1,dim);
    data = zeros(ND,dim+1);
    data(:,1:dim) = rand(ND,dim)*20-10;
    for i=1:ND
        data(i,dim+1) = w*sqrt(abs(data(i,1:dim)))';
    end
    groundTruth = zeros(NG,dim+1);
    groundTruth(:,1:dim) = rand(NG,dim)*20-10;
    for i=1:NG
        groundTruth(i,dim+1) = w*sqrt(abs(groundTruth(i,1:dim)))';
    end
elseif(strcmp(func,'relearn'))
    p1 = [-6.6 2 0.1 -0.05]*0.03;
    p2 = [-6.6 2 0.1 -0.05]*-0.03;
    data(:,1) = rand(ND,1)*20-10;
    data(1:floor(ND/2),2) = p1(1)+p1(2)*data(1:floor(ND/2),1)+p1(3)*data(1:floor(ND/2),1).^2+p1(4)*data(1:floor(ND/2),1).^3;
    data(floor(ND/2)+1:end,2) = p2(1)+p2(2)*data(floor(ND/2)+1:end,1)+p2(3)*data(floor(ND/2)+1:end,1).^2+p2(4)*data(floor(ND/2)+1:end,1).^3;
    groundTruth(:,1) = linspace(-10,10,NG);
    groundTruth(:,2) = p1(1)+p1(2)*groundTruth(:,1)+p1(3)*groundTruth(:,1).^2+p1(4)*groundTruth(:,1).^3;
    dim = 1;
elseif(strcmp(func,'drift'))
    %parameter of first polynomial
    c1 = [-0.1507 0.1802 -9.5097e-04 -1.9499e-04 -1.2643e-06 -2.2160e-05 1.2576e-06]/1.6;
    %parameter of second polynomial
    c2 = [-0.5471 -0.0690 0.0037 6.7908e-04 1.0338e-04 7.5788e-06 -6.0123e-07];
    %ratio of data for first function, drift, and second function
    f = 1/3; o = 1/3; s = 1/3;
    F = ceil(ND*f);
    O = ceil(ND*o);
    a = linspace(0,1,O);
    data(:,1) = rand(ND,1)*20-10;
    data(:,2) = zeros(ND,1);
    for n=1:ND
        idx = min(O, max(1, n-F));
        data(n,2) = polyval(fliplr(a(idx)*c1+(1-a(idx))*c2), data(n,1));
    end
    groundTruth(:,1) = linspace(-10,10,NG);
    groundTruth(:,2) = zeros(NG,1);
    dim = 1;
elseif(strcmp(func(1:7),'dataset'))
    data = load(func);
    dim = size(data,2)-1;
    for i=1:dim
        data(:,i) = (data(:,i)-min(data(:,i)))/(max(data(:,i))-min(data(:,i)))*20-10;
    end
    data(:,end) = (data(:,end)-min(data(:,end)))/(max(data(:,end))-min(data(:,end)))*2-1;
    ND = size(data,1);
    groundTruth = data;
    NG = ND;
    idx = randperm(ND);
    data = data(idx,:);
else
    error('Unknown function!');
end

if(minPath) %sort data by nearest neighbour starting at [-10 -10]
    p = -10*ones(1,dim);
    dataS = zeros(size(data));
    for i=1:ND
        [d ix] = min(sum(abs(bsxfun(@minus,data(:,1:dim), p)),2));
        dataS(i,:) = data(ix,:);
        p = dataS(i,1:dim);
        data(ix,:) = [];
    end
    data = dataS;
end

data(:,end) = data(:,end) + randn(ND,1)*noise; %add noise

if(mode == 2) %binarize output for classification tasks
    data(:,end) = sign(data(:,end));
    groundTruth(:,end) = sign(groundTruth(:,end));
end
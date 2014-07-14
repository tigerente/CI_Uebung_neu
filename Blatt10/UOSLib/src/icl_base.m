% This is the main function for running an experiment.
%
%*Copyright © 2013 Universität Osnabrück
%*This file is part of the UOSLIB,
%*
%*UOSLIB is free software; you can use it and/or modify it under the terms
%*of the GNU General Public License as published by the Free Software
%*Foundation; either version 3 of the License, or (at your option) any
%*later version.
%*
%*UOSLIB is distributed in the hope that it will be useful for studies and
%*research work on learning systems. But it comes WITHOUT ANY WARRANTY;
%*without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
%*PARTICULAR PURPOSE. See the GNU General Public License for more details.
%*
%*You should have received a copy of the GNU General Public License along
%*with this program; if not, write to the Free Software Foundation, Inc.,
%*59 Temple Place - Suite 330, Boston, MA  02111-1307, USA
%
% UOSLIB - Unified Online-learning Systems LIBrary
% of incremental learning algorithms
%
% This is the main function for running experiments. Experiments can be
% either done by calling this function from a specific script or by running
% this script and filling out the default parameters as needed.
% The script performs one run with a learning method on a specific task and
% gives the results.
% The data which is used for online learning is scaled to [-10, 10] on the
% input dimensions and [-1,1] on the output, to allow for comparison
% between different learning algorithms and approximation structures.
%
% @author Andreas Buschermöhle (andbusch(at)uos.de)
% @author Jens Hülsmann (jehuelsm(at)uos.de)
% @date 2013-11-29
% @version 1.6
%
% @input mode - should be set to 1 for regression or 2 for classification
%
% @input learnMethod - String specifying the learning method to adapt the
%                      parameter vector (see subfolder algorithms)
%
% @input algSetup - algorithm specific setup parameters
%
%                   AROW, algSetup.r - use bigger r for noisy data and more
%                                      stability
%
%                   CW, algSetup.p - desired probability of correct
%                                    classification
%
%                   GH, algSetup.variant - GH matrix variants: 0 - Full,
%                                          1 - Exact, 2 - Drop, 3 - Project
%                     , algSetup.C - rate of adaptation the bigger, the more
%                                  adaptation is done
%
%                   IRMA, algSetup.s - stiffness, algSetup.tau - growth
%                         rate, algSetup.variant - Stiffnes increase
%                         variants: 1 - Additive, 2 - Multiplicative,
%                         3 - Sigmoidal, algSetup.maxstiff - maximum
%                         stiffnes for sigmoidal increase
%
%                   PA, algSetup.variant - PA variants: 0 - basic PA,
%                       1 - basic PA-I, 2 - basic PA-II, 
%                       algSetup.a - aggressiveness
%
%                   RLS, algSetup.S - initial variance, 
%                        algSetup.g - forgetting factor
%
% @input model - structure, describing the model to be used for learning
%
%                   regular Grid based Lookup Table, 
%                     model.kind = 'GLT', 
%                     model.base = 'gauss', 'lin', 
%                     model.N - number of grid points
%
%                   arbitrary Grid based Lookup Table, 
%                     model.kind = 'GLTarb', 
%                     model.base = 'gauss', 'lin', 
%                     model.loc - locations of the grid points
%
%                   Polynomial, 
%                     model.kind = 'Poly', 
%                     model.N - polynomial order
%
% @input start - double, specifying an initial value for all parameters
%             or double vector, specifying an initial parameter vector
%
% @input targetFunc - Struct specifying the target function, learning data
%                     should be generated from. It must contain the
%                     following fields:
%
%                       targetFunc.target - string selecting the target
%                                           function
%
%                       targetFunc.ND - number of training data to generate
%
%                       targetFunc.NG - number of ground truth data to
%                                       generate for comparison
%
%                       targetFunc.noise - variance of normally distributed
%                                          noise on training data
%
%                       targetFunc.minPath - should be set to true to
%                                            order the data in input space,
%                                            false for random order
%
% @input livePlot - boolean, should be set to true to visualize resulting
%                   approximation after every learning step
%
% @input fastmode - boolean, should be set to true to skip evaluation of
%                   loss on ground truth and training data to speedup the
%                   procedure
%
% @input quiet - boolean, should be set to true to prevent all console
%                outputs and plots
%
% @input rSeed - integer, seed of the random number generator
%
% @return performance - double matrix, performance measures as a matrix:
%                       (measure X time)
%
% @return paramSave - double matrix, parameter vector as matrix: 
%                     (param X time)
%
% @return ILS - final ILS representation
%
% @return data - training data used
%
% @return groundTruth - ground truth data used
%
% @return dim - dimensionality of the data

function varargout = icl_base(mode, learnMethod, algSetup, model, start, targetFunc, livePlot, fastmode, quiet, rSeed)
%general setup
REG = 1; CLA = 2; %define operation modes
if(nargin == 0)
    scriptMode = true;
    addpath('algorithms');
else
    scriptMode = false;
end
%choose the operating mode
if(nargin < 1), mode = REG; end
%learning method
if(nargin < 2), learnMethod = 'IRMA'; end
%algorithm setup
if(nargin < 3)
    %IRMA
    algSetup.s = 0.1; algSetup.tau = 0.0; algSetup.variant = 1; algSetup.maxstiff = 10;
    %PA
%     algSetup.variant = 0; algSetup.a = 1;
    %RLS
%     algSetup.S = 100000; algSetup.g = 1;
end
%model structure to learn with
if(nargin < 4)
    model = struct('kind', 'GLT', 'base', 'gauss', 'N', 15);
%     model = struct('kind', 'GLT', 'base', 'lin', 'N', 15);
%     model = struct('kind', 'GLTarb', 'base', 'lin'); model.loc = {[-10 -7 -3 0 3 7 10]};
%     model = struct('kind', 'Poly', 'N', 10);
end
%initial parameter vector
if(nargin < 5)
    start = 0;    %initialize parameter vector to zero
end
%target function
if(nargin < 6)
    targetFunc.target = 'sine';
    targetFunc.ND = 300;
    targetFunc.NG = 100;
    targetFunc.noise = 0.1;
    targetFunc.minPath = false;
end
%choose to view resulting approximation after every learning step
if(nargin < 7), livePlot = true; end
%skip evaluation of loss on ground truth and data to speedup the procedure
if(nargin < 8), fastmode = true; end
%no messages or plots
if(nargin < 9), quiet = false; end
%random seed for repeatability
if(nargin < 10), rSeed = 12345; end

%old version of controlling the random seed for matlab backwards compatability
rand('seed',rSeed); % set the rand-seed to assure the same numbers every run
randn('seed',rSeed);% change seed to test for robustnes

%load dataset from file: gives training data, ground truth data and dimensionality
[data groundTruth dim] = icl_loadDS(mode, targetFunc.target, targetFunc.ND, targetFunc.NG, targetFunc.noise, targetFunc.minPath);

ND = size(data,1);          %number of training data
NGT = size(groundTruth,1);  %number of ground truth data
%select loss function depending on operating mode
if(mode==REG)
    loss = @(x,y)(x-y)^2;
elseif(mode==CLA)
    loss = @(x,y)(x~=y);
end

%set the model structure
if(strcmp(model.kind, 'GLT'))
    ILS = icl_genGLT(model.N, dim, model.base);  %grid based lookup table
elseif(strcmp(model.kind, 'GLTarb'))
    ILS = icl_genGLTarb(model.loc, dim, model.base); %arbitrary grid
elseif(strcmp(model.kind, 'Poly'))
    ILS = icl_genPoly(model.N, dim);        %polaynomial approximator
end

%set the initial parameter vector
if(length(start) == 1)  %use one init value for all
    ILS.alpha = ones(size(ILS.phi))*start;
else                    %or complete init vector
    ILS.alpha = start;
end

%link the correct initialization and learning functions
icl_initILS = fcnchk(['icl_initILS_' learnMethod]);
icl_learn = fcnchk(['icl_learn_' learnMethod]);

%initialize the learning system with algortihm specific parameters
ILS = icl_initILS(ILS, dim, algSetup);

%initialize performance measures
performance = zeros(3,ND);
paramSave = zeros(length(ILS.phi),ND+1);
paramSave(:,1) = start;
CL = 1; DL = 2; GL = 3;

%% run through dataset
lastp = 0;
for i=1:ND
    %present new x
    x = data(i,1:end-1);
    
    %predict its label yp
    yp = icl_predict(x, ILS, mode);
    
    %present true label y
    y = data(i,end);
    
    %adapt parameters
    ILS = icl_learn(ILS, x, y, yp, mode);
    
    %save parameter vector
    paramSave(:,i+1) = ILS.alpha;
    
    %calculate performance measures: cumulative loss, data loss, ground
    %truth loss
    performance(CL,i) = performance(CL,max(1,i-1)) + loss(yp,y); %cumulative loss
    if(~fastmode)
        for j=1:i   %data loss (loss to all presented training data)
            xl = data(j,1:end-1);
            ylp = icl_predict(xl, ILS, mode);
            yl = data(j,end);
            performance(DL,i) = performance(DL,i) + loss(yl, ylp)/i;
        end
        for j=1:NGT     %ground truth loss
            xl = groundTruth(j,1:end-1);
            ylp = icl_predict(xl, ILS, mode);
            yl = groundTruth(j,end);
            performance(GL,i) = performance(GL,i) + loss(yl, ylp)/NGT;
        end
    end
    if(livePlot && ~quiet)
        %show resulting function after every step
        icl_showResult(mode, data(1:i,:), groundTruth, ILS, dim);
        pause(0.01)
    end
    if(~quiet && i/ND > lastp)
        disp([num2str(lastp*100) '%']);
        lastp = lastp+0.1;
    end
end
if(~quiet)
    disp(['Resulting cumulative loss: ' num2str(performance(CL,end))]);
end

%display results
if(~quiet)
    figure(1)
    subplot(3,1,1)
    plot(performance(CL,:));
    title('Cumulative');
    xlabel('training steps');
    ylabel('loss');

    subplot(3,1,2)
    plot(performance(DL,:));
    title('Previous Data');
    xlabel('training steps');
    ylabel('loss');

    subplot(3,1,3)
    plot(performance(GL,:));
    title('Ground Truth');
    xlabel('training steps');
    ylabel('loss');

    %show resulting function
    icl_showResult(mode, data, groundTruth, ILS, dim);
end

%for 2D-parameter vectors show how the parameters evolved
if(length(ILS.phi)==2 && ~quiet)
    figure(3)
    plot(paramSave(1,:), paramSave(2,:), '.-k')
    xlabel('\omega_1')
    ylabel('\omega_2')
    title(['Evolution of parameter vector over time (' learnMethod ')'])
end
if(scriptMode)
    assignin('base', 'performance', performance);
    assignin('base', 'paramSave', paramSave);
    assignin('base', 'ILS', ILS);
    assignin('base', 'data', data);
    assignin('base', 'groundTruth', groundTruth);
    assignin('base', 'dim', dim);
else
    varargout = {performance, paramSave, ILS, data, groundTruth, dim};
end
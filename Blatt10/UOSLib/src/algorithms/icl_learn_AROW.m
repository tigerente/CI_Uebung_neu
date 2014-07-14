% AROW learning algorithm.
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
% AROW - Adaptive Regularization of Weight Vectors
%
% Reference:
% Crammer, K., Kulesza, A., Dredze, M., et al.: Adaptive regularization of weight vectors.
% Advances in Neural Information Processing Systems 22, 414-422 (2009),
% http://www.cis.upenn.edu/~kulesza/pubs/arow_nips09.pdf
%
% @author Sebastian Pütz (spuetz(at)uos.de)
% @author Andreas Buschermöhle (andbusch(at)uos.de)
% @date 2013-07-13
% @version 1.5
%
% @input ILS - structure describing the learning system
%
% @input x - double input vector in [-10,10]
%
% @input y - true label, i.e. target value of the example, in [-1, 1] for
%            regression or [-1; 1] for classification
%
% @input yp - predicted label, i.e. current output of the approximation, in
%             [-1, 1] for regression or [-1; 1] for classification
%
% @input mode - operating mode (regression=1, classification=2)
%
% @return ILS - updated matlab structure describing the learning system
function ILS = icl_learn_AROW(ILS, x, y, yp, mode)

% Meaning of the variables
% 
% PAPER     -     CODE
% --------------------
% x_t       -     phix
% m         -     m
% v         -     v
% sigma_t   -     s
% mu_t      -     u
% r         -     r

% r lambda1 = lambda2 = 1/2r  formula(1) in paper

% read values
r = ILS.r;      % tuning parameter
s = ILS.s;      % sigma
u = ILS.alpha;  % mu

% convert x to parameter space
phix = icl_transform(x, ILS);

% compute the margin m
m = u' * phix;

v = phix * s * phix';   % confidence
b = 1 / (v + r);

if (mode == 1)       % mode = REG
    a = (y-yp) * b;
    % update mu
    newAlpha = u + (a * s * phix')';
    % update sigma
    ILS.s = s - b * s * phix' * phix * s;
else                 % mode = CLA
    % only update if the margin is exceeded (m*y < 1)
    if(m*y < 1)
        a = max(0, 1 - y * phix * u') * b;
        % update mu
        newAlpha = u + (a * s * y * phix')';
        % update sigma
        ILS.s = s - b * s * phix' * phix * s;
    end
end

%update ILS with new parameter vector
ILS = icl_updateILS(ILS, newAlpha, phix);
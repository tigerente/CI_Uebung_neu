% IRMA learning algorithm.
%
%*Copyright � 2013 Universit�t Osnabr�ck
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
% IRMA - Incremental Risk Minimization Algorithm
%
% Reference:
% Buschermoehle, A.; Schoenke, J.; Rosemann, N.; Brockmann, W.:
% The Incremental Risk Functional: Basics of a Novel Incremental Learning Approach.
% IEEE International Conference on Systems Man and Cybernetics (SMC), to appear (2013)
%
% @author Andreas Buscherm�hle (andbusch(at)uos.de)
% @date 2013-08-20
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
function ILS = icl_learn_IRMA(ILS, x, y, yp, mode)

% convert x to parameter space
phix = icl_transform(x, ILS);

%generate B-matrix of IRMA
B = phix'*phix;

%update parameters
%special treatment for stiffness of zero
% the general form has no solution in this case, but the limit exists
if(ILS.s == 0)
    Ainv = ILS.A^(-1);
    newAlpha = ILS.alpha' + Ainv*phix' * (y-yp)/(phix*Ainv*phix');
else  %otherwise full solution with stiffnes > 0
    newAlpha = (ILS.s*ILS.A+B)^(-1)*((ILS.s*ILS.A*ILS.alpha')' + (phix*y))';
end
%increase stiffness
if(ILS.variant == 1)%additive
    ILS.s = ILS.s+ILS.tau;
elseif(ILS.variant == 2)%multiplicative
    ILS.s = ILS.s*ILS.tau;
else %sigmoid
    ILS.s = 0.5*(1+ tanh((-log(1/(ILS.s/ILS.maxstiff)-1)+ILS.tau)/2))*ILS.maxstiff;
end
%update ILS with new parameter vector
ILS = icl_updateILS(ILS, newAlpha', phix);

if(mode == 2)
    warning('IMRA is currently only designed for regression. Correct results for classification are not guaranteed.');
end
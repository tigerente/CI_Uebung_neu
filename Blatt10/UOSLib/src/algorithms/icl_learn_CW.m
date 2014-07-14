% CW learning algorithm.
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
% CW - Confidence Weighted Learning
%
% Reference:
% Dredze, M., Crammer, K., Pereira, F.: Confidence-weighted linear classification.
% In: Proceedings of the 25th International Conference on Machine Learning, pp. 264-271. ACM (2008)
% http://webee.technion.ac.il/people/koby/publications/icml08_variance.pdf
%
% @author Simon Herkenhoff (sherkenh(at)uos.de)
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
function ILS = icl_learn_CW(ILS, x, y, yp, mode)

% convert x to parameter space
phix = icl_transform(x, ILS);

% compute margin
m = y * (phix * ILS.alpha');
% compute confidence
v = phix * ILS.sigma * phix';
% compute amount of adaptation
a = max(0, (- (1+2*ILS.p*m) + sqrt( (1+2*ILS.p*m)^2 - 8*ILS.p*(m-ILS.p*v)))/(4*ILS.p*v));

% update parameter vector
newAlpha = ILS.alpha + (a * y * ILS.sigma * phix')';
% update covariance matrix
ILS.sigma = inv(inv(ILS.sigma) + 2 * a * ILS.p * diag(phix));

%update ILS with new parameter vector
ILS = icl_updateILS(ILS, newAlpha, phix);

if(mode == 1)
    warning('CW is designed for classification.');
end
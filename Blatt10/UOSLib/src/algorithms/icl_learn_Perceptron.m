% Perceptron learning algorithm.
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
% Classical Perceptron Algorithm
%
% Reference:
% Rosenblatt, F.: The perceptron: A probabilistic model for information storage and organization in the brain.
% Psychological Review 65, 386–407, 1958.
%
% @author Andreas Buschermöhle (andbusch(at)uos.de)
% @date 2013-03-13
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
function ILS = icl_learn_Perceptron(ILS, x, y, yp, mode)

% convert x to parameter space
phix = icl_transform(x, ILS);
%get normalization for gradient step size
nor = sum(phix.^2);

%update parameter vector
if(mode == 1) %REG
    newAlpha = ILS.alpha + phix*(y-yp);
else %CLA
    if(y ~= yp)
        newAlpha = ILS.alpha + phix*y;
    end
end

%update ILS with new parameter vector
ILS = icl_updateILS(ILS, newAlpha, phix);
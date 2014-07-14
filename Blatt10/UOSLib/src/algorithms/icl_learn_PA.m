% PA learning algorithm.
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
% PA - Passive-Aggressive (with variants PA, PA-I and PA-II)
%
% Reference:
% Crammer, K., Dekel, O., Keshet, J., Shalev-Shwartz, S., Singer, Y.: Online passive-aggressive algorithms.
% The Journal of Machine Learning Research 7, 551-585 (2006),
% http://webee.technion.ac.il/people/koby/publications/crammer06a.pdf
%
% @author Andreas Buschermöhle (andbusch(at)uos.de)
% @author Julian Imwalle (jimwalle(at)uos.de)
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
function ILS = icl_learn_PA(ILS, x, y, yp, mode)

% convert x to parameter space
phix = icl_transform(x, ILS);
%get normalization for gradient step size
nor = sum(phix.^2);

%update parameter vector
if(ILS.variant == 0) % basic PA
    if(mode == 1) %REG
        newAlpha = ILS.alpha + phix*(y-yp)/nor;
    else %CLA
        newAlpha = ILS.alpha + phix*y*(max(0,1-yp*y))/nor;
    end
elseif(ILS.variant == 1) %PA-I
    if(mode == 1) %REG
        newAlpha = ILS.alpha + phix*max(-ILS.aggressiveness, min(ILS.aggressiveness, (y-yp)))/nor;
    else %CLA
        newAlpha = ILS.alpha + phix*y*min(ILS.aggressiveness, (max(0,1-yp*y))/nor);
    end
else %PA-II
    if(mode == 1) %REG
        newAlpha = ILS.alpha + phix*(y-yp)/(nor+(1/(2*ILS.aggressiveness)));
    else %CLA
        newAlpha = ILS.alpha + phix*y*(max(0,1-yp*y))/(nor+(1/(2*ILS.aggressiveness)));
    end
end
%update ILS with new parameter vector
ILS = icl_updateILS(ILS, newAlpha, phix);
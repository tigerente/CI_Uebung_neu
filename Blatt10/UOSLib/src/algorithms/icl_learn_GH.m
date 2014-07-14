% GH learning algorithm.
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
% GH - Gaussian Herding (with variants full, exact, drop and project)
%
% Reference:
% Crammer, K., Lee, D.: Learning via Gaussian Herding.
% Advances in Neural Information Processing Systems 23, 414-422 (2010),
% http://webee.technion.ac.il/people/koby/publications/gaussian_mob_nips10.pdf
%
% @author Jan Hendrik Schoenke (jschoenk(at)uos.de)
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
function ILS = icl_learn_GH(ILS, x, y, yp, mode)

% convert x to parameter space
phix = icl_transform(x, ILS);

%update of parameter vector is the same for all variants
if(mode == 1)%REG
    if yp~=y
        newAlpha = ILS.alpha + ...
        ((y-yp)/(phix*ILS.sigma*phix'+1/ILS.C)*ILS.sigma*phix')';
    end
else %CLA
    if yp*y<=1
        newAlpha = ILS.alpha + ...
            (y*(max(0,1-y*yp))/(phix*ILS.sigma*phix'+1/ILS.C)*ILS.sigma*phix')';
    end
end

%update ILS with new parameter vector
ILS = icl_updateILS(ILS, newAlpha, phix);

%update of sigma matrix differs for the variants
if(ILS.variant == 0) % full
    ILS.sigma = ILS.sigma - ...
            ILS.sigma*(phix'*phix)*ILS.sigma*(ILS.C^2*phix*ILS.sigma*phix'+2*ILS.C)/(1+ILS.C*phix*ILS.sigma*phix')^2;

elseif(ILS.variant == 1) %exact
    S = diag(ILS.sigma);
    for i=1:numel(S)
        S(i) = S(i)/((1+ILS.C*phix(i)^2*S(i))^2);
    end
    ILS.sigma = diag(S);
    
elseif(ILS.variant == 2) % drop
    S = diag(ILS.sigma);
    S2 = S;
    for i=1:numel(S)
        S2(i) = S(i)-(S(i)*phix(i)')^2*(ILS.C^2*phix*ILS.sigma*phix'+2*ILS.C)/(1+ILS.C*phix*ILS.sigma*phix')^2;
    end
    ILS.sigma = diag(S2);
    
elseif(ILS.variant == 3) % project
    S = diag(ILS.sigma);
    S2 = S;
    for i=1:numel(S)
        S2(i) = 1/((1/S(i))+(2*ILS.C+ILS.C^2*phix*ILS.sigma*phix')*phix(i)^2);
    end
    ILS.sigma = diag(S2);
end
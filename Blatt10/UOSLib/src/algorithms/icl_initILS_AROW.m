% AROW specific initialization of ILS.
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
% @date 2013-11-21
% @version 1.6
%
% @input ILS - matlab structure describing the learning system
%
% @input dim - integer > 0, number of dimensions
%
% @input algSetup - algorithm specific setup parameters
%
% @return ILS - matlab structure describing the learning system

function ILS = icl_initILS_AROW(ILS, dim, algSetup)

if(nargin < 3) %default setup
    ILS.r = 0.9;
else
    ILS.r = algSetup.r;    % use bigger r for noisy data and more stability
end

ILS.s = eye(length(ILS.phi));   % sigma = I(matrix)
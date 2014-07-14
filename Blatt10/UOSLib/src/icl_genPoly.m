% Generate a polynomial approximation structure.
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
% The polynomial structure is generated as additive polynomials for each
% input dimension up to the specified order, i.e. no cross terms are
% included.
%
% @author Andreas Buschermöhle (andbusch(at)uos.de)
% @author Jens Hülsmann (jehuelsm(at)uos.de)
% @date 2013-06-23
% @version 1.5
%
% @input order - integer >= 0, order of the polynomials for each dimension
%
% @input dim - integer > 0, number of dimensions
%
% @return ILS - matlab structure describing the learning system

function ILS = icl_genPoly(order, dim)

ILS.kind = 'poly';                  %specify kind for dedicated reaction
ILS.dim = dim;                      %save input dimensionality
ILS.order = order;                  %save order of polynom
ILS.phi = cell(1, dim*(order)+1);   %get space for the base functions
ILS.phi{1} = (@(x)1);               %one offset base function and ...
for j=1:dim                         %for each input dimension ...
    for i=1:order                   %one base function of every order
        ILS.phi{(j-1)*(order) + i+1} = (@(x)x(j)^i);
    end
end

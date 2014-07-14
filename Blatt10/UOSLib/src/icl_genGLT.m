% Generate a grid-based lookup table approximation structure.
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
% Range of the inputs is always [-10,10]. The base functions are
% distributed linearly accross the dimension and result in a regular grid.
% On these grid nodes either triangular or gaussian radial basis functions
% are placed, resulting in different interpolations.
%
% @author Andreas Buschermöhle (andbusch(at)uos.de)
% @author Jens Hülsmann (jehuelsm(at)uos.de)
% @date 2013-11-29
% @version 1.6
%
% @input num - integer > 0, number of base functions per dimension
%
% @input dim - integer > 0, number of dimensions
%
% @input base - string, base function of the grid, choose between
%
%                - 'lin' for triangular, i.e. linear interpolation
%
%                - 'gauss' for gaussian
%
% @return ILS - matlab structure describing the learning system

function ILS = icl_genGLT(num, dim, base)
if(nargin < 3), base = 'lin'; end

if(strcmp(base,'lin'))
    ILS.kind = 'GLTlin';         %specify kind for dedicated reaction
elseif(strcmp(base,'gauss'))
    ILS.kind = 'GLTgauss';       %specify kind for dedicated reaction
end
ILS.dim = dim;              %save input dimensionality
ILS.phi = cell(1, num^dim); %get space for the base functions
pos = linspace(-10,10,num); %and positions of the base functions

%cell array specifying the grid positions of the base function
ILS.location = cell(1, dim);
for i=1:dim
    ILS.location{i} = pos;
end

d = zeros(dim,1);   %allocate space for grid-coordinates
for i=1:num^dim
    %convert linear coordinate to input coordinates for base function
    rem = i-1;
    for k=1:dim
        d(k) = mod(rem,num)+1;
        rem = floor(rem/num);
    end
    %base functions are generated as a string which is evaluated to form an
    %anonymous function
    if(strcmp(base,'gauss'))    %gaussian interpolation
        s = 'ILS.phi{i} = (@(x)exp(-norm([';    %start of gaussian function
        for j=1:dim
            s = [s 'pos(' num2str(d(j)) ') '];  %position for current dimension
        end
        s = [s ']-x).^2/(-(10/(num-1))^2/log(0.5))));'];    %rest of gaussian function
        ILS.gaussWidth(i) = (-(10/(num-1))^2/log(0.5))/2;   %standard deviation needed for IRMA-integration
    else                        %or linear interpolation
        s = 'ILS.phi{i} = (@(x)';
        for j=1:dim
            %for each dimension multiply a triangular function
            s = [s 'max(0,1-abs(pos(' num2str(d(j)) ')-x(' num2str(j) '))/(20/(num-1)))*'];
            %and save distance to left and right neighbour
            if(d(j)==1)  %no lower distance at lower border of the dimension
                ILS.dist(i,j,1) = 0;
            else
                ILS.dist(i,j,1) = 20/(num-1);
            end
            if(d(j)==num)  %no upper distance at upper border of the dimension
                ILS.dist(i,j,2) = 0;
            else
                ILS.dist(i,j,2) = 20/(num-1);
            end
        end
        s = [s '1);'];
    end
    eval(s);    %evaluate the generated anonymous function
end
% PA specific initialization of ILS.
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

function ILS = icl_initILS_PA(ILS, dim, algSetup)

if(nargin < 3) %default setup
    ILS.variant = 0;
    ILS.aggressiveness = 1;
else
    %PA variants:
    %   0 - basic PA
    %   1 - basic PA-I
    %   2 - basic PA-II
    ILS.variant = algSetup.variant;
    %aggressiveness parameter (only relevant for PA-I and PA-II)
    ILS.aggressiveness = algSetup.a;
end
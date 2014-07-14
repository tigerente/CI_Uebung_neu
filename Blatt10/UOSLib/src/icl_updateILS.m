% Updates the ILS information with a new parameter vector
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
% @author Andreas Buschermöhle (andbusch(at)uos.de)
% @date 2013-04-12
% @version 1.5
%
% @input ILS - matlab structure describing the learning system
%
% @input newAlpha - new double parameter vector to be set
%
% @input phix - transformed double vector in parameter space
%
% @return ILS - matlab structure describing the learning system
function ILS = icl_updateILS(ILS, newAlpha, phix)

%update parameter vector
ILS.alpha = newAlpha;
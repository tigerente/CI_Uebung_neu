% Algorithm specific initialization of ILS (dummy file).
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
% This file is the basis for implementing learning methods.
%
% @author Andreas Buscherm�hle (andbusch(at)uos.de)
% @date 2013-03-07
% @version 1.4
%
% @input ILS - matlab structure describing the learning system
%
% @input dim - integer > 0, number of dimensions
%
% @input algSetup - algorithm specific setup parameters
%
% @return ILS - matlab structure describing the learning system

function ILS = icl_initILS(ILS, dim, algSetup)

% Add algorithm specific initializations of parameters to the ILS-structure
% here. This is a dummy file as a baseline for own algorithms.
% Update the approximation with one data sample (dummy file).
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
% This file is the basis for implementing learning methods.
%
% @author Andreas Buschermöhle (andbusch(at)uos.de)
% @date 2013-06-18
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
function ILS = icl_learn(ILS, x, y, yp, mode)

% Add algorithm specific learning of parameters here.
% This is a dummy file as a baseline for own algorithms.

% To update ILS with new parameter vector use the following function to allow for uncertainty tracking:
% ILS = icl_updateILS(ILS, newAlpha', phix);
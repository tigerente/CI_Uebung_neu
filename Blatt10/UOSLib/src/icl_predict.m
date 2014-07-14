% Predicts a label, i.e. evaluation of the approximator, for a given input.
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
% @date 2013-03-07
% @version 1.4
%
% @input x - double input vector in [-10,10]
%
% @input ILS - matlab structure describing the learning system
%
% @input mode - operating mode (regression=1, classification=2)
%
% @return yp - predicted label, in [-1, 1] for regression or [-1; 1] for
%              classification
function yp = icl_predict(x, ILS, mode)

phix = icl_transform(x, ILS);   %transform from input to parameter space
yp = phix*ILS.alpha';           %linear combination of basis functions with parameters

if(mode==2)
    yp = sign(yp); %binarize for classification
end
% IRMA specific initialization of ILS.
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
% IRMA - Incremental Risk Minimization Algorithm
%
% Reference:
% Buschermoehle, A.; Schoenke, J.; Rosemann, N.; Brockmann, W.:
% The Incremental Risk Functional: Basics of a Novel Incremental Learning Approach.
% IEEE International Conference on Systems Man and Cybernetics (SMC), to appear (2013)
%
% @author Andreas Buschermöhle (andbusch(at)uos.de)
% @date 2013-11-21
% @version 1.6
%
% @input ILS -  structure describing the learning system
%
% @input dim - integer > 0, number of dimensions
%
% @input algSetup - algorithm specific setup parameters
%
% @return ILS -  structure describing the learning system

function ILS = icl_initILS_IRMA(ILS, dim, algSetup)

%depending on the approximation structure the matrix might become nearly
%singular but it still works
warning('off', 'MATLAB:nearlySingularMatrix');

%allocate spapce for matrix
N = length(ILS.phi);
ILS.A = zeros(N);

if(strcmp(ILS.kind, 'poly'))
%special analytic generation for poly-LIP
    constFac = 20^(max(0,ILS.dim-2));
    constFac2 = 20^(min(1,ILS.dim-1));
    for i=1:N
        for j=1:N
            %get input index for first basis function
            if(i==1)
                a = 1;
            else
                a = mod(i-2, ILS.order)+2;
            end
            %get input index for second basis function
            if(j==1)
                b = 1;
            else
                b = mod(j-2, ILS.order)+2;
            end
            if(i==1)    %handling of no integrand for first dimension
                ILS.A(i,j) = constFac*(10^(b)-(-10)^(b))/(b)*constFac2;
            elseif(j==1)%handling of no integrand for second dimension
                ILS.A(i,j) = constFac*(10^(a)-(-10)^(a))/(a)*constFac2;
            elseif(max(0,floor((i-2)/ILS.order)) == max(0,floor((j-2)/ILS.order)))
                        %handling if both basis functions lie in the same dimension
                ILS.A(i,j) = constFac*(10^(a+b-1)-(-10)^(a+b-1))/(a+b-1)*constFac2;
            else        %handling if both basis functions lie in different dimensions
                ILS.A(i,j) = constFac*(10^a-(-10)^a)/a*(10^b-(-10)^b)/b;
            end
        end
    end
elseif(strcmp(ILS.kind, 'GLTlin'))
%special analytic generation for linear GLT-LIP
    idxi = zeros(ILS.dim,1);    %alocate space for input coordinates
    idxj = zeros(ILS.dim,1);
    for i=1:N
        for j=1:N
            %convert linear coordinate to input coordinates for first basis
            %function
            rem = i-1;
            for k=1:ILS.dim
                idxi(k) = mod(rem,length(ILS.location{k}))+1;
                rem = floor(rem/length(ILS.location{k}));
            end
            %convert linear coordinate to input coordinates for second basis
            %function
            rem = j-1;
            for k=1:ILS.dim
                idxj(k) = mod(rem,length(ILS.location{k}))+1;
                rem = floor(rem/length(ILS.location{k}));
            end
            dist = (idxi-idxj); %calculate grid-distance between grid points
            if(any(abs(dist) > 1))  %if any grid-distance is bigger than one, the integral is zero
                ILS.A(i,j) = 0;
            else
                ILS.A(i,j) = 1;     %otherwise, the integral is calculated dimension-wise
                for n=1:length(dist)
                    if(dist(n) == 1)    %positive grid-distance:
                        D = ILS.dist(j,n,2);    %use upper distance of j
                        ILS.A(i,j) = ILS.A(i,j) * D/6;
                    elseif(dist(n) == -1)%negative grid-distance:
                        D = ILS.dist(j,n,1);    %use lower distance of j
                        ILS.A(i,j) = ILS.A(i,j) * D/6;
                    else                 %same grid point:
                        D = (ILS.dist(i,n,1)+ILS.dist(i,n,2)); %upper and lower distance of j
                        ILS.A(i,j) = ILS.A(i,j) * D/3;
                    end
                end
            end
        end
    end
elseif(strcmp(ILS.kind, 'GLTgauss'))
%special generation for gaussian GLT-LIP
    idxi = zeros(ILS.dim,1);    %alocate space for input coordinates
    idxj = zeros(ILS.dim,1);
    a = zeros(1,ILS.dim);
    b = zeros(1,ILS.dim);
    for i=1:N
        for j=1:N
            %convert linear coordinate to input coordinates for first basis
            %function and generate its input space position
            rem = i-1;
            for k=1:ILS.dim
                idxi(k) = mod(rem,length(ILS.location{k}))+1;
                a(k) = ILS.location{k}(idxi(k));
                rem = floor(rem/length(ILS.location{k}));
            end
            %convert linear coordinate to input coordinates for second basis
            %function and generate its input space position
            rem = j-1;
            for k=1:ILS.dim
                idxj(k) = mod(rem,length(ILS.location{k}))+1;
                b(k) = ILS.location{k}(idxj(k));
                rem = floor(rem/length(ILS.location{k}));
            end
            sigsqa = ILS.gaussWidth(i); %width of first gaussian
            sigsqb = ILS.gaussWidth(j); %width of second gaussian
            sigsqab = sigsqa*sigsqb;    %width of cumulated gaussian
            %calculate the arae under cumulated gaussian, which is another
            %scaled gaussian
            ILS.A(i,j) = (2*pi)^(ILS.dim/2)*sqrt(sigsqab/(sigsqa+sigsqb)) * exp(-((sigsqa*sigsqb*(a*a'+b*b'-2*a*b'))/(sigsqa+sigsqb))/(sigsqa*sigsqb));
        end
    end
else
%general generation for other LIP
    %general integration for A-matrix of IRMA, currently up to two
    %input-dimensions are supported
    if(dim > 2)
        error('Numerical integration for IRMA is currently not supported for more than two input dimensions');
    end
    res = 50;   %integration resolution for each dimension
    x = linspace(-10,10,res);   %reference points for integration
    dx = x(2)-x(1); %integration step size

    for i=1:N
        for j=1:N
            if(dim == 1)
            for k=1:length(x)
                ILS.A(i,j) = ILS.A(i,j) + ILS.phi{i}(x(k))*ILS.phi{j}(x(k))*dx;
            end
            elseif(dim == 2)
            for k=1:length(x)
                for l=1:length(x)
                ILS.A(i,j) = ILS.A(i,j) + ILS.phi{i}([x(k) x(l)])*ILS.phi{j}([x(k) x(l)])*dx*dx;
                end
            end
            end
        end
    end
end

if(nargin < 3) %default setup
    ILS.s = 0.1;     %stiffness
    ILS.tau = 0.0; %growth rate of stiffness
    ILS.variant = 1;
else
    ILS.s = algSetup.s;     %stiffness
    ILS.tau = algSetup.tau; %growth rate of stiffness
    %stiffness increases:
    %   1. additive
    %   2. multiplicative
    %   3. sigmoidal
    ILS.variant = algSetup.variant;
    if(ILS.variant == 3) %maximum stiffness for sigmoidal
        ILS.maxstiff = algSetup.maxstiff;
    end
end
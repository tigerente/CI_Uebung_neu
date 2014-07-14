% Visualization module for low-dimensional learning tasks.
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
% Show the approximation, the corresponding training data, and ground truth
% data. Currently this yields a visualization for 1D or 2D tasks.
%
% @author Andreas Buschermöhle (andbusch(at)uos.de)
% @date 2013-03-08
% @version 1.4
%
% @input mode - operating mode (regression=1, classification=2)
%
% @return data - double matrix, training dataset
%
% @return groundTruth - double matrix, ground truth dataset
%
% @input ILS - matlab structure describing the learning system

function icl_showResult(mode, data, groundTruth, ILS, dim)

%specific view for regression
if(mode == 1)
    if(dim == 1) %one dimension -> simple plot
        figure(2)
        clf
        testx = groundTruth(:,1:end-1);
        testy = zeros(size(testx));
        for i=1:size(groundTruth,1);
            testy(i) = icl_predict(testx(i), ILS, mode);
        end
        plot(testx, testy)
        hold on
        plot(data(:,1:end-1), data(:,end), '.k')
        plot(groundTruth(:,1:end-1), groundTruth(:,end), '-r')
        legend('Resulting Approximation', 'Training Data', 'Ground Truth');
        ylim([-1 1])
        xlim([-10 10])
        hold off
        xlabel('input')
        ylabel('output')
    elseif(dim == 2) %two dimensions -> surface plot
        figure(2);
        clf
        testx = groundTruth(:,1:end-1);
        testy = zeros(size(testx,1),1);
        for i=1:size(groundTruth,1);
            testy(i) = icl_predict(testx(i,:), ILS, mode);
        end
        len = sqrt(size(groundTruth, 1));
        surf(groundTruth(1:len,1), groundTruth(1:len,1), reshape(testy, len, len)');
        shading flat;
        hold on
        plot3(data(:,1), data(:,2), data(:,3), '.k')
        hold off
        title('Learned Approximation')
        figure(3);
        clf
        surf(groundTruth(1:len,1), groundTruth(1:len,1), reshape(groundTruth(:,3), len, len)');
        shading flat;
        title('Ground Truth')
    end
else %specific view for classification
    if(dim == 1) %one dimension -> simple plot
        figure(2);
        clf
        testx = groundTruth(:,1:end-1);
        testy = zeros(size(testx));
        for i=1:size(groundTruth,1);
            testy(i) = icl_predict(testx(i), ILS, mode);
        end
        subplot(2,1,1)
        TIDX = find(testy == -1);
        plot(testx(TIDX), testy(TIDX), '.b')
        hold on
        TIDX = find(testy == 1);
        plot(testx(TIDX), testy(TIDX), '.r')
        hold off
        xlabel('input')
        ylabel('class')
        title('Resulting Approximation')
        ylim([-1.5 1.5])
        subplot(2,1,2)
        TIDX = find(groundTruth(:,end) == -1);
        plot(groundTruth(TIDX,1), groundTruth(TIDX,2), '.b')
        hold on
        TIDX = find(groundTruth(:,end) == 1);
        plot(groundTruth(TIDX,1), groundTruth(TIDX,2), '.r')
        hold off
        xlabel('input')
        ylabel('class')
        title('Ground Truth')
        ylim([-1.5 1.5])
    elseif(dim == 2) %two dimensions -> pcolor class regions
        figure(2);
        clf
        len = sqrt(size(groundTruth, 1));
        pcolor(groundTruth(1:len,1), groundTruth(1:len,1), reshape(groundTruth(:,3), len, len)');
        shading flat
        hold on
        TIDX = find(data(:,end) == -1);
        plot(data(TIDX,1), data(TIDX,2), '.b')
        TIDX = find(data(:,end) == 1);
        plot(data(TIDX,1),data(TIDX,2), '.r')
        title('Ground Truth')
        caxis([-1 1])
        hold off

        figure(3)
        clf
        for i=1:size(groundTruth,1);
            testy(i) = icl_predict(groundTruth(i,1:2), ILS, mode);
        end
        pcolor(groundTruth(1:len,1), groundTruth(1:len,1), reshape(testy, len, len)');
        shading flat
        hold on
        TIDX = find(data(:,end) == -1);
        plot(data(TIDX,1), data(TIDX,2), '.b')
        TIDX = find(data(:,end) == 1);
        plot(data(TIDX,1),data(TIDX,2), '.r')
        title('Learned Approximation')
        caxis([-1 1])
        hold off
    end
end
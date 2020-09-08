function plot_graphs_avgjoint(score, x_data, x_label, y_label, nth_label, joints, plotRows, xTickSpace, legendFontMult, opt)
% score is a M by 7 by N matrix giving average precision per joint along a row.
% The rows correspond to a change in parameter value. The values of the
% matrix should range between 0 and 1. For each Nth slice of the matrix
% corresponds to another parameter. nth_label specifies a cell of strings
% for the label of each Nth slice. 
% x_data is the data to plot against the score.

% Options
yMax = 100; 
titles = {'Neck','Head','Buttocks','Shoulder','Elbow','Wrist',...
    'Hip','Knee','Ankle','Average'};
fontsize = 15;


title_str = cell(1);
num_plots = size(score, 3);
plot_clr = hsv(30);
inds = int32(linspace(1, 28, num_plots));
plot_clr = plot_clr(inds, :);

% Average of all joints (if == 8)
if any(joints(joints == 8))
    averageOver = 1:7;
    score(:,end+1,:) = mean(score(:, averageOver, :), 2); % add average on to end of score
end

% Mean of left/right joints
c = 1;
if any(joints(joints == 1)); scoreAvg(:, c, :) =  score(:, 1, :); title_str{c} = titles{1}; c = c+1; end
if any(joints(joints == 2)); scoreAvg(:, c, :) =  score(:, 2, :); title_str{c} = titles{2}; c = c+1; end
if any(joints(joints == 3)); scoreAvg(:, c, :) =  score(:, 3, :); title_str{c} = titles{3}; c = c+1; end
if any(joints(joints == 4)); scoreAvg(:, c, :) =  mean(score(:, [4,10], :), 2); title_str{c} = titles{4}; c = c+1; end
if any(joints(joints == 5)); scoreAvg(:, c, :) =  mean(score(:, [5,11], :), 2); title_str{c} = titles{5}; c = c+1; end
if any(joints(joints == 6)); scoreAvg(:, c, :) =  mean(score(:, [6,12], :), 2); title_str{c} = titles{6}; c = c+1; end
if any(joints(joints == 7)); scoreAvg(:, c, :) =  mean(score(:, [7,13], :), 2); title_str{c} = titles{7}; c = c+1; end
if any(joints(joints == 8)); scoreAvg(:, c, :) =  mean(score(:, [8,14], :), 2); title_str{c} = titles{8}; c = c+1; end
if any(joints(joints == 9)); scoreAvg(:, c, :) =  mean(score(:, [9,15], :), 2); title_str{c} = titles{9}; c = c+1; end
if any(joints(joints == 16)); scoreAvg(:, c, :) = score(:, 16, :); title_str{c} = titles{10}; c = c+1; end
score = scoreAvg;

% Plot each subplot
for f = 1:size(score, 2)
    subplot(plotRows,ceil(size(score, 2)/plotRows),f)
    for n = 1:num_plots
        plot(x_data,score(:,f,n)*100,'-','color',plot_clr(n,:),'linewidth',3,'markersize',10, 'LineSmoothing','on');
        if n == 1
            hold on
        end
    end
    axis([x_data(1) x_data(end) 0 yMax])
    h = ylabel(y_label);
    set(h,'fontsize',fontsize)
    h = xlabel(x_label);
    set(h,'fontsize',fontsize)
    set(gca,'fontsize',fontsize)
    grid on
    set(gca,'xtick',x_data(1:xTickSpace:end))
    set(gca,'ytick',0:10:yMax);
    title(title_str{f})
    if f == 1
        hleg = legend(nth_label,'location','SouthEast');
        set(hleg,'FontSize',legendFontMult * 2*fontsize/3)
    end
end

end
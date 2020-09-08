function plot_graphs(score, x_data, x_label, y_label, nth_label)
% score is a M by 7 by N matrix giving average precision per joint along a row.
% The rows correspond to a change in parameter value. The values of the
% matrix should range between 0 and 1. For each Nth slice of the matrix
% corresponds to another parameter. nth_label specifies a cell of strings
% for the label of each Nth slice. 
% x_data is the data to plot against the score.

% Options
fontsize = 15;

[~,~,num_plots] = size(score);
plot_clr = hsv(num_plots+1); %set colour of lines
averageOver = 1:7;

% Average of all joints
score(:,end+1,:) = mean(score(:, averageOver, :),2); 

title_str = {'Neck','Head','Buttocks','Left Shoulder','Left Elbow','Left Wrist',...
    'Left Hip','Left Knee','Left Ankle','Right Shoulder','Right Elbow','Right Wrist',...
    'Right Hip','Right Knee','Right Ankle','Average'};
for f = 1:size(score, 2) %loop through joint types
    subplot(4,4,f)
    for n = 1:num_plots
        plot(x_data,score(:,f,n)*100,'-','color',plot_clr(n,:),'linewidth',3,'markersize',10, 'LineSmoothing','on');
        if n == 1
            hold on
        end
    end
    axis([x_data(1) x_data(end) 0 100])
    h = ylabel(y_label);
    set(h,'fontsize',fontsize)
    h = xlabel(x_label);
    set(h,'fontsize',fontsize)
    set(gca,'fontsize',fontsize)
    grid on
    if length(x_data) > 10
        set(gca,'xtick',x_data(1:5:end))
    else
        set(gca,'xtick',x_data)
    end
    set(gca,'ytick',0:10:100);
    title(title_str{f})
    if f == 1
        hleg = legend(nth_label,'location','SouthEast');
        set(hleg,'FontSize',2*fontsize/3)
    end
end



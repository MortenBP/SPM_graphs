function SPM_ttest_Graph(timeSeriesData, clusterData, GraphTitle, xLabel, yLabel, pLabel, colorScheme, lineWidth, errorAlpha, timeSeriesHeight, subplotSpacing, topSpacing, bottomSpacing)
    arguments
        timeSeriesData
        clusterData
        GraphTitle = 'SPM ttest'; % overall figure title
        xLabel = '% stride, initial contact to initial contact'; % x axis label for time series plot
        yLabel = "Degree"
        pLabel = ["C1 vs C2", "C1 vs C3", "C1 vs C4", "C1 vs C5", "C1 vs C6"]
        colorScheme = [0,0,0;turbo(numel(clusterData))]; % Color scheme for entire figure, first row is always black for primary timeSeriesData measure.
        lineWidth = 2
        errorAlpha = 0.5
        timeSeriesHeight = 0.65; % Space for time series plot, in percentage of total plot space
        subplotSpacing = 0.09; % Space between main plot and subplots
        topSpacing = 0.04; % Space at top of figure
        bottomSpacing = 0.04; % Space at the bottom of figure   
    end

% Number of cell variables
numVariables = numel(clusterData);
[~,~,numTimeSeries] = size(timeSeriesData);

% Create spacing variable for subplot
subplotHeight = (1-timeSeriesHeight-subplotSpacing-topSpacing-bottomSpacing)/numVariables; % Height of each subplot
        
% Create a new figure
figure;

% Create the time-series subplot
subplot('Position', [0.1, 1-timeSeriesHeight-topSpacing, 0.8, timeSeriesHeight]); % specifies the mean+std subplot position on the plot
for i = 1:numTimeSeries
    hold on
    [y,ye]    = deal(mean(timeSeriesData(:,:,i),1), std(timeSeriesData(:,:,i),1)); % generates mean and std for each series of data.       
    x         = 0:numel(y)-1;
    plot(x, y, 'color', colorScheme(i,:), 'linewidth',lineWidth); % plots the mean curve
    [y0,y1]   = deal(y+ye, y-ye); % the following lines generate an error cloud based on the std
    [x,y0,y1] = deal( [x(1) x x(end)], [y0(1) y0 y0(end)], [y1(1) y1 y1(end)]);
    [x1,y1]   = deal(fliplr(x), fliplr(y1));
    [X,Y]     = deal([x x1], [y0 y1]);
    h         = patch(X, Y, 0.7*[1,1,1]);
    set(h, 'FaceColor',colorScheme(i,:), 'FaceAlpha',errorAlpha, 'EdgeColor','None') % plots the error cloud
    hold off
end
xlim([0, 100]);
xlabel(xLabel);
ylabel(yLabel);
title(GraphTitle);

for i = 1:numVariables
    subplot('Position', [0.1, (numVariables-i)*subplotHeight+bottomSpacing, 0.8, subplotHeight]);
    
    % Plot the black boxes on each subplot
    hold on;
    for j = 1:numel(clusterData{i})
        x = [clusterData{i}{j}(1), clusterData{i}{j}(2), clusterData{i}{j}(2), clusterData{i}{j}(1)];
        y = [0, 0, 100, 100];
        patch(x, y, colorScheme(i+1,:), 'EdgeColor', 'none');
    end
    hold off;
    
    % Set the x-axis and y-axis limits for the subplots
    xlim([0, 100]);
    ylim([0, 100]);
    
    % Set the y-axis label for the subplots
    ylabel(pLabel(i), 'Rotation', 0, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');

    % Remove x-axis numbers for all subplots except the last one
    if i < numVariables
        set(gca, 'XTick', []);
        set(gca, 'XTickLabel', []);
    end

    % Remove y-axis numbers for all subplots
    set(gca, 'YTick', []);
    set(gca, 'YTickLabel', []);
end

% Adjust the figure size
Fig1 = gcf;
Fig1.Position(3:4) = [700, 600]; % Modify the figure size as needed
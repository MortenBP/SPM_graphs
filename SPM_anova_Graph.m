function SPM_anova_Graph(spmi, clusterData, GraphTitle, xLabel, pLabel, colorScheme, lineWidth, errorAlpha, ANOVAHeight, subplotSpacing, topSpacing, bottomSpacing)
    arguments
        spmi
        clusterData
        GraphTitle = 'SPM ANOVA'; % overall figure title
        xLabel = '% stride, initial contact to initial contact'; % x axis label for time series plot
        pLabel = ["C1 vs C2", "C1 vs C3", "C1 vs C4", "C1 vs C5", "C1 vs C6"]
        colorScheme = [0,0,0;zeros(numel(clusterData),3)]; % Color scheme for entire figure, first row is always black for primary timeSeriesData measure.
        lineWidth = 2
        errorAlpha = 0.5
        ANOVAHeight = 0.65; % Space for time series plot, in percentage of total plot space
        subplotSpacing = 0.09; % Space between main plot and subplots
        topSpacing = 0.04; % Space at top of figure
        bottomSpacing = 0.04; % Space at the bottom of figure   
    end

% Number of cell variables
numVariables = numel(clusterData);

% Create spacing variable for subplot
subplotHeight = (1-ANOVAHeight-subplotSpacing-topSpacing-bottomSpacing)/numVariables; % Height of each subplot
        
% Create a new figure
figure;

% Create the time-series subplot
subplot('Position', [0.1, 1-ANOVAHeight-topSpacing, 0.8, ANOVAHeight]); % specifies the mean+std subplot position on the plot
spmi.plot();
spmi.plot_threshold_label();
spmi.plot_p_values();
xlabel(xLabel);
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
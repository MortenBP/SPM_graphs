function SPM_graph_tool(Y, A, SubjYA, Title, Xlabel, Ylabel, Plabel, Param, Type, iters, alpha, bon_f)
%% this function takes the input variables of main.m and creates the specified figure, see main.m for more info

if Type == "ttest"
    % Loops over all participants
    PersonIDs = unique(SubjYA);
    for p = 1:length(PersonIDs)
    
        % Create the timeSeriesData for a specific ID
        conditions = unique(A);
        for i = 1:length(conditions)
            timeSeriesData(:,:,i) = Y(A==conditions(i)&SubjYA==PersonIDs(p),:);
        end
        
        % Perform SPM ttest on timeSeriesData for all conditions
        p_critical = spm1d.util.p_critical_bonf(alpha, bon_f);
        for i = 1:length(conditions)-1
            if Param == "param"
                t(i) = spm1d.stats.ttest_paired(timeSeriesData(:,:,i+1),timeSeriesData(:,:,1));
                ti(i) = t(i).inference(p_critical, 'two_tailed',true);
            elseif Param == "nparam"
                t(i) = spm1d.stats.nonparam.ttest_paired(timeSeriesData(:,:,i+1),timeSeriesData(:,:,1));
                ti(i) = t(i).inference(p_critical, 'two_tailed',true, 'iterations', iters);
            else
                print("Invalid string value for Param")
            end
        end

        % Extract cluster values of SPM ttest inference calculations
        for i = 1:length(conditions)-1
            if ti(i).nClusters >= 1
                for o = 1:ti(i).nClusters
                    ClusterCell{o} = ti(i).clusters{o}.endpoints;
                end
            else
                ClusterCell{1} = [0,0]; % creates an empty cell if no clusters were found
            end
            clusterData{i,:} = ClusterCell;
            clearvars ClusterCell
        end
        
        % Create SPM_Graph of timeSeriesData and Clusters
        SPM_ttest_Graph(timeSeriesData, clusterData, Title, Xlabel, Ylabel, Plabel)       
    end

elseif Type == "ANOVA"
    % Create the timeSeriesData for the conditions
    conditions = unique(A);
    for i = 1:length(conditions)
        timeSeriesData(:,:,i) = Y(A==conditions(i),:);
    end
    
    % Perform SPM ttest on timeSeriesData for all conditions
    p_critical = spm1d.util.p_critical_bonf(alpha, bon_f);
    for i = 1:length(conditions)-1
        if Param == "param"
            t(i) = spm1d.stats.ttest_paired(timeSeriesData(:,:,i+1),timeSeriesData(:,:,1));
            ti(i) = t(i).inference(p_critical, 'two_tailed',true);
            spm = spm1d.stats.anova1rm(Y, A, SubjYA);  %within-subjects model
            spmi = spm.inference(0.05);
        elseif Param == "nparam"
            t(i) = spm1d.stats.nonparam.ttest_paired(timeSeriesData(:,:,i+1),timeSeriesData(:,:,1));
            ti(i) = t(i).inference(p_critical, 'two_tailed',true, 'iterations', iters);
            spm = spm1d.stats.nonparam.anova1rm(Y, A, SubjYA);  %within-subjects model
            spmi = spm.inference(0.05, 'iterations', iters);
        else
            print("Invalid string value for Param")
        end
    end
        
    % Extract cluster values of SPM ttest inference calculations
    for i = 1:length(conditions)-1
        if ti(i).nClusters >= 1
            for o = 1:ti(i).nClusters
                ClusterCell{o} = ti(i).clusters{o}.endpoints;
            end
        else
            ClusterCell{1} = [0,0]; % creates an empty cell if no clusters were found, this is needed in the graph function.
        end
        clusterData{i,:} = ClusterCell;
        clearvars ClusterCell
    end
    
    % Create SPM_Graph of timeSeriesData and Clusters
    SPM_anova_Graph(spmi, clusterData, Title, Xlabel);

else
    print("Invalid string inputted in Type")

end

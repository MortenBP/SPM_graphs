%%% SPM graph script %%%
% Dependencies:
%       SPM1D toolbox from SPM1D.org
%
% input variables:
%       Y = time-series data registered to a length of 101
%       A = categorical condition indicator as intergers
%  SubjYA = subject indicator as integers, must be 1, 2, 3, ... etc.
%   Param = string of either "param" or "nparam"
%   Type  = string of either "ttest" or "ANOVA"
%   iters = non-param iterations, standard = 1000
%   alpha = alpha value, standard = 0.05
%   bon_f = number of tests for bonferoni correction (reduces p value)
%   Title = title of graph as string
%   Xlabel= label of x axis as string
%   Ylabel= label of y axis as string, only used for mean+sd in ttest
%   Plabel= label of post-hoc analyses, the number of labels should
%           correspond to the number of conditions in A minus 1
%
% output:
%       Figure displaying specified type of SPM analysis with an
%       acompanying sub-group SPM analysis depending on number of
%       conditions (A).
%       When Type = "ttest", a graph of mean+SD with ttest of each
%       condition (A) for each subject (SubjYA) will be generated
%
% Notes on variables:
% A accepts any values (e.g. 0, 10, 20, 30, ...).
% The lowest value of A is the primary condition that will be compared to
%   the remaining conditions. I suggest using 1, 2, 3, 4, 5 with 1 being the
%   primary condition.
% Y, A, and SubjYA must be datatype "doubles" with rows identifying
%   participants and columns being data entries (e.g. A = 1080x1 double, 
%   Y = 1080x101 double, SubjYA = 1080x1 double).
% Y, A, and SubjYA must have identical number of rows, with only one colums
%   being allowed in A and SubjYA.
% There must be an identical number of observations for each condition


Title   = "SPM ANOVA of Hip Angles";
Xlabel  = "% stride, initial contact to initial contact";
Ylabel  = "Degree";
Plabel  = ["C1 vs C2", "C1 vs C3", "C1 vs C4", "C1 vs C5", "C1 vs C6"];
Param   = "param";   %choices: "param" or "nparam"
Type    = "ANOVA";   %choices: "ttest" or "ANOVA"
iters   = 200;      %iterations used for non-param analysis
alpha   = 0.05;      %alpha of SPM analysis
bon_f   = 1;         %bonferoni correction of alpha (higher correction = lower alpha)


SPM_graph_tool(Y, A, SubjYA, Title, Xlabel, Ylabel, Plabel, Param, Type, iters, alpha, bon_f)
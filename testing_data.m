clear
% Import the training set you want to use
load trainingData10_3_22.mat
load COVIDbyCounty.mat
import centroid_division.*
import training_testingfxn.*

%% Running K Means
% Change the number of clusters you want to use here
k = 12; 
[idx,C] = kmeans(trainingData(:,2:end),k,'replicates', 1000);

%% Making Sense of the Clusters
% cancatenates idx to training data, so each row has an assigned cluster
% value
trainingData = [idx trainingData];
% sorts training data according to the cluster values so you can scroll and
% visually see which division regions are part of each cluster
trainingData = sortrows(trainingData, 1);
% see function below
centroidsToDivisions = centroid_division(k, trainingData);
%Make nice table with labels
table_labels = {'Most Common Div', '2nd Most Common Div','3rd Most Common Div' ...
    'Mean', 'FreqMode1', 'FreqMode2', 'FreqMode3','ClusterLength','Freq1ByLength'};
table_initial_clusters = array2table(centroidsToDivisions, 'VariableNames',table_labels);

% This creates the testing set, which is all vectors that were not in the
% training set.
testing_index = ~ismember(CNTY_COVID,trainingData(:,2:end), 'rows');
temp_CNTY_COVID = [divisionLabels CNTY_COVID];
testing_set = temp_CNTY_COVID(testing_index,:);

% This assigns each data point in the testing set to a centroid/cluster
% using the nearest neighbors algorithm. Each centroid/cluster has an
% assigned division, so that division is what each testing data point is
% assumed to be from.
nearest_neighbors_idx = knnsearch(C,testing_set(:,2:end));
testing_data_results = [nearest_neighbors_idx ...
    centroidsToDivisions(nearest_neighbors_idx, 1) testing_set(:,1)];

% Testing data results stores (1) the cluster/centroid that the data point
% was assignned to in column 1, (2) the data point's assigned division, (3)
% the data point's actual division.
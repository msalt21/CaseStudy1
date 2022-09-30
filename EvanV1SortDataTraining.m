
clear;
load COVIDbyCounty.mat
close all;

%% Preparing Training Dat
% change this if you want to change testing/training ratio
percentTraining = 0.1;

% Initializing the trainingData matrix and the trainingDataLabels vectors
% so that they can be concatenated onto
% This will hold each vector in the training data that we produced and its
% 130 data points for covid data
trainingData = zeros(1,130);
% this will hold the divsion number that each row vector belongs to
trainingDataLabels = zeros(1,1);

for num = 1:9 %for each division
    % extract the data and divsion labels cooresponding to the row vectors
    % in that division (i.e. every row vector in CNTY_COVID in division 1
    % if num = 1)
    data = CNTY_COVID((CNTY_CENSUS.DIVISION == num),:);
    labels = divisionLabels(divisionLabels == num);

    % This vector holds the indices that we want to extract from data and
    % labels, which are randomly selected. int32 is used to cast in the case that
    % percentTraining*size(data,1) is a decimal. 
    selectedIndices = randperm(size(data,1), ... 
        int32(percentTraining*size(data,1)));
    % first param gives the range of random numbers selected
    % second param gives the number of numbers we are going to generate
    % (i.e. size of training set for each division)
    
    % extracts the labels and data row vectors only cooresponding to the
    % indices which were randomly selected above
    divTrainingLabels = labels(selectedIndices);
    divTraining = data(selectedIndices,:);
    
    % Concatenates the rows from division num that we want to use for
    % training onto the ones that we have already extracted
    trainingData = [trainingData; divTraining];
    % Same as above, but for the division labels
    trainingDataLabels = [trainingDataLabels; divTrainingLabels];
end

% get rid of column of zeros (initialized each vector/matrix with a column of
% zeros so I could concatenate onto that)
trainingData = trainingData(2:end,:);
trainingDataLabels = trainingDataLabels(2:end);
% Concatenates the training data labels onto training data so we know which
% vectors belong in each division
trainingData = [trainingDataLabels trainingData];
clear("trainingDataLabels");

%% Running K Means
k = 15; 
% change this if you want to experinent with different numbers of clusters
[idx,C,sumd,D] = kmeans(trainingData(:,2:end),k,'replicates', 150);
% might want to experiment with sumd and D variables
% n = number of points/rows in trainingData
% m = dimension of each row vector/columns in trainingData/amount of dates
% k = number of clusters

% idx = assigning each row index to a cluster (n x 1)
% C = matrix containing each centroid as a row vectors (k x m)
% sumd = sum of the distances of each point to their respective cluster
% (ideally want to minimize this) (k x 1)
% D = distances of each point to EVERY centroid (size: n x k)

%% Making Sense of the Clusters
% - need to assign each cluster to a division
% - possibility - find out which division makes up the majority in each
% cluster

% cancatenates idx to training data, so each row has an assigned cluster
% value
trainingData = [idx trainingData];
% sorts training data according to the cluster values so you can scroll and
% visually see which division regions are part of each cluster
trainingData = sortrows(trainingData, 1);

% This code is for visualizing the results
figure;
silhouette(trainingData(:,3:end), idx);
xlim([-1 1]);

figure; 
plot(trainingData(trainingData(:,1) == 2,:)');





load COVIDbyCounty.mat

%% Creating the Training and Testing Sets
% USER: change this to use a different training/testing ratio
percent_training = 0.8;

% Initializing the trainingData matrix and the trainingDataLabels vectors
% so that they can be concatenated onto
% This will hold each vector in the training data that we produced and its
% 130 data points for covid data
training_data = zeros(1,130);
% this will hold the divsion number that each row vector belongs to
training_data_labels = zeros(1,1);

for num = 1:9 %for each division
    % extract the data and divsion labels cooresponding to the row vectors
    % in that division (i.e. every row vector in CNTY_COVID in division 1
    % if num = 1)
    data = CNTY_COVID((CNTY_CENSUS.DIVISION == num),:);
    labels = divisionLabels(divisionLabels == num);
    % This vector holds the indices that we want to extract from data and
    % labels, which are randomly selected. int32 is used to cast in the case that
    % percentTraining*size(data,1) is a decimal. 
    % first param gives the range of random numbers selected
    % second param gives the number of numbers we are going to generate
    % (i.e. size of training set for each division)
    selected_indices = randperm(size(data,1), ... 
        int32(percent_training*size(data,1)));
    % extracts the labels and data row vectors only cooresponding to the
    % indices which were randomly selected above
    div_training_labels = labels(selected_indices);
    div_training = data(selected_indices,:);
    % Concatenates the rows from division num that we want to use for
    % training onto the ones that we have already extracted
    training_data = [training_data; div_training];
    % Same as above, but for the division labels
    training_data_labels = [training_data_labels; div_training_labels];
end
clear num data labels div_training div_training_labels selected_indices ...
    

% get rid of column of zeros (initialized each vector/matrix with a column of
% zeros so I could concatenate onto that)
training_data = training_data(2:end,:);
training_data_labels = training_data_labels(2:end);
% Concatenates the training data labels onto training data so we know which
% vectors belong in each division
training_data = [training_data_labels training_data];
clear("training_data_labels");

% Creates the testing set (i.e. the data points remaining in CNTY_COVID
% that are not in the training set
testing_index = ~ismember(CNTY_COVID,training_data(:,2:end), 'rows');
temp_CNTY_COVID = [divisionLabels CNTY_COVID];
testing_data = temp_CNTY_COVID(testing_index,:);
clear temp_CNTY_COVID testing_index

%% Cluster the Training Set using k Clusters
% USER: change this number to change the amount of clusters
k = 12;
[clust_idx,clusters] = kmeans(training_data(:,2:end),k,'replicates', 1000);

% The vector containing the k clusters is |clusters|

%% Assign Divisions to the Clusters
training_data = [clust_idx training_data];
% sorts training data according to the cluster values so you can scroll and
% visually see which division regions are part of each cluster
training_data = sortrows(training_data, 1);
centroid_division_assignments = centroid_division(k, training_data);
table_labels = {'Most Common Div', '2nd Most Common Div',...
    '3rd Most Common Div','FreqMode1', 'FreqMode2', 'FreqMode3',...
    'ClusterLength', 'Mean'};
centroid_division_assignments_table = array2table(...
    centroid_division_assignments,'VariableNames',table_labels);
clear table_labels

save ('cluster_covid_data.mat')
%% Functions
% This function assigns centroid numbers to a division based on what
% division makes up the majority of a cluster
% INPUTS: num_clusters (number of clusters, scalor) and data (matrix of
% sorted COVID time series data with cluster assignments in the first row)
% OUTPUT: division_number, a num_clusters x 6 matrix that holds the top 3
% clusters to appear in each cluster in rows 1-3, and the names of those
% clusters in rows 4-6.
function division_number = centroid_division(num_clusters, data)
    x = zeros(num_clusters,3);
        
    % Most common division
    for clust = 1:num_clusters
        subdata = data(data(:,1) == clust, 2);
        [mode1,freqMode1] = mode(subdata);
        x(clust,1) = mode1;
        mean_clust = mean(subdata);
        x(clust,7) = mean_clust;
        x(clust,4) = freqMode1;
        x(clust,8) = size(subdata,1);
      
    end
    % Second most common division
    for clust = 1:num_clusters
        subdata = data(data(:,1) == clust, 2);
        [mode2, freqMode2] = mode(subdata(subdata ~= mode(subdata)));
        x(clust,2) = mode2;
        x(clust,5) = freqMode2;
       
    end
    % Third most common division
    for clust = 1:num_clusters
        subdata = data(data(:,1) == clust, 2);
        first = mode(subdata);
        second = mode(subdata(subdata ~= mode(subdata)));
        [mode3, freqMode3] = mode(subdata(subdata ~= first & ...
            subdata ~= second));
        x(clust,3) = mode3;
        x(clust,6) = freqMode3;
    end
    % Setting return value
    division_number = x;
end





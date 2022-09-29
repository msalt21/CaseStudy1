load('COVIDbyCounty.mat');

% Trying an 80-20 training to testing data split
% Data chosen for each group is randomly generated
training_proportion = 0.8;
training_length = int32(training_proportion*length(divisionLabels));
training_idx = randi(9, [training_length 1]);
training = CNTY_COVID(training_idx,:);
training_labels = divisionLabels(training_idx);

testing_proportion = 1 - training_proportion;
testing_length = int32(length(divisionLabels) - training_length);
testing_idx = randi(9, [testing_length 1]);
testing = CNTY_COVID(testing_idx,:);
testing_labels = divisionLabels(testing_idx);

% Testing out kmeans with 9 clusters (ideally, each cluster would represent
% a geograph division of the US
k = 9;
[idx, C] = kmeans(training, 9);
training_results = [training_labels idx];


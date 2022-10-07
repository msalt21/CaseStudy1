load training_data.mat
load testing_data.mat
load clusters.mat
load centroid_division_assignments.mat

nearest_neighbors_idx = knnsearch(clusters,testing_data(:,2:end));
testing_data_results = [nearest_neighbors_idx ...
centroid_division_assignments(nearest_neighbors_idx, 1) testing_data(:,1)];

training_data_results_table = array2table(testing_data_results, ...
    "VariableNames",{'Cluster', 'Assigned Division', 'Actual Division'});

num_correct = testing_data_results(:,2) == testing_data_results(:,3);
num_correct = sum(num_correct);
disp("The division assignment success rate was " + ...
    (num_correct/size(testing_data_results,1)*100) + "%");

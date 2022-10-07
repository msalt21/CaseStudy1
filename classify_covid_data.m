load cluster_covid_data.mat

nearest_neighbors_idx = knnsearch(clusters,testing_data(:,2:end));
testing_data_results = [nearest_neighbors_idx ...
centroid_division_assignments(nearest_neighbors_idx, 1) testing_data(:,1)];

training_data_results_table = array2table(testing_data_results, ...
    "VariableNames",{'Cluster', 'Assigned Division', 'Actual Division'});
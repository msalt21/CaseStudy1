load('COVIDbyCounty.mat');
close all;

%% Summary
% We want to cluster covid data from each county into clusters k according
% to similarties in case trends. Then, we want to make sure that these
% clusters k will coorespond to certain division locations in the US. The
% first part of this will be training, and the second part of this will be
% testing.

%% ISSUES THAT WE NEED TO OVERCOME
% - training to testing ratio 
% https://onlinelibrary.wiley.com/doi/full/10.1002/sam.11583#:~:text=A%20commonly%20used%20ratio%20is,are%20also%20used%20in%20practice.
% - number of clusters k, and what is the best way to initialize them
% - number of replications of kmeans()
% - assigning clusters to the divisions using training data
% - using testing data to determine the accuracy -- want to exceed 1/9
% accuracy (this would be the same accuracy as if someone were guessing the
% division)
% - utilize silhouette values/plots to determine the accuracy/success of
% the clustering

%% Initial Data Visualization
figure;
hold on;
for num = 1:9
    subplot(3,3,num);
    plot(dates, CNTY_COVID(divisionLabels == num,:));
    title(divisionNames(num));
    ylim([-100 5000]);
end
hold off;

% All of the regions tend to have a large spike around January 2022. Is
% there a way to minimize impact of this spike on the cluster selection? Or
% does it not matter?
% - perhaps creating a matrix that will zero out the values in that spike
% so that other spikes are considered more for cluster assignment


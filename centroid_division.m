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
        x(clust,4) = mean_clust;
        x(clust,5) = freqMode1;
        x(clust,8) = size(subdata,1);
      
    end
    % Second most common division
    for clust = 1:num_clusters
        subdata = data(data(:,1) == clust, 2);
        [mode2, freqMode2] = mode(subdata(subdata ~= mode(subdata)));
        x(clust,2) = mode2;
        x(clust,6) = freqMode2;
       
    end
    % Third most common division
    for clust = 1:num_clusters
        subdata = data(data(:,1) == clust, 2);
        first = mode(subdata);
        second = mode(subdata(subdata ~= mode(subdata)));
        [mode3, freqMode3] = mode(subdata(subdata ~= first & ...
            subdata ~= second));
        x(clust,3) = mode3;
        x(clust,7) = freqMode3;
        x(clust,9) = x(clust,5)/x(clust,8);
    end
    % Setting return value
    division_number = x;
end
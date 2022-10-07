function [training_data,testing_data] = training_testing(percent_training)
    load COVIDbyCounty.mat
    percentTraining = percent_training;
    
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
        % first param gives the range of random numbers selected
        % second param gives the number of numbers we are going to generate
        % (i.e. size of training set for each division)
        selectedIndices = randperm(size(data,1), ... 
            int32(percentTraining*size(data,1)));
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
    
    % Creates the testing set (i.e. the data points remaining in CNTY_COVID
    % that are not in the training set
    testing_index = ~ismember(CNTY_COVID,trainingData(:,2:end), 'rows');
    temp_CNTY_COVID = [divisionLabels CNTY_COVID];
    testing_set = temp_CNTY_COVID(testing_index,:);
    training_data = trainingData;
    testing_data = testing_set;
end
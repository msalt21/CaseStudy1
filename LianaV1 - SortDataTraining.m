load COVIDbyCounty.mat

%Sort Data by Division
division1data = CNTY_COVID((CNTY_CENSUS.DIVISION == 1),:);
division2data = CNTY_COVID((CNTY_CENSUS.DIVISION == 2),:);
division3data = CNTY_COVID((CNTY_CENSUS.DIVISION == 3),:);
division4data = CNTY_COVID((CNTY_CENSUS.DIVISION == 4),:);
division5data = CNTY_COVID((CNTY_CENSUS.DIVISION == 5),:);
division6data = CNTY_COVID((CNTY_CENSUS.DIVISION == 6),:);
division7data = CNTY_COVID((CNTY_CENSUS.DIVISION == 7),:);
division8data = CNTY_COVID((CNTY_CENSUS.DIVISION == 8),:);
division9data = CNTY_COVID((CNTY_CENSUS.DIVISION == 9),:);

%TRAINING DATA
percent_traning = 0.8;
div1Training = division1data(randperm(size(division1data,1), percent_traning*size(division1data,1)),:);
div2Training = division2data(randperm(size(division2data,1), percent_traning*size(division2data,1)),:);
div3Training = division3data(randperm(size(division3data,1), percent_traning*size(division3data,1)),:);
div4Training= division4data(randperm(size(division4data,1), percent_traning*size(division4data,1)),:);
div5Training = division5data(randperm(size(division5data,1), percent_traning*size(division5data,1)),:);
div6Training= division6data(randperm(size(division6data,1), percent_traning*size(division6data,1)),:);
div7Training = division7data(randperm(size(division7data,1), percent_traning*size(division7data,1)),:);
div8Training = division8data(randperm(size(division8data,1), percent_traning*size(division8data,1)),:);
div9Training = division9data(randperm(size(division9data,1), percent_traning*size(division9data,1)),:);


% plot(division1data,'*b')
% hold on
% plot(division2data,'*r')
% hold off

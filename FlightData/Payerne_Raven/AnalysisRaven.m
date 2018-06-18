clear
close all

% read in data
fid = fopen('Payerne_1.txt');
data_1 = textscan(fid,'%s%d','HeaderLines',0, 'CollectOutput',1);
data_11 = data_1{:,1};
data_12 = data_1{:,2};
fid = fclose(fid);

nData = length(data_12);
nFrame = 45 % 45 data per frame

%data = zeros(nFrame,ceil(nData/nFrame));
for i=1:nFrame
    k = 1;
    for j=i:nFrame:nData
        data(k,i) = data_12(j);
        k = k+1;
    end
    figure
    plot(data(:,i))
    title(['Data : ' num2str(data_11{i}) ', #' num2str(i)]);
end
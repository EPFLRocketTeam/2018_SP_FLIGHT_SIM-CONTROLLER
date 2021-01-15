function [X] = SOsampling(Xid, XX, N, scheme);
%SOSAMPLING samples the input for Sobol Analysis following a Monte Carlo scheme. f
%   INPUTS: 
%       Xid     Array of strings containing the names of the parameters
%       XX      Sampling space for each paramters (in the form of an interval [a, b])
%       N       Number of samples
%   OUTPUTS:
%       X       Matrix of samples of sample (one sample per row)
%       scheme  Type of sampling scheme

k = length(Xid);
if scheme == "MC"
    X = rand(k, N).*(XX(:,3) - XX(:,2)) + XX(:,2);
elseif scheme == "LHC"
    X = lhsdesign(N, k)'.*(XX(:,3) - XX(:,2)) + XX(:,2);  
elseif scheme == "Sobol"
    n_skip = randi([1 N+1]);
    seq = sobolset(k, 'Skip', n_skip);
    X = net(seq, N)'.*(XX(:,3) - XX(:,2)) + XX(:,2);   
else
    error("Unknown sampling scheme")
end
end


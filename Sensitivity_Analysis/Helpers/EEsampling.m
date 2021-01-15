function [B_l, EEidx_l] = EEsampling(Xid, p);
%EESAMPLING samples the input for the EE analysis (see Morris, 1993 for more details about
%the sampling strrategy).
%   INPUTS: 
%       Xid     Array of strings containing the names of the parameters
%       XX      Sampling space for each paramters (in the form of an interval [a, b]
%       p       Level of discretization of the sampling space (has to be even)
%   OUTPUTS:
%       B_l     Matrix of samples of sample (one sample per row)
%       EEid_l  Matrix storing which 2 samples are corresponding to which EE increment.

k = length(Xid);
Delta = p/(2*(p-1));

% Sampling Xbar_l
XXbar = 0:1/(p-1):1-Delta;
idx = randi(length(XXbar), k, 1);
Xbar_l = XXbar(idx)';

% Creating B
B = tril(ones(k+1, k)) - eye(k+1, k);
EEidx_l = [1:k; 2:k+1]; %1st row: idx of the sample with no increment, 2nd row, idx of the sample with increment

% Creating D_l
D_l = diag(2*randi([0, 1], 1, k) - ones(1, k));


% Creating P_l
P_l = eye(k);
P_l = P_l(randperm(k),:);

% Computing B_l
B_l = ones(k+1, 1) * Xbar_l' + (Delta/2) * ((2*B - ones(k+1, k)) * D_l + ones(k+1, k)) * P_l;

% Clever trick to keep track of the EE idices
EEidx_l = (EEidx_l * D_l - min(0, sum(EEidx_l * D_l, 1))) * P_l;

end


function out = getVariableMatrix(cnvList,idx)

% getVariableMatrix returns a matrix of a single variable from multiple CNV
% or ROS files. Queried files must have consistent variable structure
% (processed from the same PSA files). This is the multifile version of
% getVariableColumn.

% Input:    
%   cnvList:        list of .CNV or .ROS files (e.g. 'cast002.cnv') given
%                   in a string matrix (n,1) or (1,n) where n is the number
%                   of files. This can be a file path.

%   idx:            index of desired data. This is the column number of the
%                   data matrix (output of ctd2mat). 

%                   the index can be a numerical vector (e.g. [3 5 10]) for
%                   extracting multiple variables from the same filelist.

% Output:   
%   out:            matrix of all file data in columns (X,n) where n is the
%                   iterated file and X is the length of the longest data
%                   column in the queried filelist. Empty values are 
%                   assigned NaN.

%                   if multiple variables are exracted, this matrix has 3
%                   dimensions instead (X,n,S) where S is assocaited with
%                   each iterated data column queried in the idx argument.

% Created on: 20251229
% Last edit: 20251229
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Ensure that the cnvList is a string matrix
cnvList = string(cnvList);

% Loop through filelist and extract the size of each data field.
xx = nan(numel(cnvList),1);
for ii = 1:numel(cnvList)
    [data,~] = ctd2mat(cnvList(ii));
    [xx(ii),~] = size(data);
end

% Longest column so we can allocate the output array.
[mxp,~] = max(xx);

% Allocate the output array.
out = nan(mxp,numel(cnvList));

% If multiple variables are extracted, allocate a 3-D array instead, where
% each layer is assocaited with a queried index value.
if length(idx)>1
    out = nan(mxp,numel(cnvList),length(idx));
end

% Finally loop through the filelist and extract the desired variable using
% the supplied index.
for ii = 1:numel(cnvList)
    [data,~] = ctd2mat(cnvList(ii));
    if length(idx)==1
        out(1:xx(ii),ii) = data(:,idx);
    else
        for jj = 1:length(idx)
            out(1:xx(ii),ii,jj) = data(:,idx(jj));
        end
    end
end



function [data] = normMethod(data,animalnumber,salvec,expdsn,normMethodType,fsg1,varargin)
% INPUTS:
% DATA: Data structure containing at least the fields
%       'sigfilt' (vector of filtered data,
%       'normfactor' (scalar), and 
%       'pks' (vector of detected peaks in session).
%
% ANIMALNUMBER: This is a vector of 1 through the
%       number of animals present in the data structure.
%       eg., a data structure of 5 sessions is:
%       animalnumber = [1, 2, 3, 4, 5];
%
% SALVEC: This is a vector of session numbers of vehicle
%       conditions. If not normalizing by vehicle, pass
%       an empty vector [].
%
% EXPDSN: This is a matrix of the experimental design.
%       expdsn = ones(2,3)... is two treatments
%       and 3 time points. Currently the time points
%       dimension is not functional.
%
% NORMMETHODTYPE: This is a character string that
%       controls the type of normalization. Choose
%       between 'session', 'vehicle', 'session-mTrans',
%       and 'vehicle-mTrans'.
%
% OUTPUTS:
% DATA: This is the original data structure with the
%       normalized data(XX).sigfilt substituted in.

%   Detailed explanation goes here

a = struct(...
    'ixWindow', [],...
    'fs', []);
a = parseArgsLite(varargin, a);

if isempty(a.ixWindow)
    a.ixWindow = [1     5087; ...
                  5087  10174; ...
                  10174 15259];
else
end
ix = a.ixWindow;

if isempty(a.fs)
    a.fs = 1017.25262451172;
else
end

if strcmp(normMethodType,'session')
    for abc = animalnumber
        data(abc).sigfilt = data(abc).sigfilt./max(data(abc).sigfilt);
        data(abc).normfactor = mean(data(abc).pks);
    end
elseif strcmp(normMethodType,'vehicle')
    for abc = salvec
        for xyz = 1:size(expdsn,1)-1
            data(abc+xyz).sigfilt = data(abc+xyz).sigfilt./max(data(abc).sigfilt);
        data(abc+xyz).normfactor = mean(data(abc).pks);
        end
        data(abc).sigfilt = data(abc).sigfilt./max(data(abc).sigfilt);
        data(abc).normfactor = mean(data(abc).pks);
    end
elseif strcmp(normMethodType,'session-mTrans')
    for abc = animalnumber
        if mean(data(abc).pks)==0
        else
            data(abc).sigfilt = data(abc).sigfilt./mean(data(abc).pks);
            data(abc).normfactor = mean(data(abc).pks);
        end
    end

elseif strcmp(normMethodType,'vehicle-mTrans')
    for abc = salvec
        if mean(data(abc).pks)==0
        else
            for xyz = 1:size(expdsn,1)-1
                data(abc+xyz).sigfilt = data(abc+xyz).sigfilt./mean(data(abc).pks);
                data(abc+xyz).normfactor = mean(data(abc).pks);
            end
            data(abc).sigfilt = data(abc).sigfilt./mean(data(abc).pks);
            data(abc).normfactor = mean(data(abc).pks);
        end
    end

elseif strcmp(normMethodType,'z-score-pre')
    for idx1 = animalnumber
        for idx2 = 1:numel(data(idx1).trainOn)
            blMean = mean(data(idx1).wdata(ix(1,1):ix(1,2),idx2)); 
            blSD = std(data(idx1).wdata(ix(1,1):ix(1,2),idx2));
            data(idx1).wdata = (data(idx1).wdata - blMean) / blSD;
        end
    end
 
elseif strcmp(normMethodType,'z-score-session')
        for abc = animalnumber
            data(abc).sigfilt = zscore(data(abc).sigfilt);
        end

elseif strcmp(normMethodType,'z-score-session-5pre')
        for abc = animalnumber
            blMean = mean(data(abc).sigfilt(floor(fsg1*300):end)); 
            blSD = std(data(abc).sigfilt(floor(fsg1*300):end));
            data(abc).sigfilt = (data(abc).sigfilt - blMean) / blSD;
        end
end


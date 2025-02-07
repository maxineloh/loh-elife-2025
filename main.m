%% INITIATE
opengl hardware; clear all; close all;format long g

%% PARAMETERS
tankpath1 = 'c:\xx\xxx\';
username = 'xx';
clip = 1;
tailvalue = 'both';
drugname{1} = 'Day';
alignto = 'Solenoid';
makegraphs = 1;
print1 = 0;
usewhichfilter = 'fft';
normMethodType = 'z-score-session';
ew = [-5 0 0 5 10]; % [<begin pre> <end pre> <begin inf> <end inf / begin post> <end post>]
numstd = 2;
quant1 = 0;
transThreshType = 'session';
meanormax = 'mean';
SP=(0); % event time marker

%% FILENAMES
mal = {'xxx','xxx','xxx'}; 
fem = {'xxx','xxx','xxx'};
idxF = 1;

filename{idxF,1} = [tankpath1 'foldername1'];idxF = idxF + 1;
filename{idxF,1} = [tankpath1 'foldername2'];idxF = idxF + 1;
filename{idxF,1} = [tankpath1 'foldername3'];idxF = idxF + 1;

filename = filename(~cellfun('isempty',filename));
animalnumber = 1:length(filename);

%% TREATMENTS
expdsn = ones(1,1);
salvec = 1:size(expdsn,1):size(filename,1);% e.g. Day 1
condvec(salvec,1) = {'1: Day 1'}; 
[data(1:size(condvec,1)).conditions] = condvec{:};
condvec = salvec;
ucond = unique({data.conditions});
drug = ucond;
figcol = distinguishable_colors(length(condvec))';

%% LOAD DATA
disp(['Processing ' drugname ' Files'])
[data, alldata, fsg1, slashes, dashes] = loadFPData_RD(filename, data, clip, animalnumber, username);

% SEX DIFFERENCES
[data] = sexDifferences(data,mal,fem,animalnumber);

%%  Fiber Photometry Recording Processing
% SUBTRACT BACKGROUND & FILTER DATA
[data] = subtractFP(data,animalnumber,usewhichfilter); %check to see if needed

% ALIGN
[data] = eventAlignment(data,animalnumber,alignto,fsg1);

% NORMALIZE
if strcmp(transThreshType,'session')
    [data,uani,ucond,freqD,ampD] = countTransients(data,numstd,animalnumber,0,expdsn,fsg1,quant1,print1,figcol,makegraphs);
    [data] = normMethod(data,animalnumber,salvec,expdsn,normMethodType);

elseif strcmp(transThreshType,'vehicle')
    [data,uani,ucond,~,~] = countTransients(data,numstd,animalnumber,salvec,expdsn,fsg1,quant1,print1,figcol,makegraphs);
    [data] = normMethod(data,animalnumber,salvec,expdsn,normMethodType);
end

%% Fiber Photometry Quantification & Visualization
%  mean z-score during infusion
[wss, wse, ws] = windowSize(alignto);
[data, windowtest, animalnumber, trtVecs] = errCorrFinalEventTooShort(data, animalnumber, fsg1, wss, wse,condvec); % Error correction for the final event recording being too short after event
trtVecs = condvec;
[data,window1] = cutWindowsOfData(data,animalnumber,fsg1,wss,wse,alignto,normMethodType); % CUT OUT WINDOWS OF DATA
[data,C,uani,ucond,sexbycond,sex,tw] = meanDataWindows(data,animalnumber,wss,wse,fsg1,makegraphs,alignto); % FIND MEAN OF DATA WINDOWS
for abc = 1:size(ew,2)
    [~, ix(abc)] = min(abs(tw-ew(abc)));
end
tw2 = [tw(1,1);tw;flipud(tw);tw;tw(end)];
epsfile = 1;
data = quantifyTraces(data,sexbycond,ix,C,animalnumber,figcol,wss,fsg1,alignto,drugname,print1,meanormax); %need for mmwdata

% Average dopamine response to infusion (averaged across trials per subject)
abc = 1:size(C,1);
prismtrace(:,1) = downsample(tw,100); %prismtrace=matrix, with of downsampled tw assignment to the first column
prismtrace(:,abc+animalnumber) = downsample([data(abc).mcondwdata.sub],100);

% Table of mean z-score during preinfusion (phase 1), infusion (phase 2) and post infusion (phase 3)
close all
clear col t2
row = 1;
InfusionRow = row + size(ew,1);
for idx1 = 1:size(C,1)
    for idx2 = data(idx1).structlocs'
        for idx3 = 1:data(idx2).ntrain 
            for idx4 = 1:size(ew,1)
                col.rat{row,1} = data(idx2).animal;
                col.treatment(row,1) = idx1;
                col.trial(row,1) = idx3;
                col.phase(row,1) = idx4;
                if strcmp(meanormax,'mean')
                    col.sig(row,1) = mean(data(idx2).wdata(ix(idx4,1):ix(idx4,2),idx3));
                elseif strcmp(meanormax,'max')
                    col.sig(row,1) = max(data(idx2).wdata(ix(idx4,1):ix(idx4,2),idx3));
                end             
                row = row + 1;
            end
        end
    end
end
for idx1 = 1:size(C,1)
    for idx2 = data(idx1).structlocs'
        for idx3 = 1:data(idx2).ntrain 
            for idx4 = 1:size(ew,1)
                col.rat{row,1} = data(idx2).animal;
                col.treatment(row,1) = idx1;
                col.trial(row,1) = idx3;
                col.phase(row,1) = 2;
                if strcmp(meanormax,'mean')
                    col.sig(row,1) = mean(data(idx2).wdata(ix(idx4,3):ix(idx4,4),idx3));
                elseif strcmp(meanormax,'max')
                    col.sig(row,1) = max(data(idx2).wdata(ix(idx4,3):ix(idx4,4),idx3));
                end             
                row = row + 1;
            end
        end
    end
end
for idx1 = 1:size(C,1)
    for idx2 = data(idx1).structlocs'
        for idx3 = 1:data(idx2).ntrain 
            for idx4 = 1:size(ew,1)
                col.rat{row,1} = data(idx2).animal;
                col.treatment(row,1) = idx1;
                col.trial(row,1) = idx3;
                col.phase(row,1) = 3;
                if strcmp(meanormax,'mean')
                    col.sig(row,1) = mean(data(idx2).wdata(ix(idx4,4):ix(idx4,5),idx3));
                elseif strcmp(meanormax,'max')
                    col.sig(row,1) = max(data(idx2).wdata(ix(idx4,4):ix(idx4,5),idx3));
                end             
                row = row + 1;
            end
        end
    end
end
varnames = {...
    'rat',...
    'treatment',...
    'phase',...
    'trial',...
    'sig'};
t2 = table(...
    col.rat,...
    col.treatment,...
    col.phase,...
    col.trial,...
    col.sig,...
    'VariableNames',varnames);

% Trial heat map
close all
for abc = animalnumber
    data(abc).hpdata = zeros(floor(1+((wse-wss)*fsg1)),length(data(abc).Sipper)); % WINDOW OF 465nm
    stepup = 1;
    for xyz = 1:length(data(abc).Sipper)
        window = ((data(abc).Sipper(xyz)+((wss)*fsg1)):(data(abc).Sipper(xyz)+((wse)*fsg1)))'; %create a window -5 to 10
        if window(end)>length(data(abc).time)
            incompleteArray=(data(abc).sigfilt(ceil(window(1)):length(data(abc).time)));
            incompleteArray(:,end+1:end+(length(window)-length(incompleteArray)))=missing;
            data(abc).hpdata(:,stepup) = incompleteArray;
        else
        data(abc).hpdata(:,stepup) = (data(abc).sigfilt(ceil(window(1)):ceil(window(end))));
        end
        stepup = stepup + 1;
    end
end
tmwdata = zeros(min([length(data(1).Sipper)]),size(data(1).mwdata,1),size(uani,2));
    for trialIdx = 1:min([length(data(1).Sipper)])
        for subjIdx = animalnumber 
            tmwdata(trialIdx,:,subjIdx) = data(subjIdx).hpdata(:,trialIdx);
        end
    end
tmwdata = squeeze(nanmean(tmwdata,3));
imagesc(tmwdata)
colormap('jet')
set(gca,'YTickLabel',[], 'XTickLabel',[],'YLabel',[],'XLabel',[], 'Position', [0, 0, 1, 1]);
ylim([1 30]); caxis([-1 3]);
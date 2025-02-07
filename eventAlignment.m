function [data] = eventAlignment(data,animalnumber,alignto,fsg1)
%eventAlignment: Sets up the events of interest
%   INPUT args: (1) data: this is the full data structure.
%               (2) animalnumber: vector containing the filename slots of
%                           all the animals.
%               (3) alignto: this is a character string that tells the
%                           function to what events to align the windowed
%                           data to.
%               (4) fsg1: sampling rate (rig-unique).

%% remove preexisting data

if isfield(data,'trainOn')
    data = rmfield(data, 'trainOn');
    data = rmfield(data, 'ntrain');
    data = rmfield(data, 'actionmark');
    data = rmfield(data, 'cuemark');
end

%%
for abc = animalnumber
    if strcmp(alignto,'Sipper')==1
        data(abc).trainOn = data(abc).Sipper(1:29);
        data(abc).ntrain = size(data(abc).trainOn,1);
        data(abc).actionmark = (data(abc).trainOn)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemark = (data(abc).Sipper)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
    elseif strcmp(alignto,'Firstlick')==1
        data(abc).trainOn(:,1) = [data(abc).firstlick];
        data(abc).trainOn(isnan(data(abc).trainOn)) = [];
        data(abc).trainOnSipper = data(abc).Sipper;
        data(abc).trainOnSipper(data(abc).trainOnSipper==0) = [];
        data(abc).ntrain = size(data(abc).trainOn,1);
        data(abc).actionmark = (data(abc).trainOn)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemark = (data(abc).pluscue)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
        
        data(abc).trainOn(:,1) = [data(abc).firstlickP];
        data(abc).trainOn(isnan(data(abc).trainOn)) = [];
        data(abc).trainOnSipper = data(abc).SipperP;
        data(abc).trainOnSipper(data(abc).trainOnSipper==0) = [];
        data(abc).ntrain = size(data(abc).trainOn,1);
        data(abc).actionmark = (data(abc).trainOn)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemark = (data(abc).CueP)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
    elseif strcmp(alignto,'Cue')==1        
        data(abc).trainOn = data(abc).pluscue;
        data(abc).ntrain = size(data(abc).trainOn,1);
%         data(abc).ntrain = data(abc).ntrain-1;
        data(abc).actionmark = (data(abc).trainOn)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemark = (data(abc).pluscue)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
    elseif strcmp(alignto,'PlusCue')==1        
        data(abc).trainOn = data(abc).CueP;
        data(abc).ntrain = size(data(abc).trainOn,1);
%         data(abc).ntrain = data(abc).ntrain-1;
        data(abc).actionmark = (data(abc).trainOn)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemark = (data(abc).CueP)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
    elseif strcmp(alignto,'MinusCue')==1        
        data(abc).trainOn = data(abc).CueM;
        data(abc).ntrain = size(data(abc).trainOn,1);
%         data(abc).ntrain = data(abc).ntrain-1;
        data(abc).actionmark = (data(abc).trainOn)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemark = (data(abc).CueM)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
    elseif strcmp(alignto,'DSNS')==1
        data(abc).trainOnP = data(abc).CueP;
        data(abc).ntrain = size(data(abc).trainOnP,1);
        data(abc).actionmarkP = (data(abc).trainOnP)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemark = (data(abc).CueP)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
        data(abc).trainOnM = data(abc).CueM;
        data(abc).actionmarkM = (data(abc).trainOnM)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemarkM = (data(abc).CueM)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
        data(abc).lickmark = (data(abc).LickP)./fsg1;
%         data(abc).lickmarkR = (data(abc).LikR)./fsg1; 
        
    elseif strcmp(alignto,'SolLR')==1
        data(abc).trainOnP = data(abc).SolL(1:15);
        data(abc).ntrain = size(data(abc).trainOnP,1);
        data(abc).actionmarkP = (data(abc).trainOnP)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        %data(abc).cuemarkP = (data(abc).SolL)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
        data(abc).trainOnM = data(abc).SolR(1:15);
        data(abc).actionmarkM = (data(abc).trainOnM)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        %data(abc).cuemarkM = (data(abc).SolR)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
        
     elseif strcmp(alignto,'SolR')==1
        data(abc).trainOn = data(abc).SolR; %(1:24);
        data(abc).ntrain = size(data(abc).trainOn,1);
        data(abc).actionmark = (data(abc).trainOn)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemark = (data(abc).SolR)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
        
    elseif strcmp(alignto,'DSNSfirstlick')==1
        
         data(abc).trainOnP = data(abc).firstlickP;
        data(abc).ntrainP = size(data(abc).trainOnP,1);
%         data(abc).ntrain = data(abc).ntrain-1;
        data(abc).actionmarkP = (data(abc).trainOnP)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemarkP = (data(abc).CueP)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue

        data(abc).trainOnM = data(abc).firstlickM;
        data(abc).ntrainM = size(data(abc).trainOnM,1);
        data(abc).actionmarkM = (data(abc).trainOnM)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemarkM = (data(abc).CueM)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
%     elseif strcmp(alignto,'Trans')==1
%         data(abc).cuemark = data(abc).inject./fsg1;
    elseif strcmp(alignto,'Solenoid')==1
%         data(abc).trainOn = data(abc).Sipper(1:30);
        data(abc).trainOn = data(abc).Sipper
        data(abc).ntrain = size(data(abc).trainOn,1);
        data(abc).actionmark = (data(abc).trainOn)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemark = (data(abc).Sipper)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
    elseif strcmp(alignto,'Feeder')==1
        data(abc).trainOn = data(abc).feed(1:30);
        data(abc).ntrain = size(data(abc).trainOn,1);
        data(abc).actionmark = (data(abc).trainOn)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemark = (data(abc).feed)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue  
        
    elseif strcmp(alignto,'Entry')==1
        data(abc).trainOn = data(abc).entry(1:30);
        data(abc).ntrain = size(data(abc).trainOn,1);
        data(abc).actionmark = (data(abc).trainOn)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemark = (data(abc).feed)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue 
        data(abc).entrymark = (data(abc).entry)./fsg1; 

    elseif strcmp(alignto,'FirstEntry')==1
%         data(abc).trainOn = data(abc).firstentry;
        data(abc).trainOn = data(abc).firstentry(1:30);
        data(abc).trainOn(isnan(data(abc).trainOn)) = [];
        data(abc).ntrain = size(data(abc).trainOn,1);
        data(abc).actionmark = (data(abc).trainOn)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemark = (data(abc).feed)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue 
        data(abc).entrymark = (data(abc).entry)./fsg1;
    elseif strcmp(alignto,'Injection')==1
        data(abc).trainOn = data(abc).injt(1);
        data(abc).trainOn(isnan(data(abc).trainOn)) = [];
        data(abc).ntrain = size(data(abc).trainOn,1);
        data(abc).actionmark = (data(abc).trainOn)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
        data(abc).cuemark = (data(abc).injt)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue 
    end
    
    
end
% convert to seconds
if isfield(data,'licklat')
    for abc = animalnumber
        data(abc).licklat = data(abc).licklat./fsg1;
    end
end

%% TRANSIENT ALIGNMENT BYPASS (PEAK DETECTION)
if strcmp(alignto, 'Trans')==1
    for xyz = animalnumber
        data(xyz).tg = (0:1/fsg1:((length(data(xyz).sigfilt)-1)/fsg1))';
        [data(xyz).pksnew, ~] = peakdet(data(xyz).sigfilt, mean(data(abc).sigfilt)+3*std(data(abc).sigfilt,0,2));
        if isempty(data(xyz).pksnew)==0
            data(xyz).locs = data(xyz).pksnew(:,1);
            data(xyz).pks = data(xyz).pksnew(:,2);
        else
            data(xyz).locs = 0;
            data(xyz).pks = 0;
        end
        data(xyz).trainOn = data(xyz).locs;
        data(xyz).ntrain = size(data(xyz).trainOn,1);
%         data(xyz).actionmark = (data(xyz).trainOn)./fsg1; % USE FOR GRAPHING: vector of timestamps of action of interest
%         data(xyz).cuemark = (data(xyz).inject)./fsg1; % USE FOR GRAPHING: vector of timestamps of cue
    end
end
end


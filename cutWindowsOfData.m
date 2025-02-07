function [data,window] = cutWindowsOfData(data,animalnumber,fsg1,wss,wse,alignto,normMethodType)
%cutWindowsOfData: Uses the data structure to cut out windows assigned by
%the predetermined window start and end around an event.
%   INPUT args: (1) data: structure that contains all data as output by
%                           loadFPData.
%               (2) animalnumber: vector containing all animals.
%               (3) fsg1: sampling rate (rig-unique).
%               (4) wss: the amount of seconds before the event (negative).
%               (5) wse: the amount of seconds after the event (positive).
%   OUTPUT args:(1) data: output the same structure but with pks and locs
%                           fields.
%               (2) window: this is a vector the same size as the window.

%% remove preexisting data

if isfield(data,'wdata')
    data = rmfield(data, 'wdata');
    data = rmfield(data, 'pksdetrend');
end


%% CUT OUT WINDOWS OF DATA
if strcmp(alignto,'DSNS')
    for abc = animalnumber
        data(abc).wdata = zeros(floor(1+((wse-wss)*fsg1)),data(abc).ntrain); % WINDOW OF 465nm
        stepup = 1;
        for xyz = 1:data(abc).ntrain
            window = ((data(abc).trainOnP(xyz)+((wss)*fsg1)):(data(abc).trainOnP(xyz)+((wse)*fsg1)))';
            data(abc).wdataP(:,stepup) = (data(abc).sigfilt(ceil(window(1)):ceil(window(end))));
            data(abc).pksdetrendP(stepup,1) = max(data(abc).wdataP(:,stepup));
            window = ((data(abc).trainOnM(xyz)+((wss)*fsg1)):(data(abc).trainOnM(xyz)+((wse)*fsg1)))';
            data(abc).wdataM(:,stepup) = (data(abc).sigfilt(ceil(window(1)):ceil(window(end))));
            data(abc).pksdetrendM(stepup,1) = max(data(abc).wdataM(:,stepup));
            stepup = stepup + 1;
        end
    end
    if strcmp(normMethodType,'z-score-pre')
        stepup = 1;
        for xyz = 1:data(abc).ntrain
            z_mean = mean(data(abc).sigfilt((data(abc).trainOnP(xyz)+((wss)*fsg1)):data(abc).trainOnP(xyz))); %trainOn is the event timestamp in sample number
            z_sd = std(data(abc).sigfilt((data(abc).trainOnP(xyz)+((wss)*fsg1)):data(abc).trainOnP(xyz)));
            data(abc).wdataP(:,stepup) = (data(abc).wdataP(:,stepup) - z_mean)./z_sd;
            data(abc).pksdetrendP(stepup,1) = max(data(abc).wdataP(:,stepup));
            z_mean = mean(data(abc).sigfilt((data(abc).trainOnM(xyz)+((wss)*fsg1)):data(abc).trainOnM(xyz)));
            z_sd = std(data(abc).sigfilt((data(abc).trainOnM(xyz)+((wss)*fsg1)):data(abc).trainOnM(xyz)));
            data(abc).wdataM(:,stepup) = (data(abc).wdataM(:,stepup) - z_mean)./z_sd;
            data(abc).pksdetrendM(stepup,1) = max(data(abc).wdataM(:,stepup));
            stepup = stepup + 1;
        end
    end
    
elseif strcmp(alignto,'SolLR')
    for abc = animalnumber
        data(abc).wdata = zeros(floor(1+((wse-wss)*fsg1)),data(abc).ntrain); % WINDOW OF 465nm
        stepup = 1;
        for xyz = 1:data(abc).ntrain
            window = ((data(abc).trainOnP(xyz)+((wss)*fsg1)):(data(abc).trainOnP(xyz)+((wse)*fsg1)))';
            data(abc).wdataP(:,stepup) = (data(abc).sigfilt(ceil(window(1)):ceil(window(end))));
            data(abc).pksdetrendP(stepup,1) = max(data(abc).wdataP(:,stepup));
            window = ((data(abc).trainOnM(xyz)+((wss)*fsg1)):(data(abc).trainOnM(xyz)+((wse)*fsg1)))';
            data(abc).wdataM(:,stepup) = (data(abc).sigfilt(ceil(window(1)):ceil(window(end))));
            data(abc).pksdetrendM(stepup,1) = max(data(abc).wdataM(:,stepup));
            stepup = stepup + 1;
        end
    end
    
  elseif strcmp(alignto,'SolR')
    for abc = animalnumber
        data(abc).wdata = zeros(floor(1+((wse-wss)*fsg1)),data(abc).ntrain); % WINDOW OF 465nm
        stepup = 1;
        for xyz = 1:data(abc).ntrain
            window = ((data(abc).trainOn(xyz)+((wss)*fsg1)):(data(abc).trainOn(xyz)+((wse)*fsg1)))';
            data(abc).wdata(:,stepup) = (data(abc).sigfilt(ceil(window(1)):ceil(window(end))));
            data(abc).pksdetrend(stepup,1) = max(data(abc).wdata(:,stepup));
            stepup = stepup + 1;
        end
    end
    
    if strcmp(normMethodType,'z-score-pre')
        stepup = 1;
        for xyz = 1:data(abc).ntrain
            z_mean = mean(data(abc).sigfilt((data(abc).trainOnP(xyz)+((wss)*fsg1)):data(abc).trainOnP(xyz))); %trainOn is the event timestamp in sample number
            z_sd = std(data(abc).sigfilt((data(abc).trainOnP(xyz)+((wss)*fsg1)):data(abc).trainOnP(xyz)));
            data(abc).wdataP(:,stepup) = (data(abc).wdataP(:,stepup) - z_mean)./z_sd;
            data(abc).pksdetrendP(stepup,1) = max(data(abc).wdataP(:,stepup));
            z_mean = mean(data(abc).sigfilt((data(abc).trainOnM(xyz)+((wss)*fsg1)):data(abc).trainOnM(xyz)));
            z_sd = std(data(abc).sigfilt((data(abc).trainOnM(xyz)+((wss)*fsg1)):data(abc).trainOnM(xyz)));
            data(abc).wdataM(:,stepup) = (data(abc).wdataM(:,stepup) - z_mean)./z_sd;
            data(abc).pksdetrendM(stepup,1) = max(data(abc).wdataM(:,stepup));
            stepup = stepup + 1;
        end
    end
    
elseif strcmp(alignto,'DSNSfirstlick')
    for abc = animalnumber
        data(abc).wdataP = zeros(floor(1+((wse-wss)*fsg1)),data(abc).ntrainP); % WINDOW OF 465nm
        data(abc).wdataM = zeros(floor(1+((wse-wss)*fsg1)),data(abc).ntrainM); % WINDOW OF 465nm
        stepup = 1;
        for xyz = 1:data(abc).ntrainP
            if isnan(data(abc).trainOnP(xyz,1))
                continue
            else
                window = ((data(abc).trainOnP(xyz)+((wss)*fsg1)):(data(abc).trainOnP(xyz)+((wse)*fsg1)))';
                data(abc).wdataP(:,stepup) = (data(abc).sigfilt(ceil(window(1)):ceil(window(end))));
                data(abc).pksdetrendP(stepup,1) = max(data(abc).wdataP(:,stepup));
                stepup = stepup + 1;
            end
        end
        stepup = 1;
        for xyz = 1:data(abc).ntrainM
            if isnan(data(abc).trainOnM(xyz,1))
                continue
            else
                window = ((data(abc).trainOnM(xyz)+((wss)*fsg1)):(data(abc).trainOnM(xyz)+((wse)*fsg1)))';
                data(abc).wdataM(:,stepup) = (data(abc).sigfilt(ceil(window(1)):ceil(window(end))));
                data(abc).pksdetrendM(stepup,1) = max(data(abc).wdataM(:,stepup));
                stepup = stepup + 1;
            end
        end
    end
    if strcmp(normMethodType,'z-score-pre')
        stepup = 1;
        for xyz = 1:data(abc).ntrainP
            z_mean = mean(data(abc).sigfilt((data(abc).trainOnP(xyz)+((wss)*fsg1)):data(abc).trainOnP(xyz)));
            z_sd = std(data(abc).sigfilt((data(abc).trainOnP(xyz)+((wss)*fsg1)):data(abc).trainOnP(xyz)));
            data(abc).wdataP(:,stepup) = (data(abc).wdataP(:,stepup) - z_mean)./z_sd;
            data(abc).pksdetrendP(stepup,1) = max(data(abc).wdataP(:,stepup));
            z_mean = mean(data(abc).sigfilt((data(abc).trainOnM(xyz)+((wss)*fsg1)):data(abc).trainOnM(xyz)));
            z_sd = std(data(abc).sigfilt((data(abc).trainOnM(xyz)+((wss)*fsg1)):data(abc).trainOnM(xyz)));
            data(abc).wdataM(:,stepup) = (data(abc).wdataM(:,stepup) - z_mean)./z_sd;
            data(abc).pksdetrendM(stepup,1) = max(data(abc).wdataM(:,stepup));
            stepup = stepup + 1;
        end
    end
else
    for abc = animalnumber
        data(abc).wdata = zeros(floor(1+((wse-wss)*fsg1)),data(abc).ntrain); % WINDOW OF 465nm
        stepup = 1;
        for xyz = 1:data(abc).ntrain
            window = ((data(abc).trainOn(xyz)+((wss)*fsg1)):(data(abc).trainOn(xyz)+((wse)*fsg1)))';
            data(abc).wdata(:,stepup) = (data(abc).sigfilt(ceil(window(1)):ceil(window(end))));
            data(abc).pksdetrend(stepup,1) = max(data(abc).wdata(:,stepup));
            if strcmp(normMethodType,'z-score-pre')
                z_mean = mean(data(abc).sigfilt(floor(data(abc).trainOn(xyz)+((wss)*fsg1)):data(abc).trainOn(xyz)));
                z_sd = std(data(abc).sigfilt(floor(data(abc).trainOn(xyz)+((wss)*fsg1)):data(abc).trainOn(xyz)));
                data(abc).wdata(:,stepup) = (data(abc).wdata(:,stepup) - z_mean)./z_sd;
                data(abc).pksdetrend(stepup,1) = max(data(abc).wdata(:,stepup));
            end
            stepup = stepup + 1;
        end
    end
end
           
end


function [data,uani,ucond,freqD,ampD] = countTransients(data,numstd,animalnumber,salvec,expdsn,fsg1,quant1,print1,figcol,makegraphs)
%countTransients: Detect and Measure Ca++ Transient magnitudes
%   Uses the peakdetection function
%   INPUT args (aka just what is outputted): (1) data: structure that contains all data as output by
%                           loadFPData.
%               (2) numstd: number of standard deviations to threshold
%               (3) animalnumber: vector containing all animals
%               (4) salvec: this is a vector containing the filename slots
%                           of the control animals. (saline vector?)
%               (5) expdsn: this is a matrix containing the experimental
%                           design, as defined in the parameter section.
%                           (treatments and variables you have set in a
%                           matrix)
%               (6) fsg1: sampling rate (rig-unique).
%               (7) quant1: whether or not to quantify the transients (0 or
%                           1).
%               (8) print1: whether or not to make eps files (0 or 1).
%               (9) makegraphs: whether or not to output graphs (0 or 1).
%
%   OUTPUT args (what is inputted) :(1) data: output the same structure but with pks and locs
%                           fields.
%               (2) uani: cell array of all the unique animals.
%               (3) ucond: cell array of all the unique conditions.

%% remove preexisting data

if isfield(data,'pks')
    data = rmfield(data, 'pks'); %pks = peaks, y-axis = z-score
    data = rmfield(data, 'locs'); %locs = location, x-axis = time
    data = rmfield(data, 'pksnew');
    data = rmfield(data, 'tg');
end

%%
if salvec==0 %if you don't have a control animal
    for abc = animalnumber %animal number is the number of the row
        uniqueanimalprep{abc} = [data(abc).animal]; %assignment of unquieanimalprep data to the ID number
    end
    uani = unique(uniqueanimalprep); %make column for ID numberand organize the animals by ID
    if isfield(data,'conditions')
        for abc = animalnumber
            uniquecondprep{abc} = [data(abc).conditions]; %stating what are your conditions
        end
    end
    if exist('uniquecondprep')
        ucond = unique(uniquecondprep);%make row for conditions and organize the condition
    else
        ucond = cellstr(num2str(animalnumber(:))); %if uniquecondprep doesn't exist in your data sheet then make one column that the number of rows is dpeendent on your animal umber that already means rhw numbwe od rows
        [data(1:size(ucond,1)).conditions] = ucond{:}; %
    end
    for abc = animalnumber
        data(abc).tg = (0:1/fsg1:((length(data(abc).sigfilt)-1)/fsg1))'; %identify time as tg in seconds
        [data(abc).pksnew, ~] = peakdet(data(abc).sigfilt, mean(data(abc).sigfilt)+numstd*std(data(abc).sigfilt,0,2));
        data(abc).locs = data(abc).pksnew(:,1);
        data(abc).pks = data(abc).pksnew(:,2);
    end
else
    for abc = animalnumber
        uniqueanimalprep{abc} = [data(abc).animal];
    end
    uani = unique({data.animal});
    for abc = animalnumber
        uniquecondprep{abc} = [data(abc).conditions];
    end
    ucond = unique(uniquecondprep);
    salaniloc = salvec;
    for abc = salaniloc
        data(abc).tg = (0:1/fsg1:((length(data(abc).sigfilt)-1)/fsg1))';
        [data(abc).pksnew, ~] = peakdet(data(abc).sigfilt, mean(data(abc).sigfilt)+numstd*std(data(abc).sigfilt,0,2));
        data(abc).locs = data(abc).pksnew(:,1);
        data(abc).pks = data(abc).pksnew(:,2);

        for xyz = 1:(size(expdsn,1)-1)
            data(abc+xyz).tg = (0:1/fsg1:((length(data(abc+xyz).sigfilt)-1)/fsg1))';
            [data(abc+xyz).pksnew, ~] = peakdet(data(abc+xyz).sigfilt, mean(data(abc).sigfilt)+numstd*std(data(abc).sigfilt,0,2));
            if isempty(data(abc+xyz).pksnew)==0
                data(abc+xyz).locs = data(abc+xyz).pksnew(:,1);
                data(abc+xyz).pks = data(abc+xyz).pksnew(:,2);
            else
                data(abc+xyz).locs = 0;
                data(abc+xyz).pks = 0;
            end
        end 
    end
end
if ~isfield(data,'rawpks') && isempty(data(abc).pksnew(:,1))
    for abc = animalnumber
        data(abc).rawlocs = data(abc).pksnew(:,1);
        data(abc).rawpks = data(abc).pksnew(:,2);        
    end
end
    %%
    if makegraphs
        figure('NumberTitle', 'off', 'Name', 'Sessions with Cues and Transients','units','normalized','outerposition',[0 0 1 1]); clf; hold on
        stepup = 0;
        for abc = animalnumber
            stepup = -5*abc;
            plot(data(abc).time,data(abc).sigfilt+stepup,'Color',[0 0.6 0])
%             plot(data(abc).time,data(abc).baqfilt+stepup,'Color',[0 0.6 0])
%                plot(data(abc).time,data(abc).sig+stepup,'Color',[0 0.6 0])
%             plot(data(abc).time,data(abc).baq+stepup,'Color',[0.5 0 0.5])
            plot(data(abc).locs./fsg1,data(abc).pks+stepup,'o','Color',[0.6 0 0],'LineWidth',2)
                
%                 for xyz = 1:numel(data(abc).feed)
%                     line([data(abc).cuemark(xyz) data(abc).cuemark(xyz)],[-.5+stepup .5+stepup],'Color',[1 0 0],'LineWidth',2);
%                 end
%                 for xyz = 1:numel(data(abc).entry)
%                     line([data(abc).entrymark(xyz) data(abc).entrymark(xyz)],[-.5+stepup .5+stepup],'Color',[0 0 0],'LineWidth',2);
%                 end     
                if isfield(data(abc),'feed')
                    for xyz = 1:numel(data(abc).feed)
                        line([data(abc).cuemark(xyz) data(abc).cuemark(xyz)],[-.5+stepup .5+stepup],'Color',[1 0 0],'LineWidth',2); 
                    end
                elseif isfield(data(abc),'injt')
                    for xyz = 1:numel(data(abc).injt)
                        line([data(abc).cuemark(xyz) data(abc).cuemark(xyz)],[-.5+stepup .5+stepup],'Color',[1 0 0],'LineWidth',2); 
                    end    
                else isfield(data(abc),'Sipper')
                    for xyz = 1:numel(data(abc).Sipper)
                        line([data(abc).cuemark(xyz) data(abc).cuemark(xyz)],[-.5+stepup .5+stepup],'Color',[1 0 0],'LineWidth',2); 
                    end
                end    

            text(max(data(abc).time),stepup,[data(abc).animal,'-',data(abc).conditions,' (' num2str(numel(data(abc).pks)/data(abc).tg(end)*60), ' trans/min)'])
        end
    end

if isfield(data,'structlocs')
    for abc = animalnumber
        uniquevectorprep{abc} = [data(abc).conditions];
    end
    C = cellstr(unique(uniquevectorprep));
    C = C';
else
    for abc = animalnumber
        uniquevectorprep{abc} = [data(abc).conditions];
    end
    C = cellstr(unique(uniquevectorprep));
    C = C';

    for abc = 1:size(C,1)
        for xyz = animalnumber
            if strcmp(data(xyz).conditions,C{abc})==1
                structlocs(xyz,abc) = 1;
            end
        end
        data(abc).condcomb = C{abc};
        data(abc).structlocs = find(structlocs(:,abc)==1);
    end
end

if quant1 %if quant = 1
    figure('NumberTitle', 'off', 'Name', 'Transients Per Minute'); clf; hold on;
    for abc = animalnumber
        data(abc).transpmin = numel(data(abc).pks)/data(abc).tg(end)*60; %create a category in data for transients per minute, count the number of peaks divided by (last sample time (seconds) converted into minutes)
    end
    for abc = 1:size(C,1)
        data(abc).meantranspmin = nanmean([data(data(abc).structlocs).transpmin]);
        data(abc).SEMtranspmin = nanstd([data(data(abc).structlocs).transpmin],0,2)./(sqrt(numel([data(data(abc).structlocs).transpmin])));
    end
    animalcolor = distinguishable_colors(length(C));
    plt= bar(categorical(C),[data.meantranspmin],'FaceColor','flat','LineWidth',2);
    xslot = get(plt,'XData');
    for abc = 1:size(C,1)
        pltpt = plot(xslot(abc),[data(data(abc).structlocs).transpmin],'.','Color','k','MarkerSize',14);
        freqD(:,abc) = [data(data(abc).structlocs).transpmin];
        plt.CData(abc,:) = figcol(:,abc);
    end
    errorbar(1:size(C,1),[data.meantranspmin],[data.SEMtranspmin],'.','Color','k','LineWidth',2)
    ylabel('Transients per Minute')
    title('Transient Frequency')
    xcoord = get(gca,'xLim'); xcoord = xcoord(1);
    ycoord = get(gca,'yLim'); ycoord = ycoord(2)-(diff(ycoord)/15);
    text(xcoord,ycoord,{['n = ', num2str(size(uani,2))]}, 'HorizontalAlignment', 'center')
    if print1
        set(gcf,'renderer','Painters')
        print('transFreq','-depsc')
    end
    
    
    figure('NumberTitle', 'off', 'Name', 'Peak Amplitude'); clf; hold on;
    for abc = animalnumber
        data(abc).mpks = mean(data(abc).pks);
    end
    for abc = 1:size(C,1)
        data(abc).meanpks = nanmean([data(data(abc).structlocs).mpks]);
        data(abc).SEMpks = nanstd([data(data(abc).structlocs).mpks],0,2)./(sqrt(numel([data(data(abc).structlocs).mpks])));
    end
    animalcolor = distinguishable_colors(length(C));
    plt= bar(categorical(C),[data.meanpks],'FaceColor','flat','LineWidth',2);
    xslot = get(plt,'XData');
    for abc = 1:size(C,1)
        pltpt = plot(xslot(abc),[data(data(abc).structlocs).mpks],'.','Color','k','MarkerSize',14);
        ampD(:,abc) = [data(data(abc).structlocs).mpks];
        plt.CData(abc,:) = figcol(:,abc);
    end
    errorbar(1:size(C,1),[data.meanpks],[data.SEMpks],'.','Color','k','LineWidth',2)
    ylabel('dF/F')
    title('Peak Amplitude')
    xcoord = get(gca,'xLim'); xcoord = xcoord(1);
    ycoord = get(gca,'yLim'); ycoord = ycoord(2)-(diff(ycoord)/15);
    text(xcoord,ycoord,{['n = ', num2str(size(uani,2))]}, 'HorizontalAlignment', 'center')
    if print1
        set(gcf,'renderer','Painters')
        print('transAmp','-depsc')
    end
else
    freqD = 0;
    ampD = 0;
end
end


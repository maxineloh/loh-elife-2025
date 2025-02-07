function [data,C,uani,ucond,sexbycond,sex,tw] = meanDataWindows(data,animalnumber,wss,wse,fsg1,makegraphs,alignto)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% FIND MEAN OF DATA WINDOWS
if strcmp(alignto,'DSNS')||strcmp(alignto,'SolLR')||strcmp(alignto,'DSNSfirstlick')
    for abc = animalnumber
        data(abc).mwdataP = mean((data(abc).wdataP),2); % mean
        data(abc).swdataP = (std((data(abc).wdataP),0,2))/sqrt(size((data(abc).wdataP),2)); %SEM
        data(abc).mwdataM = mean((data(abc).wdataM),2); % mean
        data(abc).swdataM = (std((data(abc).wdataM),0,2))/sqrt(size((data(abc).wdataM),2)); %SEM
    end

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
        for tuv = 1:length(data(abc).structlocs)
            data(abc).combwdataP(tuv).subwdata = data(data(abc).structlocs(tuv)).wdataP;
            data(abc).combwdataM(tuv).subwdata = data(data(abc).structlocs(tuv)).wdataM;
        end
    end
    % by condition
    for abc = 1:size(C,1)
        for xyz = 1:size(data(abc).structlocs,1)
            data(abc).mcondwdataP(xyz).sub = mean([data(abc).combwdataP(xyz).subwdata],2);
            data(abc).mcondwdataM(xyz).sub = mean([data(abc).combwdataM(xyz).subwdata],2);
        end
        data(abc).anmwdataP = mean([data(abc).mcondwdataP.sub],2);
        data(abc).answdataP = (std(([data(abc).mcondwdataP.sub]),0,2))/sqrt(size(([data(abc).mcondwdataP.sub]),2));
        data(abc).anmwdataM = mean([data(abc).mcondwdataM.sub],2);
        data(abc).answdataM = (std(([data(abc).mcondwdataM.sub]),0,2))/sqrt(size(([data(abc).mcondwdataM.sub]),2));
        for xyz = 1:size(data(abc).structlocs,1)
            A = [data(abc).mcondwdataP(xyz).sub];
            A=(A(~isnan(A)));
            if isempty(A)||~sum(A)
            else
                data(abc).peaklocP(xyz) = find([data(abc).mcondwdataP(xyz).sub]==(max([data(abc).mcondwdataP(xyz).sub])));
            end
            A = [data(abc).mcondwdataM(xyz).sub];
            A=(A(~isnan(A)));
            if isempty(A)||~sum(A)
            else
                data(abc).peaklocM(xyz) = find([data(abc).mcondwdataM(xyz).sub]==(max([data(abc).mcondwdataM(xyz).sub])));
            end
        end
    end
    % by sex and condition
    rowM = 1;
    rowF = 1;
    uani = unique({data.animal});
    ucond = unique({data.conditions});
    for abc = 1:size(C,1)
        sex(1).wdataP(abc).cond = [data(find(strcmp(ucond(abc),{data.conditions}) & strcmp('m',{data.sex}))).mwdataP];
        sex(2).wdataP(abc).cond = [data(find(strcmp(ucond(abc),{data.conditions}) & strcmp('f',{data.sex}))).mwdataP];
        
        sex(1).wdataM(abc).cond = [data(find(strcmp(ucond(abc),{data.conditions}) & strcmp('m',{data.sex}))).mwdataM];
        sex(2).wdataM(abc).cond = [data(find(strcmp(ucond(abc),{data.conditions}) & strcmp('f',{data.sex}))).mwdataM];
    end
    for abc = 1:size(C,1)
        sexbycond(1).signalP(abc).mean = mean([sex(1).wdataP(abc).cond],2);
        sexbycond(1).signalP(abc).sem = (std(([sex(1).wdataP(abc).cond]),0,2))/sqrt(size(([sex(1).wdataP(abc).cond]),2));
        sexbycond(2).signalP(abc).mean = mean([sex(2).wdataP(abc).cond],2);
        sexbycond(2).signalP(abc).sem = (std(([sex(2).wdataP(abc).cond]),0,2))/sqrt(size(([sex(2).wdataP(abc).cond]),2));
        
        sexbycond(1).signalM(abc).mean = mean([sex(1).wdataM(abc).cond],2);
        sexbycond(1).signalM(abc).sem = (std(([sex(1).wdataM(abc).cond]),0,2))/sqrt(size(([sex(1).wdataM(abc).cond]),2));
        sexbycond(2).signalM(abc).mean = mean([sex(2).wdataM(abc).cond],2);
        sexbycond(2).signalM(abc).sem = (std(([sex(2).wdataM(abc).cond]),0,2))/sqrt(size(([sex(2).wdataM(abc).cond]),2));
    end
    tw = (((wss)):1/fsg1:((wse)))';
    titleOfFigure = ['Windowed Data of sessions aligned to ', alignto];
    if makegraphs
        figure('NumberTitle', 'off', 'Name', titleOfFigure); clf; title(alignto)
        for abc = animalnumber
            translateY = -0.5*abc;
            f1 = subplot(1,2,1); hold on
            plot(tw,data(abc).mwdataP+translateY,'Color',[0 0.4 0])
            text(max(tw),translateY,[data(abc).date '-' data(abc).animal '-' data(abc).conditions], 'interpreter', 'none')
            line([0 0], get(gca, 'yLim'), 'Color', 'r')
            f2 = subplot(1,2,2); hold on
            plot(tw,data(abc).mwdataM+translateY,'Color',[0 0.4 0])
            text(max(tw),translateY,[data(abc).date '-' data(abc).animal '-' data(abc).conditions], 'interpreter', 'none')
            line([0 0], get(gca, 'yLim'), 'Color', 'r')
        end
        
        clear translateY
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for abc = animalnumber
        data(abc).mwdata = mean((data(abc).wdata),2); % mean
        data(abc).medwdata = median((data(abc).wdata),2); % median
        data(abc).swdata = (std((data(abc).wdata),0,2))/sqrt(size((data(abc).wdata),2)); %SEM
    end

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
        for tuv = 1:length(data(abc).structlocs)
            data(abc).combwdata(tuv).subwdata = data(data(abc).structlocs(tuv)).wdata;
        end
    end
    % by condition
    for abc = 1:size(C,1)
        for xyz = 1:size(data(abc).structlocs,1)
            data(abc).mcondwdata(xyz).sub = mean([data(abc).combwdata(xyz).subwdata],2);
            data(abc).medcondwdata(xyz).sub = median([data(abc).combwdata(xyz).subwdata],2);
        end
        data(abc).anmwdata = mean([data(abc).mcondwdata.sub],2); %gets mean from each column and returns averages in row form
        data(abc).anmedwdata = median([data(abc).mcondwdata.sub],2);
        data(abc).answdata = (std(([data(abc).mcondwdata.sub]),0,2))/sqrt(size(([data(abc).mcondwdata.sub]),2));
        for xyz = 1:size(data(abc).structlocs,1)
            A = [data(abc).mcondwdata(xyz).sub];
            A=(A(~isnan(A)));
            if isempty(A)==1
            else
                data(abc).peakloc(xyz) = find([data(abc).mcondwdata(xyz).sub]==(max([data(abc).mcondwdata(xyz).sub])));
            end
        end
    end
    % by sex and condition
    rowM = 1;
    rowF = 1;
    uani = unique({data.animal});
    ucond = unique({data.conditions});
    if isfield(data,'sex')
        for abc = 1:size(C,1)
            sex(1).wdata(abc).cond = [data(find(strcmp(ucond(abc),{data.conditions}) & strcmp('m',{data.sex}))).mwdata];
            sex(2).wdata(abc).cond = [data(find(strcmp(ucond(abc),{data.conditions}) & strcmp('f',{data.sex}))).mwdata];
        end
        for abc = 1:size(C,1)
            sexbycond(1).signal(abc).mean = mean([sex(1).wdata(abc).cond],2);
            sexbycond(1).signal(abc).sem = (std(([sex(1).wdata(abc).cond]),0,2))/sqrt(size(([sex(1).wdata(abc).cond]),2));
            sexbycond(2).signal(abc).mean = mean([sex(2).wdata(abc).cond],2);
            sexbycond(2).signal(abc).sem = (std(([sex(2).wdata(abc).cond]),0,2))/sqrt(size(([sex(2).wdata(abc).cond]),2));
        end
        tw = (((wss)):1/fsg1:((wse)))';
        titleOfFigure = ['Windowed Data of sessions aligned to ', alignto];
        if makegraphs
            figure('NumberTitle', 'off', 'Name', titleOfFigure); clf; hold on; title(alignto)
            for abc = animalnumber
                translateY = -0.5*abc;
                plot(tw,data(abc).mwdata+translateY,'Color',[0 0.4 0])
                text(max(tw),translateY,[data(abc).date '-' data(abc).animal '-' data(abc).conditions], 'interpreter', 'none')
                line([0 0], get(gca, 'yLim'), 'Color', 'r')
            end
            clear stepup11
        end
    else
        sexbycond = 0;
        sex = 0;
        tw = (((wss)):1/fsg1:((wse)))';
    end
end
end


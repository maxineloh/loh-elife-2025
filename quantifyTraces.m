                                                                                                                                                                  function [data] = quantifyTraces(data,sexbycond,ix,C,animalnumber,figcol,wss,fsg1,alignto,drugname,print1,meanormax)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

%% QUANTIFY BY CONDITIONS

if strcmp(alignto,'DSNS')||strcmp(alignto,'DSNSfirstlick')
    switch meanormax
        case 'mean'
            for abc = animalnumber
                data(abc).mmwdataP = mean(data(abc).mwdataP(ix(3):ix(4)));
                data(abc).mmwdataM = mean(data(abc).mwdataM(ix(3):ix(4)));
            end
        case 'max'
            for abc = animalnumber
                data(abc).mmwdataP = max(data(abc).mwdataP(ix(3):ix(4)));
                data(abc).mmwdataM = max(data(abc).mwdataM(ix(3):ix(4)));
            end
        case 'AUC'
            for abc = animalnumber
    %             data(abc).mmwdata = trapz(data(abc).mwdata(ix(3):ix(4)));
                data(abc).mmwdataP = sum(data(abc).mwdataP(ix(3):ix(4)));
                data(abc).mmwdataM = sum(data(abc).mwdataM(ix(3):ix(4)));
            end    
    end
    for abc = 1:size(C,1)
        %
        data(abc).meancondsigavgP = mean([data(data(abc).structlocs).mmwdataP]);
        data(abc).SEMcondsigavgP = std([data(data(abc).structlocs).mmwdataP])./(sqrt(numel([data(data(abc).structlocs).mmwdataP])));
        %
        data(abc).meancondsigavgM = mean([data(data(abc).structlocs).mmwdataM]);
        data(abc).SEMcondsigavgM = std([data(data(abc).structlocs).mmwdataM])./(sqrt(numel([data(data(abc).structlocs).mmwdataM])));
    end

        animalcolor = distinguishable_colors(length(C));
        figure('NumberTitle', 'off', 'Name', 'Mean of signal at alignment');
        %
        f1 = subplot(1,2,1); hold on;
        title(['Plus Cue: Mean of Signal ', num2str(floor((ix(3)/fsg1))+wss), 's to ', num2str(floor((ix(4)/fsg1))+wss), 's after ', alignto])
        barpltP= bar(categorical(C),[data.meancondsigavgP],'FaceColor','flat','LineWidth',2);
        errorbar(1:size(C,1),[data.meancondsigavgP],[data.SEMcondsigavgP],'.','Color','k','LineWidth',2)
        %
        f2 = subplot(1,2,2); hold on;
        title(['Minus Cue: Mean of Signal ', num2str(floor((ix(3)/fsg1))+wss), 's to ', num2str(floor((ix(4)/fsg1))+wss), 's after ', alignto])
        barpltM= bar(categorical(C),[data.meancondsigavgM],'FaceColor','flat','LineWidth',2);
        errorbar(1:size(C,1),[data.meancondsigavgM],[data.SEMcondsigavgM],'.','Color','k','LineWidth',2)
        
        xslotP = get(barpltP,'XData');xslotM = get(barpltM,'XData');
        for abc = 1:size(C,1)
            %
            subplot(1,2,1); hold on
            barpltptP = plot(xslotP(abc),[data(data(abc).structlocs).mmwdataP],'.','Color','k','MarkerSize',14);
            barpltP.CData(abc,:) = figcol(:,abc);
        end
        ylabel('dF/F')
        xticklabels(drugname)
        for abc = 1:size(C,1)
            %
            subplot(1,2,2); hold on
            barpltptM = plot(xslotM(abc),[data(data(abc).structlocs).mmwdataM],'.','Color','k','MarkerSize',14);
            barpltM.CData(abc,:) = figcol(:,abc);
        end
        linkaxes([f1 f2],'y')
        ylabel('dF/F')
        xticklabels(drugname)
        if print1
            print('quantsigavg_cond','-djpeg')
            print('quantsigavg_cond','-depsc')
        end

    %% QUANTIFY BY CONDITIONS AND SEX
    if size(unique({data.sex}),2)==2
        for abc = 1:size(C,1)
            sexbycond(1).condP(abc).mean = mean([data(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))).mmwdataP]);
            sexbycond(1).condP(abc).sem = std([data(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))).mmwdataP]./(sqrt(numel([data(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))).mmwdataP]))));
            sexbycond(2).condP(abc).mean = mean([data(find(strcmp(C(abc),{data.conditions}) & strcmp('f',{data.sex}))).mmwdataP]);
            sexbycond(2).condP(abc).sem = std([data(find(strcmp(C(abc),{data.conditions}) & strcmp('f',{data.sex}))).mmwdataP]./(sqrt(numel([data(find(strcmp(C(abc),{data.conditions}) & strcmp('f',{data.sex}))).mmwdataP]))));
            %
            sexbycond(1).condM(abc).mean = mean([data(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))).mmwdataM]);
            sexbycond(1).condM(abc).sem = std([data(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))).mmwdataM]./(sqrt(numel([data(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))).mmwdataM]))));
            sexbycond(2).condM(abc).mean = mean([data(find(strcmp(C(abc),{data.conditions}) & strcmp('f',{data.sex}))).mmwdataM]);
            sexbycond(2).condM(abc).sem = std([data(find(strcmp(C(abc),{data.conditions}) & strcmp('f',{data.sex}))).mmwdataM]./(sqrt(numel([data(find(strcmp(C(abc),{data.conditions}) & strcmp('f',{data.sex}))).mmwdataM]))));
        end
            figure('NumberTitle', 'off', 'Name', 'Sex specific mean of signal at alignment')
            
            maleavgplotP = subplot(2,2,1); hold on; title('Plus Cue: Male')
            malepltP= bar(categorical(C),[sexbycond(1).condP.mean],'FaceColor','flat','LineWidth',2);
            errorbar(1:size(C,1),[sexbycond(1).condP.mean],[sexbycond(1).condP.sem],'.','Color','k','LineWidth',2)
            xslotP = get(malepltP,'XData');
            for abc = 1:size(C,1)
                malepltptP = plot(xslotP(abc),[data(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))).mmwdataP],'.','Color','k','MarkerSize',14);
                malepltP.CData(abc,:) = figcol(:,abc);
            end
        %     indivptsMx = cell(1,numel(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))));
            ylabel('dF/F')
            xticklabels(drugname)
            %
            maleavgplotM = subplot(2,2,2); hold on; title('Minus Cue: Male')
            malepltM= bar(categorical(C),[sexbycond(1).condM.mean],'FaceColor','flat','LineWidth',2);
            errorbar(1:size(C,1),[sexbycond(1).condM.mean],[sexbycond(1).condM.sem],'.','Color','k','LineWidth',2)
            xslot = get(malepltM,'XData');
            for abc = 1:size(C,1)
                malepltptM = plot(xslot(abc),[data(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))).mmwdataM],'.','Color','k','MarkerSize',14);
                malepltM.CData(abc,:) = figcol(:,abc);
            end
        %     indivptsMx = cell(1,numel(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))));
            ylabel('dF/F')
            xticklabels(drugname)
            
            
            
            femaleavgplotP = subplot(2,2,3); hold on; title('Plus Cue: Female')
            femalepltP= bar(categorical(C),[sexbycond(2).condP.mean],'FaceColor','flat','LineWidth',2);
            errorbar(1:size(C,1),[sexbycond(2).condP.mean],[sexbycond(2).condP.sem],'.','Color','k','LineWidth',2)
            xslotP = get(femalepltP,'XData');
            for abc = 1:size(C,1)
                femalepltptP = plot(xslotP(abc),[data(find(strcmp(C(abc),{data.conditions}) & strcmp('f',{data.sex}))).mmwdataP],'.','Color','k','MarkerSize',14);
                femalepltP.CData(abc,:) = figcol(:,abc);
            end
            xticklabels(drugname)
            %
            femaleavgplotM = subplot(2,2,4); hold on; title('Minus Cue: Female')
            femalepltM= bar(categorical(C),[sexbycond(2).condM.mean],'FaceColor','flat','LineWidth',2);
            errorbar(1:size(C,1),[sexbycond(2).condM.mean],[sexbycond(2).condM.sem],'.','Color','k','LineWidth',2)
            xslotM = get(femalepltM,'XData');
            for abc = 1:size(C,1)
                femalepltptM = plot(xslotM(abc),[data(find(strcmp(C(abc),{data.conditions}) & strcmp('f',{data.sex}))).mmwdataM],'.','Color','k','MarkerSize',14);
                femalepltM.CData(abc,:) = figcol(:,abc);
            end
            xticklabels(drugname)
            
            for abc = 1:size(C,1)
                malepltP.CData(abc,:) = figcol(:,abc);    
                femalepltP.CData(abc,:) = figcol(:,abc);    
                %
                malepltM.CData(abc,:) = figcol(:,abc);    
                femalepltM.CData(abc,:) = figcol(:,abc);    
            end
            linkaxes([maleavgplotP femaleavgplotP maleavgplotM femaleavgplotM],'y')
            xticklabels(drugname)
            if print1
                print('quantsigavg_condbysex','-djpeg')
                print('quantsigavg_condbysex','-depsc')
            end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    switch meanormax
        case 'mean'
            for abc = animalnumber
                data(abc).mmwdata = mean(data(abc).mwdata(ix(3):ix(4)));
            end
        case 'max'
            for abc = animalnumber
                data(abc).mmwdata = max(data(abc).mwdata(ix(3):ix(4)));
            end
        case 'AUC'
            for abc = animalnumber
    %             data(abc).mmwdata = trapz(data(abc).mwdata(ix(3):ix(4)));
                data(abc).mmwdata = sum(data(abc).mwdata(ix(3):ix(4)));
            end    
    end
    
    
    for abc = 1:size(C,1)
        data(abc).meancondsigavg = mean([data(data(abc).structlocs).mmwdata]);
        data(abc).SEMcondsigavg = std([data(data(abc).structlocs).mmwdata])./(sqrt(numel([data(data(abc).structlocs).mmwdata])));
    end

        animalcolor = distinguishable_colors(length(C));
        figure('NumberTitle', 'off', 'Name', 'Mean of signal at alignment');hold on
        barplt= bar(categorical(C),[data.meancondsigavg],'FaceColor','flat','LineWidth',2);
        errorbar(1:size(C,1),[data.meancondsigavg],[data.SEMcondsigavg],'.','Color','k','LineWidth',2)
        xslot = get(barplt,'XData');
        for abc = 1:size(C,1)
    %         if size(data(abc).structlocs,1)==1
    %             barpltpt = plot(xslot(abc),[data(data(abc).structlocs).mwdata],'.','Color','k','MarkerSize',14);
    %         else
    %             barpltpt = plot(xslot(abc),[data(data(abc).structlocs).mmwdata],'.','Color','k','MarkerSize',14);
    %         end
            barpltpt = plot(xslot(abc),[data(data(abc).structlocs).mmwdata],'.','Color','k','MarkerSize',14);
            barplt.CData(abc,:) = figcol(:,abc);
        end
        ylabel('dF/F')
        title(['Mean of Signal ', num2str(floor((ix(3)/fsg1))+wss), 's to ', num2str(floor((ix(4)/fsg1))+wss), 's after ', alignto])
        xticklabels(drugname)
        if print1
            print('quantsigavg_cond','-djpeg')
            print('quantsigavg_cond','-depsc')
        end

    %% QUANTIFY BY CONDITIONS AND SEX
    if size(unique({data.sex}),2)==2
        for abc = 1:size(C,1)
            sexbycond(1).cond(abc).mean = mean([data(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))).mmwdata]);
            sexbycond(1).cond(abc).sem = std([data(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))).mmwdata]./(sqrt(numel([data(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))).mmwdata]))));
            sexbycond(2).cond(abc).mean = mean([data(find(strcmp(C(abc),{data.conditions}) & strcmp('f',{data.sex}))).mmwdata]);
            sexbycond(2).cond(abc).sem = std([data(find(strcmp(C(abc),{data.conditions}) & strcmp('f',{data.sex}))).mmwdata]./(sqrt(numel([data(find(strcmp(C(abc),{data.conditions}) & strcmp('f',{data.sex}))).mmwdata]))));
        end
            figure('NumberTitle', 'off', 'Name', 'Sex specific mean of signal at alignment')
            maleavgplot = subplot(1,2,1); hold on
            maleplt= bar(categorical(C),[sexbycond(1).cond.mean],'FaceColor','flat','LineWidth',2);
            errorbar(1:size(C,1),[sexbycond(1).cond.mean],[sexbycond(1).cond.sem],'.','Color','k','LineWidth',2)
            xslot = get(maleplt,'XData');
            for abc = 1:size(C,1)
                malepltpt = plot(xslot(abc),[data(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))).mmwdata],'.','Color','k','MarkerSize',14);
                maleplt.CData(abc,:) = figcol(:,abc);
            end
            title('Male')
        %     indivptsMx = cell(1,numel(find(strcmp(C(abc),{data.conditions}) & strcmp('m',{data.sex}))));
            ylabel('dF/F')
            xticklabels(drugname)
            femaleavgplot = subplot(1,2,2); hold on
            femaleplt= bar(categorical(C),[sexbycond(2).cond.mean],'FaceColor','flat','LineWidth',2);
            errorbar(1:size(C,1),[sexbycond(2).cond.mean],[sexbycond(2).cond.sem],'.','Color','k','LineWidth',2)
            xslot = get(femaleplt,'XData');
            for abc = 1:size(C,1)
                femalepltpt = plot(xslot(abc),[data(find(strcmp(C(abc),{data.conditions}) & strcmp('f',{data.sex}))).mmwdata],'.','Color','k','MarkerSize',14);
                femaleplt.CData(abc,:) = figcol(:,abc);
            end
            xticklabels([])
            for abc = 1:size(C,1)
                maleplt.CData(abc,:) = figcol(:,abc);    
                femaleplt.CData(abc,:) = figcol(:,abc);    
            end
            linkaxes([maleavgplot femaleavgplot],'y')
            title('Female')
            xticklabels(drugname)
            if print1
                print('quantsigavg_condbysex','-djpeg')
                print('quantsigavg_condbysex','-depsc')
            end
    end
end

end


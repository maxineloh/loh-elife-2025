function [data,alldata,fsg1,slashes,dashes,animalnumber] = loadFPData_RD(filename, data, clip, animalnumber, username)
%extraction and loading of the data files
    if isempty(animalnumber)
        animalnumber = 1:size(filename,1);
    end
    for abc = animalnumber
        loaddisp = sprintf('Loading file number: %.f',abc);
        disp(loaddisp)
        alldata=TDTbin2mat(filename{abc});
        data(abc).fp = 1;
        if strfind(filename{abc}, 'test_experiment')>=1
            if isfield(alldata.streams, 'x05n')
                fsg1 = alldata.streams.x05n.fs;
            else
                fsg1 = alldata.streams.x405n.fs;
            end
        else
            if isfield(alldata.streams, 'x05A')
                fsg1 = alldata.streams.x05A.fs;
            else isfield(alldata.streams, 'x405A')
                fsg1 = alldata.streams.x405A.fs;
            end
%         else
%             fsg1 = alldata.streams.x405A.fs;
%             fsg1 = alldata.streams.x05A.fs;
        end

        slashes{abc} = strfind(filename{abc,1},'\');
        dashes{abc} = strfind(filename{abc,1},'-');

        data(abc).date = alldata.info.date;
        % animal number
%         if strcmp(username,'Vaibhav')
%             data(abc).animal = [filename{abc,1}(slashes{abc}(end)+1:dashes{abc}(2)-1)];
%         elseif strcmp(username,'Ted')
%             data(abc).animal = [filename{abc,1}(slashes{abc}(end)+1:dashes{abc}(3)-1)];
%         elseif strcmp(username,'Sam')
%             data(abc).animal = [filename{abc,1}(slashes{abc}(end)+1:dashes{abc}(end-1)-1)];
%         end
        k = strfind(alldata.info.blockname,'-');
        data(abc).animal = alldata.info.blockname(1:k(1)-1);

        % 465nm sigfiltnal
        if strfind(filename{abc}, 'test_experiment')>=1
            if isfield(alldata.streams, 'x05n')
                data(abc).sig = double(alldata.streams.x65n.data(round(clip*fsg1):round(end-(clip*fsg1))));
                % 405nm background sigfiltnal
                data(abc).baq = double(alldata.streams.x05n.data(round(clip*fsg1):round((clip*fsg1)+size(data(abc).sig,2)-1)));
            else
                data(abc).sig = double(alldata.streams.x465n.data(round(clip*fsg1):round(end-(clip*fsg1))));
                data(abc).baq = double(alldata.streams.x405n.data(round(clip*fsg1):round((clip*fsg1)+size(data(abc).sig,2)-1)));
            end
        else strfind(filename{abc}, 'test_experiment')>=1
            if isfield(alldata.streams, 'x05A')
                data(abc).sig = double(alldata.streams.x65A.data(round(clip*fsg1):round(end-(clip*fsg1))));
                data(abc).baq = double(alldata.streams.x05A.data(round(clip*fsg1):round((clip*fsg1)+size(data(abc).sig,2)-1)));
            else isfield(alldata.streams, 'x405A')
                data(abc).sig = double(alldata.streams.x465A.data(round(clip*fsg1):round(end-(clip*fsg1))));
                data(abc).baq = double(alldata.streams.x405A.data(round(clip*fsg1):round((clip*fsg1)+size(data(abc).sig,2)-1)));
            end
%         else
% %             data(abc).sig = double(alldata.streams.x65A.data(round(clip*fsg1):round(end-(clip*fsg1))));
%             data(abc).sig = double(alldata.streams.x465A.data(round(clip*fsg1):round(end-(clip*fsg1))));
%             % 405nm background sigfiltnal
% %             data(abc).baq = double(alldata.streams.x05A.data(round(clip*fsg1):round((clip*fsg1)+size(data(abc).sig,2)-1)));
%             data(abc).baq = double(alldata.streams.x405A.data(round(clip*fsg1):round((clip*fsg1)+size(data(abc).sig,2)-1)));
        end
        % time vector for graphing
        data(abc).time = (0:1/fsg1:((numel(data(abc).sig)-1)/fsg1));
%         if strfind(filename{abc,1},'morphine_RD')
%               if isfield(alldata.epocs,'sess')
%                 data(abc).start = round(((alldata.epocs.sess.onset).*fsg1)-(clip*fsg1));  
%               end
%               if isfield(alldata.epocs,'injt')
%                 data(abc).inject = round(((alldata.epocs.injt.onset).*fsg1)-(clip*fsg1));  
%                 data(abc).inject = round(((alldata.epocs.CueP.onset).*fsg1)-(clip*fsg1));  
% 
%               end
%               if isfield(alldata.epocs,'stop')
%                 data(abc).stop = round(((alldata.epocs.stop.onset).*fsg1)-(clip*fsg1));  
%               end
              
        if strfind(filename{abc,1},'VTA')
%         if strfind(filename{abc,1},'GF')
%         if strfind(filename{abc,1},'CTA Fiber Photometry Data')
%         if strfind(filename{abc,1},'LiClFiles')
%         if strfind(filename{abc,1},'FrucGlu')

              if isfield(alldata.epocs,'feed')
                data(abc).feed = round(((alldata.epocs.feed.onset).*fsg1)-(clip*fsg1));  
              end
              if isfield(alldata.epocs,'etry')
                data(abc).entry = round(((alldata.epocs.etry.onset).*fsg1)-(clip*fsg1)); 
              end
              if isfield(alldata.epocs,'Sper')
                data(abc).Sipper = round(((alldata.epocs.Sper.onset).*fsg1)-(clip*fsg1))
              end
              if isfield(alldata.epocs,'ssol')
                data(abc).Sipper = round(((alldata.epocs.ssol.onset).*fsg1)-(clip*fsg1))
              end
              if isfield(alldata.epocs,'injt')
                data(abc).injt = round(((alldata.epocs.injt.onset).*fsg1)-(clip*fsg1))
              end 
                        
        end    
       end
end


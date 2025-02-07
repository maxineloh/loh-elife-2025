function [data, windowtest, animalnumber, trtVecs] = errCorrFinalEventTooShort(data, animalnumber, fsg1, wss, wse,trtVecs)
%errCorrFinalEventTooShort: Detect and remove events that happen at the end
%of the session and the recording ends prematurely.
%   Uses the peakdectection function
%   INPUT args: (1) data: structure that contains all data as output by
%                           loadFPData.
%               (2) animalnumber: vector containing all animals
%               (3) trtVecs: this is a matrix containing the filename slots
%                           of the all the animals, with the control in the
%                           first row and subsequent treatments in the
%                           following rows.
%               (4) expdsn: this is a matrix containing the experimental
%                           design, as defined in the parameter section.
%               (5) fsg1: sampling rate (rig-unique).
%               (4) wss: the amount of seconds before the event (negative).
%               (5) wse: the amount of seconds after the event (positive).
%
%   OUTPUT args:(1) data: output the same structure but with peaks and locs
%                           fields.
%               (2) uani: cell array of all the unique animals.
%               (3) ucond: cell array of all the unique conditions.

%%
        for abc = animalnumber
            if data(abc).ntrain==0
            else
                windowtest(abc,:) = ((data(abc).trainOn(data(abc).ntrain)+((wss)*fsg1))...
                    :(data(abc).trainOn(data(abc).ntrain)+((wse)*fsg1)))';
                if windowtest(abc,end)>length(data(abc).sigfilt)
                    data(abc).trainOn(end) = [];
                    data(abc).ntrain = data(abc).ntrain-1;
                end
            end
        end
        for abc = animalnumber
            if data(abc).ntrain==0
                trtVecs = trtVecs(trtVecs~=abc);
            else
                window(:,abc) = ((data(abc).trainOn(1)+((wss)*fsg1)):(data(abc).trainOn(1)+((wse)*fsg1)))';
                if window(1,abc)<0
                    data(abc).trainOn(1) = [];
                    data(abc).ntrain = data(abc).ntrain-1;
                end
            end
        end

data(find([data.ntrain]==0))=[];
animalnumber = 1:(size([data.ntrain],2));
end


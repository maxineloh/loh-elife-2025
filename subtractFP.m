function [data] = subtractFP(data,animalnumber,usewhichfilter)
% INPUTS:
% DATA: This is a structure that contains at least the 
%       465 and 405 signals as data(XX).sig and 
%       data(XX).baq, respectively.
%       XX represents each TDT block (each recorded 
%       session).
%
% ANIMALNUMBER: This is a vector of 1 through the
%       number of animals present in the data structure.
%       eg., a data structure of 5 sessions is:
%       animalnumber = [1, 2, 3, 4, 5];
%
% USEWHICHFILTER: This is a character string that is
%       either 'fft' or 'regress'. The 'fft' option 
%       subtracts the signal in the frequency domain
%       and returns the signal as field 'sigfilt' in
%       the time domain. The 'regress' option uses a 
%       least-squares linear regression to compute a
%       subtracted signal, as in Lerner et. al., 2015.
%
%
% OUTPUTS:
% DATA: This is the original data structure with the
%       data(XX).sigfilt added in.

[a,b] = butter(3,.00001,'high');
[c,d] = butter(5,0.0045,'low');
for abc = animalnumber
    pt = length(data(abc).sig);
    if strcmp('fft',usewhichfilter)==1
        if length(data(abc).sig)==length(data(abc).baq)
            XX_temp = data(abc).baq;
            Y_temp = data(abc).sig;
        elseif length(data(abc).sig)>length(data(abc).baq)
            XX_temp = data(abc).baq;
            Y_temp = data(abc).sig(1:length(data(abc).baq));
        elseif length(data(abc).sig)<length(data(abc).baq)
            Y_temp = data(abc).sig;
            XX_temp = data(abc).baq(1:length(data(abc).sig));
        end
        xxfactor = mean(data(abc).sig)/mean(data(abc).baq);
        XX = fft(XX_temp.*xxfactor,pt);
        Y = fft(Y_temp,pt);
        Ynet = Y-XX;
        Ynetb = XX-XX;
        data(abc).sigfilt = (double(real(ifft((Ynet)))));
        data(abc).baqfilt = (double(real(ifft(Ynetb))));
        data(abc).sigfilt = filtfilt(a,b,data(abc).sigfilt);
        data(abc).sigfilt = filtfilt(c,d,data(abc).sigfilt);
    elseif strcmp('regress',usewhichfilter)==1
        if length(data(abc).sig)==length(data(abc).baq)
            XX_temp = data(abc).baq;
            Y_temp = data(abc).sig;
        elseif length(data(abc).sig)>length(data(abc).baq)
            XX_temp = data(abc).baq;
            Y_temp = data(abc).sig(1:length(data(abc).baq));
        elseif length(data(abc).sig)<length(data(abc).baq)
            Y_temp = data(abc).sig;
            XX_temp = data(abc).baq(1:length(data(abc).sig));
        end
        XX = detrend(XX_temp);
        Y = detrend(Y_temp);
        bls = polyfit((XX),(Y),1);
        Y_fit = bls(1) .* XX + bls(2);
        data(abc).sigfilt = (Y - Y_fit);
%         data(abc).sigfilt = data(abc).sigfilt./max(data(abc).sigfilt);
        data(abc).baqfilt = XX - Y_fit;
    elseif strcmp('raw',usewhichfilter)==1
        data(abc).sigfilt = data(abc).sig;
        data(abc).baqfilt = data(abc).baq;
     
    end
end
end


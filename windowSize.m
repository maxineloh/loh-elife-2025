function [wss, wse, ws] = windowSize(alignto,varargin)
%windowSize Summary of this function goes here
%   Detailed explanation goes here

a = struct(...
    'overWriteWindow', []);
a = parseArgsLite(varargin, a);


if isempty(a.overWriteWindow)
    a.overWriteWindow = [-5 10]; %winndow size seconds -5 start, 5 end
else
%     a.overWriteWindow = [];
end

if strcmp(alignto,'Trans')==1
    wss = -1;
    wse = 1;
    ws = wse-wss;
else
    wss = a.overWriteWindow(1);
    wse = a.overWriteWindow(2);
    ws = wse-wss;
end
end


function string = array2str(a, operator, form)
% Converts a numeric array to a string. The difference from NUM2STR is this
% function convert number series into "abbreviated" matlab expressions
% with colons operators.
%
% usage:
%  string = array2str(array)
%  string = array2str(array, operator)
%  string = array2str(array, operator, format)
%
% array: must be numeric. It can be a row vector or column verctor. If it's
%         a matrix, the output will be a cell array containing strings
%         corrisponding to the rows of the array.
% operator: a character you would like be the operator. Default is ':'. It
%         can be like '-' or '~', for example.
% format: the same format string used in SPRINTF to format numbers.
%
% example:
%  string = array2str([1 2 3 4 6 8 10 12 13])
% the output is '[1:4 6:2:12 13]'
%
% See also NUM2STR, MAT2STR, SPRINTF

% Author: Li, Su - 03/27/2008

operator=default('operator',':');
form = default('form',3);
[rows cols]=size(a);
if rows>1
    if cols==1
        string=[array2str(a', operator, form) ''''];
        return;
    else
        string=cell(rows,1);
        for k=1:rows
            string{k}=array2str(a(k,:), operator, form);
        end
        return;
    end
end

string='[';

da=[diff(a) inf];
dda=[1 diff(da)];

while ~isempty(dda) && ~isempty(a)
    string=[string num2str(a(1),form)];
    if length(a)<=1 || dda(2)~=0 || da(1)==0
        string=[string ' '];
        idx=1;
    else
        idx = 1 + find(dda(2:end),1);
        if da(1)~=1
            string = [string operator num2str(da(1),form)];
        end
        string = [string operator num2str(a(idx),form) ' '];
    end
    dda(1:idx)=[];
    da(1:idx)=[];
    a(1:idx)=[];
end
string=[deblank(string) ']'];

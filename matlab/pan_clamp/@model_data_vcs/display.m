function str = display(a_md)

% display - Return string representation of object.
%
% Usage:
% str = display(a_md)
%
% Parameters:
%   a_md: A model_data_vcs object.
% 
% Returns:
%   str: Readable string
%
% Description:
%
% Example:
%
% See also: model_data_vcs
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/31

% Handle differently if an array
if length(a_md) > 1
  disp(a_md);
  return;
end

%props = get(a_md, 'props');

disp(sprintf('%s, %s', class(a_md), get(a_md, 'id')));

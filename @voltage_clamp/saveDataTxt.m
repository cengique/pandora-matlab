function saveDataTxt(a_vc, props)

% saveDataTxt - Simulate voltage clamp current on a model channel and superpose on data.
%
% Usage:
% saveDataTxt(a_vc, props)
%
% Parameters:
%   a_vc: A voltage_clamp object.
%   props: A structure with any optional properties.
%		
% Returns:
%
% Description:
%
% Example:
% >> saveDataTxt(a_vc)
%
% See also: voltage_clamp
%
% $Id: saveDataTxt.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/29

% TODO: 

if ~ exist('props', 'var')
  props = struct;
end

dt = get(a_vc, 'dt');

data_i = get(a_vc.i, 'data');
cell_name = get(a_vc, 'id');
time = (0:(size(data_i, 1)-1))*dt;

vc_props = get(a_vc, 'props');

% extract cell name and path from file
[pathstr, cell_name, ext, versn] = fileparts(vc_props.filename);

% write to text file for NeuroFit (time + current traces)
dlmwrite([ pathstr filesep cell_name '.txt' ], ...
         [time(:), data_i], ' ' );

function saveDataTxt(a_vc, props)

% saveDataTxt - Save time and current into a simple text file as columns.
%
% Usage:
% saveDataTxt(a_vc, props)
%
% Parameters:
%   a_vc: A voltage_clamp object.
%   props: A structure with any optional properties.
%     addName: String to append to file name.
%     saveV: Save voltage as well.
%		
% Returns:
%
% Description:
%   File will be written to the same directory as the original vc was
% loaded from.
%
% Example:
% >> saveDataTxt(a_vc)
%
% See also: voltage_clamp
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/29

% TODO: 

if ~ exist('props', 'var')
  props = struct;
end

dt = get(a_vc, 'dt') * 1e3;             % convert to ms

data_i = get(a_vc.i, 'data');
cell_name = get(a_vc, 'id');
time = (0:(size(data_i, 1)-1))*dt;

if isfield(props, 'saveV')
  data_i = [ data_i get(a_vc.v, 'data') ];
end

vc_props = get(a_vc, 'props');

% extract cell name and path from file
[pathstr, cell_name, ext] = fileparts(vc_props.filename);

% write to text file for NeuroFit (time + current traces)
dlmwrite([ pathstr filesep cell_name getFieldDefault(props, 'addName', '') '.txt' ], ...
         [time(:), data_i], ' ' );

function a_vc = abf2voltage_clamp(filename, sup_id, props)

% abf2voltage_clamp - Load I and V traces from an ABF file and make a voltage_clamp object.
%
% Usage:
% a_vc = abf2voltage_clamp(filename, sup_id, props)
%
% Parameters:
%   filename: Full path to filename.
%   sup_id: (Optional) Concatenated to cell filename as id of voltage_clamp object.
%   props: A structure with any optional properties.
%     ichan: Current channel number or ':' for all channels when
%     	     there is more than one  to choose.
%     actualProtocols: Means current trace is a TTL pulse and its
%     		       magnitude is meaningless.
%		
% Returns:
%   a_vc: A voltage_clamp object.
%
% Description:
%
% Example:
% >> a_vc = abf2voltage_clamp('data-dir/cell-A.abf', 'my first cell');
% >> plot(a_vc);
%
% See also: loadVclampAbf, abf2load, voltage_clamp
%
% $Id: abf2voltage_clamp.m 816 2014-07-17 02:06:58Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/11

% TODO:

  props = defaultValue('props', struct);
  sup_id = defaultValue('sup_id', '');

  % save the filename in the props for future reference
  props.filename = filename;
  
  if isfield(props,'actualProtocols')
%       One trace per file (fred)
        all_data_i=[];  %array
        all_data_v=[];
        all_time=[];
        all_cell_name=[];
        all_dt=[];
        [pathstr, name, ext, versn] = fileparts(filename);
        here=cd;
        cd(pathstr);
        fileNums=[];
        for j=props.actualProtocols.cipFilenumRange(1): ...
              props.actualProtocols.cipFilenumRange(2)
            
            test=dir([sprintf(props.fileTempl,j)]);
            if ~isempty(test)
                fileNums=[fileNums j];
            end
        end
        cd(here);
        N=length(fileNums);
          if N~=6
              warning(['Verena file load for one-trace-per-file has found ' ...
                  'less than 6 files.. only found %d'],N)
          end
%   Loop here over FileRange
        for j=1:N
            
            filename2=[pathstr '\'...
              sprintf(props.fileTempl,fileNums(j))];
          
            [time, dt, data_i, data_v, cell_name] = ...
              loadVclampAbf(filename2, props);
          
          i_magnitude=props.actualProtocols.cipSteps_nA(j);
            all_data_v=[all_data_v data_v];
            all_data_i=[all_data_i data_i.*i_magnitude./5];
            all_cell_name=[all_cell_name {cell_name}];
%             all_time=[all_time time]; %time is always the same
%             all_dt=[all_dt dt]; %always the same
            
        end
        
        data_i=all_data_i;
        data_v=all_data_v;
        cell_name=props.fileTempl(1:end-4); %ok? ..
        
  else
      
      [time, dt, data_i, data_v, cell_name] = loadVclampAbf(filename, props);
      
  end
 
  if size(data_i, 2) > 1
    if isfield(props, 'ichan')
      data_i = squeeze(data_i(:, props.ichan, :));
    else
      error([ 'Found ' num2str(size(data_i, 2)) ' current channels. Choose ' ...
              'one with "props.ichan".']);
    end
  end
  
  a_vc = voltage_clamp(data_i, data_v, dt * 1e-3, 1e-9, 1e-3, [cell_name sup_id], props);

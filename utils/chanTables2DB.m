function a_db = chanTables2DB(tables, id, props)

% chanTables2DB - Creates a DB with channel tables exported from Genesis.
%
% Usage: 
% a_db = chanTables2DB(tables, id, props)
%
% Description:
%
%   Parameters:
%	tables: Structures returned from the dump files generated by dump_chans.g.
%	id: String that identify the source of the tables structure.
%	props: A structure with any optional properties.
%	  (rest passed to tests_db.)
%
%   Returns:
%	a_db: A tests_db object containing channel tables.
%
% See also: trace, trace/plot, plot_abstract, GP/common/dump_chans.g (Genesis)
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/03/07

if ~ exist('props')
  props = struct;
end

chan_names = fieldnames(tables);
a_db = tests_db;

chan_num = 1;
% go thru all channels in tables
for chan_name = chan_names'
  chan_name = chan_name{1};

  chan = tables.(chan_name)
  chan_fields = fieldnames(chan)';
  gate_names = chan_fields(~cellfun(@isempty, regexp(chan_fields, '.*_minf|.*_tau', 'match')))
  
  %   create DB object
  chan_db = makeChanDB;

  % concat DBs
  a_db = addColumns(a_db, chan_db);

  %   separate plot for each gate
    chan_num = chan_num + 1;
end

% set the props at the end
a_db.props = props;

% inner function: return all gates of one channel in a tests_db object
function a_db = makeChanDB
  results = repmat(NaN, size(chan.(gate_names{1}), 1), length(gate_names) + 1);

  %# the x-axis is always the same
  a_result = chan.(gate_names{1});
  results(:, 1) = a_result(:, 1);

  gate_num = 2;
  for gate_name = gate_names
    gate_name = gate_name{1};

    a_result = chan.(gate_name);

    results(:, gate_num) = a_result(:, 2);

    new_gate_names{gate_num - 1} = [ chan_name '_' gate_name ];
    
    gate_num = gate_num + 1;
  end

  % create the chan DB
  a_db = tests_db(results, { [ chan_name '_x' ], new_gate_names{:} }, {}, ...
                  [ id ', ' chan_name ]);

  % other fields (such as Gbar and powers) go to props (assuming they are scalars)
  other_fields = setdiff(chan_fields, gate_names)
  for field_name = other_fields
    field_name
    props.([chan_name '_' field_name{1}]) = chan.(field_name{1});
  end


end

end


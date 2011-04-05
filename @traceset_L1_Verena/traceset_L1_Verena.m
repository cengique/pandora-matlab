function a_tset = traceset_L1_Verena(traces_cell, protocols, neuron_id, props)

% R:\Logy\fred-workingDir\@traceset_L1_Verena

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if nargin == 0 % Called with no params
  a_tset.protocols = struct;
  a_tset.neuron_id = '';
  a_tset = class(a_tset, 'traceset_L1_Verena', params_tests_dataset);
elseif isa(traces_cell, 'traceset_L1_Verena') % copy constructor?
  a_tset = traces_cell;
else
  a_tset.protocols = protocols;
  a_tset.neuron_id = neuron_id;

  if isnumeric(traces_cell)
    traces_cell = num2cell(traces_cell);
  end
  
  % Create the object 
  a_tset = class(a_tset, 'traceset_L1_Verena', ...
                 params_tests_dataset(traces_cell, [], [], ...
                                      neuron_id, props));
end

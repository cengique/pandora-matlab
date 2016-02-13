function cur_obj = param_I_t(param_init_val, V, a_param_act, a_param_inact, id, props)
  if ~ exist('props', 'var')
    props = struct;
  end

  num_Vs = length(V);
  if size(param_init_val, 1) == 1 && num_Vs > 1
    param_init_val = repmat(param_init_val, num_Vs, 1);
  end
  
  cur_obj = ...
    param_func({'time [ms]', 'current [nA]'}, ...
               [param_init_val, V], {'p', 'q', 'gmax', 'E', 'V'}, ...
               @(p, t) act_inact_cur(a_param_act, a_param_inact, p, t), ...
               id, mergeStructs(props, struct('xMin', 0, 'xMax', 100)));
end

function t_change = find_change(data, idx_start, num_mV, dt)
% find starting baseline
  idx_start = round(idx_start);
  first_ms = 2;
  t_begin = first_ms/dt;
  v_start = mean(data(idx_start:round(idx_start + t_begin)));
  %v_start_sd = std(data(idx_start:round(idx_start + t_begin)));
  
  % find beginning of step (used to be: 5*v_start_sd)
  t_change = find(abs(data(idx_start:end) - v_start) > num_mV); 
  if ~ isempty(t_change)
    % one more -1 to get the previous step before threshold crossing
    t_change = idx_start - 1 + t_change(1) - 1;
  end % else return empty
end



% [traces, ntraces] = loadtraces(file, tracelist, channel, quiet)
% 
% Loads the trace list from the channel out of file.
%
% Parameters:
%	file: PCDX file.
%	tracelist: A string of trace description, such as '1-10'.
%	channel: Channel to read from.
%	quiet: (Optional) If 1, produce on print outs.
% 
% NOTE: You will need the readpcdx plug-in and the 
%       tracelist2 script (@Confucius:/Lab/matlab/alfonso)
%       
% Author: <adelgado@biology.emory.edu>
%
% Modified by: Cengiz Gunay <cgunay@emory.edu>, 2005/01/27
%		to remove the pop-up window and print out a countdown instead.

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

function [traces, ntraces] = ...
      loadtraces(file, tracelist, channel, quiet)

  if ~ exist('quiet', 'var')
    quiet = 0;
  end
  
  if ischar(tracelist)
    [tracenums, ntraces] = gettracelist2(tracelist);
  else
    tracenums = tracelist;
    ntraces = length(tracenums);
  end
  
  if quiet == 0
    print(java.lang.System.out, 'loadtraces, counting down: ');
  end
  
  for i = 1: ntraces
    trace = readpcdx(file, tracenums(i), channel);
    traces(1: length(trace), i) = trace;

    if quiet == 0
      print(java.lang.System.out, [ num2str(ntraces - i) ', ' ]);
      
      if mod(i, 20) == 0
	disp(' ');
      end
    end
    
  end

  if quiet == 0
    println(java.lang.System.out, 'done.');
  end
  
    

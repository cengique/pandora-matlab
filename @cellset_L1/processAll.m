function tex_file = processAll(cellset, procs, props)

% processAll - Runs multiple processes and write a top-level LaTeX report file.
%
% Usage:
% tex_file = processAll(cellset, props)
%
% Parameters:
%   cellset: A cellset object.
%   procs: Cell array of names of cellset_L1 methods to process (e.g.,
%   	   'processCapEst'). If empty, all processes are run.
%   props: Structure with optional parameters.
%
% Returns:
%   tex_file: Name of TeX file generated ([cellset.id '.tex']).
%
% Description:
%
% See also: cellset_L1
%
% $Id: processAll.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/19

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = mergeStructs(defaultValue('props', struct), get(cellset, 'props'));

cellset_id = get(cellset, 'id');
doc_dir = getFieldDefault(props, 'docDir', '');

% save curdir and change to analdir
% $$$ curdir = pwd;
% $$$ cd(analdir);

% => doesn't work?? :(

% $$$ assert(strcmp(pwd, doc_dir), [ 'Must run this in ' analdir ' so that ' ...
% $$$                     'proper subdirectories are created and re-used.']);

all_procs = {'processCapEst', 'subTTXcontrol', 'averageTTXSub'};
procs = defaultValue('procs', all_procs);
num_procs = length(procs);

tex_str = fileread('private/preamble.tex');

for proc_num = 1:num_procs
  switch procs{proc_num}
    case 'processCapEst'
      tex_file = processCapEst(cellset);
      tex_str = ...
          [ tex_str sprintf('\n') '\section{Capacitance estimation}' sprintf('\n')...
            '\renewcommand{\cellsection}{\subsection}' sprintf('\n') ...
            '\input{' properTeXFilename(cellset_id) ...
            '-passive-fits.tex'  '}' ];      
    case 'averageTTXSub'
      tex_file = averageTTXSub(cellset);
      tex_str = ...
          [ tex_str sprintf('\n') '\section{TTX subtraction}' sprintf('\n')...
            '\renewcommand{\protsection}{\subsection}\renewcommand{\cellsection}{\subsubsection}' sprintf('\n') ...
            '\input{' tex_file '}' ];
    case 'averageTracesSave'
      tex_file = averageTracesSave(cellset);
      tex_str = ...
          [ tex_str sprintf('\n') '\section{Averaging}' sprintf('\n')...
            '\renewcommand{\protsection}{\subsection}\renewcommand{\cellsection}{\subsubsection}' sprintf('\n') ...
            '\input{' tex_file '}' ];      
  end
end

tex_str = ...
    [ tex_str sprintf('\n') '\end{document}' ];
tex_file = [ properTeXFilename(cellset_id) '.tex' ];
string2File(tex_str, [ doc_dir filesep tex_file ])

makefile_str = fileread('private/Makefile');

% count '/'s in doc_dir to adjust relative path to eps2pdf
num_slashes = length(strfind(doc_dir, '/'));

eps2pdf_str = ...
    [ 'EPS2PDFM4=' repmat('../', 1, num_slashes) 'common/mkmf-epstopdf.m4' ];

string2File([ eps2pdf_str sprintf('\n') makefile_str], [ doc_dir filesep 'Makefile'])

disp(['Run ''make'' in ' doc_dir ' and then ''pdflatex ' tex_file '''.']);
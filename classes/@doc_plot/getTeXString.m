function tex_string = getTeXString(a_doc, props)

% getTeXString - Returns the TeX representation for the plot document.
%
% Usage:
% tex_string = getTeXString(a_doc, props)
%
% Description:
%   Plots, prints EPS files and generates the necessary LaTeX code.
%
%   Parameters:
%	a_doc: A doc_plot object.
%	props: A structure with any optional properties.
%		
%   Returns:
%	tex_string: A string that contains TeX commands, which upon writing to a file,
%	  can be interpreted by the TeX engine to produce a document.
%
%   Example:
%	doc_plot has an overloaded getTeXString method:
%	>> tex_string = getTeXString(a_doc_plot)
%	>> string2File(tex_string, 'my_doc.tex')
%	then my_doc.tex can be used by including from a valid LaTeX document.
%
% See also: doc_generate, doc_plot
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

fig_num = plot(a_doc);

filename = properTeXFilename(a_doc.plot_filename);

print('-depsc2', [  filename '.eps' ] );

a_doc.float_props.floatType = 'figure';

tex_string = TeXtable([ '\includegraphics{' filename '}' ], a_doc.caption, a_doc.float_props);

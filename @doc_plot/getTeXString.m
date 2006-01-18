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
%	a_doc: A tests_db object.
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/17

fig_num = plotFigure(get(a_doc, 'plot'));

doc_props = get(a_doc, 'props');

if isfield(doc_props, 'orient')
  orient(fig_num, doc_props.orient);
end

filename = properTeXFilename(a_doc.plot_filename);

print('-depsc2', [  filename '.eps' ] );

tex_string = TeXtable([ '\includegraphics{' filename '}' ], a_doc.caption, a_doc.float_props);

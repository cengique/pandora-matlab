function a_doc = doc_plot(a_plot, caption, plot_filename, float_props, id, props)

% doc_plot - Generates a formatted plot for printing, annotated with captions.
%
% Usage:
% a_doc = doc_plot(a_plot, caption, plot_filename, float_props, id, props)
%
% Parameters:
%	a_plot: A plot_abstract ready to be visualized.
%	caption: Long caption to appear under the figure.
%	plot_filename:  Filename to be generated from the plot.
%	float_props: Formatting instructions passed to TeXtable. 
%	id: An identifying string.
%	props: A structure with any optional properties.
%	  orient: Passed to the orient command before printing to figure file.
%		
% Description:
%   The generated file may take an extension according to chosen format.
%
% Returns a structure object with the following fields:
%	plot, caption, plot_filename, float_props, doc_generate.
%
% General operations on doc_plot objects:
%   doc_plot 		- Construct a new doc_plot object.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%	See methods('doc_plot')
%
% Example:
%   >> a_doc = doc_plot(plotData(my_cip_trace), 'My CIP trace. Very interesting.', ...
%                       'trace1', struct, 'first doc');
%   >> printTeXFile(a_doc, 'my_doc.tex'); % it will pop-up the figure now
%
% See also: doc_generate, TeXtable
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/17

if nargin == 0 %# Called with no params
  a_doc.plot = plot_abstract;
  a_doc.caption = '';
  a_doc.plot_filename = '';
  a_doc.float_props = struct([]);
  a_doc = class(a_doc, 'doc_plot', doc_generate);
elseif isa(a_plot, 'doc_plot') %# copy constructor?
  a_doc = a_plot;
else
  if ~ exist('props')
    props = struct([]);
  end

  a_doc.plot = a_plot;
  a_doc.caption = caption;
  a_doc.plot_filename = plot_filename;
  a_doc.float_props = float_props;
  a_doc.id = id;

  a_doc = class(a_doc, 'doc_plot', doc_generate('', id, props));
end


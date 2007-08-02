function a_doc = doc_multi(docs, id, props)

% doc_multi - A document that is composed of multiple other doc_generate objects.
%
% Usage:
% a_doc = doc_multi(docs, id, props)
%
%   Parameters:
%	docs: A vector of doc_generate objects.
%	id: An identifying string.
%	props: A structure with any optional properties.
%		
% Description:
%
% Returns a structure object with the following fields:
%	docs, doc_generate.
%
% General operations on doc_multi objects:
%   doc_multi 		- Construct a new doc_multi object.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%	See methods('doc_multi')
%
% Example:
% >> mydoc = doc_multi([doc_plot(a_plot1), doc_plot(a_plot2)], 'Two plots')
% >> printTeXFile(mydoc, 'two_plots.tex')
%
% See also: doc_generate, getTeXString, doc_generate/printTeXFile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/17

if nargin == 0 %# Called with no params
  a_doc.docs = doc_generate;
  a_doc = class(a_doc, 'doc_multi', doc_generate);
elseif isa(docs, 'doc_multi') %# copy constructor?
  a_doc = docs;
else
  if ~ exist('props')
    props = struct([]);
  end

  a_doc.docs = docs;

  a_doc = class(a_doc, 'doc_multi', doc_generate('', id, props));
end


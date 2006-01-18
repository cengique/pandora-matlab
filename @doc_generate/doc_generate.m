function a_doc = doc_generate(text_string, id, props)

% doc_generate - Generic class to help generate printed or annotated documents with results.
%
% Usage:
% a_doc = doc_generate(text_string, id, props)
%
%   Parameters:
%	text_string: Contents of this document.
%	id: An identifying string.
%	props: A structure with any optional properties.
%		
% Description:
%   This constitutes the base class for other doc_ classes. For convenience,
% this class holds a text_string to be printed when the document is generated
% with the printTeXFile option.
%
% Returns a structure object with the following fields:
%	text, id, props.
%
% General operations on doc_generate objects:
%   doc_generate 	- Construct a new doc_generate object.
%   printTeXFile	- Create TeX file document. (N/I)
%   getTeXString	- Generate the TeX string representing document. 
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%	See methods('doc_generate')
%
% See also: doc_plot, doc_multi
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/17

if nargin == 0 %# Called with no params
  a_doc.text = '';  
  a_doc.id = '';
  a_doc.props = struct([]);
  a_doc = class(a_doc, 'doc_generate');
elseif isa(text_string, 'doc_generate') %# copy constructor?
  a_doc = text_string;
else
  if ~ exist('props')
    props = struct([]);
  end

  a_doc.text = text_string;
  a_doc.id = id;
  a_doc.props = props;

  a_doc = class(a_doc, 'doc_generate');
end


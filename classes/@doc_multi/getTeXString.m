function tex_string = getTeXString(a_doc, props)

% getTeXString - Returns the TeX representation for the document.
%
% Usage:
% tex_string = getTeXString(a_doc, props)
%
% Description:
%   Concatenates TeX representations of doc_generate, or subclass, objects it contains.
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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

num_docs = length(a_doc.docs);

% Concatenate all docs together
tex_string = [];
if ~ iscell(a_doc.docs)
  docs = num2cell(a_doc.docs);
else
  docs = a_doc.docs;
end
for doc_num = 1:num_docs
  tex_string = [tex_string getTeXString(docs{doc_num})];
end

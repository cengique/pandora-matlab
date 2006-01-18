function tex_string = getTeXString(a_doc, props)

% getTeXString - Returns the TeX representation for the document (not implemented).
%
% Usage:
% tex_string = getTeXString(a_doc, props)
%
% Description:
%   This is an abstract placeholder for this method. It specifies what this 
% method should do in the subclasses that implement it. This method should
% create all the auxiliary files needed by the document. The generated tex_string
% should be ready to be visualized.
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

num_docs = length(a_doc.docs);

%# Concatenate all docs together
tex_string = [];
for doc_num = 1:num_docs
  tex_string = [tex_string getTeXString(a_doc.docs{doc_num})];
end

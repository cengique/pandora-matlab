function printTeXFile(a_doc, filename, props)

% printTeXFile - Creates a TeX file with the contents of this document.
%
% Usage:
% printTeXFile(a_doc, filename, props)
%
% Description:
%   Calls getTeXString to generate the contents. The filename is adjusted with 
% a call to properFilename to generate an acceptable TeX filename. TeX-specific
% should only be added at this point or at getTeXString, because before we want
% the object to be a generic document container.
%
%   Parameters:
%	a_doc: A tests_db object.
%	filename: To write the TeX string.
%	props: A structure with any optional properties.
%		
%   Returns:
%	tex_string: A string that contains TeX commands, which upon writing to a file,
%	  can be interpreted by the TeX engine to produce a document.
%
%   Example:
%	>> a_doc = doc_plot(a_plot, 'Results from cell.', 'Results.', struct, ''); 
% 	>> printTeXFile(a_doc, 'my_doc.tex')
%	then my_doc.tex can be used by including from a valid LaTeX document.
%
% See also: doc_generate, doc_plot, string2File, properFilename
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/17

if ~ exist('props')
  props = struct([]);
end

string2File(getTeXString(a_doc, props), properTeXFilename(filename));

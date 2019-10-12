function [varargout] = mgrp2idx(varargin)
%MGRP2IDX Convert multiple grouping variables to index vector
%   [OGROUP,GLABEL,GNAME,MULTIGROUP,MAXGROUP] = MGRP2IDX(GROUP,ROWS,SEP) creates
%   an index vector from the grouping variable or variables in GROUP.  GROUP is
%   a grouping variable (categorical variable, numeric vector, numeric matrix,
%   datetime vector, datetime matrix, duration vector, duration matrix, string
%   matrix, or cell array of strings) or a cell array of grouping variables. 
%   If GROUP is a cell array, all of the grouping variables that it contains 
%   must have the same number of rows.  SEP is a separator for the grouping
%   variable values.
%
%   ROWS is used only to create a grouping var (all ones) in the special case
%   when GROUP is a 1x0 cell array containing no grouping variables (it should be
%   set to the length of the data variable).  It is not used to check lengths of
%   grouping variables against the data variable; the caller should do
%   that.
%
%   The output OGROUP is a vector of group indices.  GLABEL is a cell
%   array of group labels, each label consisting of the values of the
%   various grouping variables separated by the characters in SEP.
%   GNAME is a cell array containing one column per grouping variable
%   and one row for each distinct combination of grouping variable
%   values.  MULTIGROUP is 1 if there are multiple grouping variables
%   or 0 if there are not.  MAXGROUP is the number of groups before any
%   unused categories are omitted.

%   Copyright 1993-2014 The MathWorks, Inc.


[varargout{1:max(1,nargout)}] = internal.stats.mgrp2idx(varargin{:});

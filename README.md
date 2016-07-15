THE PANDORA TOOLBOX
====================

PANDORA is a Matlab Toolbox that: 

- Makes database management accessible from your electrophysiology project; 
- Works offline within Matlab; 
- Requires no external software; 
- Is flexible, can easily tie with existing Matlab scripts; 
- Can query database as in SQL. 

Installation:
--------------------

Use the 'Download ZIP' option to download the latest version from the
Github page. Select 'Set Path' option or use the addpath Matlab
command to add the `classes/` and `functions/` subdirectories to the
Matlab search path. For example:

    addpath <DOWNLOAD DIRECTORY>/classes
    addpath <DOWNLOAD DIRECTORY>/functions

To test the installation try `help tests_db` and `help collectspikes`,
which should give you their help text.

This 2.0 version candidate (2.0candy branch) is transitioning
into a new directory organization that requires also adding these:

    addpath <DOWNLOAD DIRECTORY>/matlab
    addpath <DOWNLOAD DIRECTORY>/matlab/pandora
    addpath <DOWNLOAD DIRECTORY>/matlab/pan_clamp
    addpath <DOWNLOAD DIRECTORY>/matlab/pan_fit

Type `help voltage_clamp` to test the `pan_clamp` module and `help
param_func` to test the `pan_fit` module.

Documentation:
--------------------

See the PDF and HTML manuals under the doc/ directory.

Copyright:
--------------------

Copyright (c) 2007-16 Cengiz Gunay <cengique@users.sf.net>.
This work is licensed under the Academic Free License ("AFL")
v. 3.0. To view a copy of this license, please look at the COPYING
file distributed with this software or visit
http://opensource.org/licenses/afl-3.0.txt.

For more information and to download previous release versions visit:
http://software.incf.org/software/pandora


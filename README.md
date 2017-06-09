<meta charset="UTF-8">

THE PANDORA TOOLBOX
====================

PANDORA is a Matlab Toolbox that: 

- Makes database management accessible from your electrophysiology project; 
- Works offline within Matlab; 
- Requires no external software; 
- Is flexible, can easily tie with existing Matlab scripts; 
- Can query database as in SQL. 

If you use PANDORA, please cite this paper from your software or publications:

**Günay C, Edgerton JR, Li S, Sangrey T, Prinz AA, Jaeger D (2009)** Database analysis of simulated and recorded electrophysiological datasets with Pandora's toolbox. *Neuroinformatics*, 7(2):93-111. doi: 10.1007/s12021-009-9048-z.

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

Tutorials
--------------------

* [Loading intracellular data](doc/tutorials/incf/load-trace.markdown)
  from recordings or simulations to create trace objects.
* [Intracellular spike finding](doc/tutorials/incf/finding-spikes-incf.markdown)
* [Extracting and analyzing firing properties (rate, spike amplitude, etc.)](doc/tutorials/incf/extracting-spike-info.markdown)

Documentation:
--------------------

See the PDF and HTML manuals under the [`doc/`](doc/) directory. They may be
somewhat outdated, but the online help using Matlab's `help` command
will be always up-to-date.

Copyright:
--------------------

Copyright (c) 2007-17 Cengiz Gunay <cengique AT users.sf.net> and
Emory University.  This work is licensed under the Academic Free
License ("AFL") v. 3.0. To view a copy of this license, please look at
the COPYING file distributed with this software or visit
http://opensource.org/licenses/afl-3.0.txt.

Contact:
--------------------

Contact me directly if you have any questions or patches! (cengique AT users.sf.net).

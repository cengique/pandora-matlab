<meta charset="UTF-8">

THE PANDORA TOOLBOX
====================

PANDORA is a Matlab Toolbox that: 

- Makes database management accessible from your electrophysiology project; 
- Works offline within Matlab; 
- Requires no external software; 
- Is flexible, can easily tie with existing Matlab scripts; 
- Can query database as in SQL. 

If you use PANDORA, please cite these from your software or publications:

- **Günay C, Edgerton JR, Li S, Sangrey T, Prinz AA, Jaeger D (2009)** Database analysis of simulated and recorded electrophysiological datasets with Pandora's toolbox. *Neuroinformatics*, 7(2):93-111. doi: 10.1007/s12021-009-9048-z. ([PDF](doc/neuroinf-published-online-2009-06-02.pdf))
- [RRID: SCR_001831](https://scicrunch.org/resources/about/registry/SCR_001831)
- [Pandora page in SimToolDB](https://senselab.med.yale.edu/simtooldb/ShowTool.asp?Tool=112112)

[![View cengique/pandora-matlab on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/60237-cengique-pandora-matlab)


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
* [Tabular database analysis](doc/tutorials/incf/database-analysis.md)
* [Creating a database from files](doc/tutorials/incf/database_from_dataset_tutorial.md)

Documentation:
--------------------

See the [PDF](doc/prog-manual.pdf) manual under the [`doc/`](doc/) directory. It may be
somewhat outdated, but the online help using Matlab's `help` command
will be always up-to-date.

Other resources:
--------------------

- [CNS*2014 Neuronal Parameter Search Techniques tutorial](https://sites.google.com/site/neuroparamsearchtut/) files and information
- [Parallel parameter search scripts for neuron models](https://github.com/cengique/param-search-neuro) intended for high-performance computing clusters

Related projects:
--------------------

* [PyPet python parameter exploration toolkit](http://pypet.readthedocs.org/en/latest/) for data storage and simulation management
* [FIND Toolbox](http://find.bccn.uni-freiburg.de) by Ralph Meier (meier AT biologie.uni-freiburg.de)
* [SPIKY Toolbox](https://arxiv.org/abs/1410.6910) by Thomas Kreuz (thomas.kreuz AT cnr.it)

Copyright:
--------------------

Copyright (c) 2007-17 Cengiz Gunay <cengique AT users.sf.net> and
Emory University.  This work is licensed under the Academic Free
License ("AFL") v. 3.0. To view a copy of this license, please look at
the COPYING file distributed with this software or visit
http://opensource.org/licenses/afl-3.0.txt.

Contact:
--------------------

Open new issues on GitHub or contact me at this address! (cengique AT users.sf.net).

Acknowledgments:
--------------------

See the [CREDITS](CREDITS).

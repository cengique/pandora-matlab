Exporting to PDF and HTML
====================

Run this to update the function reference information directly 
from Matlab code in the current directory (ignore the pages of debug printouts):

    `./oom2tex.pl > func-ref.tex`

Then Generate a postscript output from Lyx using the new
function reference and check that it's ok. 

After that, go to the new directory created by Lyx. This
varies for different Operating Systems:

## Windows:
```C:\Users\<Your PC Name>\AppData\Local\Temp\lyx_tmpdir*\lyx_tmpbuf0```

## Linux:
`/tmp/lyxtmpdir*`


In this directory do the following steps:

1) to get the function index do:
makeindex prog-manual.frx -o prog-manual.fnd


2) to create the HTML help run the following command after replacing the output HTML directory:

```latex2html -t 'PANDORA Toolbox Manual' -dir ~/work/pandora-all/pandora/trunk/doc/html -mkdir -split +1 -show_section_numbers -no_reuse -local_icons prog-manual.tex```

3) Also need to update the PDF file after generating the function
index. LyX will fail to generate a PDF complaining about missing
\item's. Manually run pdflatex in the tmp directory above. Then run:

`bibtex prog-manual.aux` 

and then rerun pdflatex. Then run the makeindex program and run
pdflatex at least three times. Open the PDF and make sure that the
References, Function reference and Function Index sections contain
correct page numbers and references.

4) copy the PDF from tmp to doc/ directory.

Cengiz Gunay
<cengique@users.sf.net>
2007/08/09

#! /usr/bin/perl -w

# Utility to scan all matlab classes and utilities to generate manual pages
# in LaTeX format with cross references and indices, which can then be converted to HTML.

use strict;
use Text::Tabs;

# scan algorithm:
# - go one dir above
# - find class dirs
# - scan utils dir
# - for each class dir:
#   - put class section title, ref label, index entry
#   - read constructor file
#   - read all methods
#   - for each file:
#     - create ref label, index entry
#     - parse usage, description, returns, list of operations and see also line
#     - for each method do similar except list of operations

# TODO:
# - scan class keyword and find base class
# - change algorithm to scan everything first, make symbol table, and then create
#	latex with proper cross-references. Otherwise there's no way of telling
#	if cross-references are correct. Also this way we can sort alphabetically.
# - put list of methods in class section
# - read brief description of class from Contents.m.

my $code_dir = "../classes";
my $utils_dir = "../functions";
my $func_ref_dir = "func_ref";

# escapes characters that latex doesn't like
sub proper_latex_label {
  $_ = shift;

  # first replace existing backslashes
  s/\\/\$\\backslash\$/g;
  # then add new ones
  s/_/\\_/g;
  s/&/\\&/g;
  s/\^/\\textasciicircum{}/g;

  return $_;
}

sub parse_links {
  my $link_text = shift;
  my $class_name = shift;
  my $latex_code = "";
  my $first = 1;

  # remove preceding and trailing spaces
  $link_text =~ s/^\s*//s;
  $link_text =~ s/\s*$//s;

  foreach (split(/\s*,\s*/, $link_text)) {
    my ($link_class_name, $link_method_name, $link_name, $index_line);
    my $orig_link_name = $_;		# Need to save $_ from beginning
    if (m|/|) {
      ($link_class_name, $link_method_name) = split m|/|;
      $link_name = "$link_class_name" . "__$link_method_name";
      $index_line = "\\index[funcref]{$link_class_name" .
	"@\\fidxl{" . proper_latex_label($link_class_name) . 
	  "}!$link_method_name@\\fidxl{" . proper_latex_label($link_method_name) . "}}";
    } else {
      # convert slashes to underscores
      #s|/|__|;
      $link_name = $orig_link_name;
      $index_line = "\\index[funcref]{$link_name@\\fidxl{" .
	proper_latex_label($link_name) . "}}";
    }
    # remove escapes from reference names
    my $proper_link_name = proper_latex_label($orig_link_name);
    $latex_code .= (($first == 1)?"":", ");
    $latex_code .= << "ENDL";
\\hyperlink{ref_$link_name}{\\texttt{$proper_link_name}}%
\\ (p.~\\pageref{ref_$link_name})%
$index_line%
ENDL
    $first = 0;
  }

  return $latex_code;
}

sub parse_param_list {
  my $param_text = shift;
  my $latex_code = "";
  my $indent_depth = -1;
  my $nest_level = 0;

  $tabstop = 8;
  $param_text = expand($param_text);		# Expand the tabs

  # remove whitespace before beginning of first line
  $param_text =~ s/(?s:^)\s*^//m;

  print STDERR "list_text: '$param_text'\n";

  # search lines with colons, count spaces before word to estimate indent level
  $param_text =~ s{(?:(^\s*)(\w[\w\s,\\]*):(.*)$)|(^.*$)}{
    if (defined($2)) {
      print STDERR "Found param decl: '$1', '$2', '$3'\n";
      # open new item. if indent is deeper go deeper, otherwise pop up
      my $num_spaces = length($1);
      if ($num_spaces > $indent_depth) { # Deeper
	$indent_depth = $num_spaces; $nest_level++;
	$latex_code .= "\\begin{description}%\n";
      } elsif ($num_spaces < $indent_depth && $nest_level > 1) { # Less deep
	$indent_depth = $num_spaces; $nest_level--;
	$latex_code .= "\\end{description}%\n";
      }
      $latex_code .= "\\item[\\texttt{" . proper_latex_label($2) . 
	"}:]\n" . proper_latex_label($3) . "\n";
    } else {
      my $line = proper_latex_label($4);
      #$line =~ s/^\s*(\S*)\s*$/$1/;
      $line =~ s/^\s*//;
      print STDERR "Found text: '$line'\n";
      # put first into last opened item
      chomp($latex_code .= "\n". $line . "\n");
    }
  }omxeg;
  # close remaining indents
  for (; $nest_level > 0; $nest_level--) {
    $latex_code .= "\\end{description}%\n";
  }

  return $latex_code;
}

sub process_method {
  my $filename = shift;
  my $class_name = shift;
  my $label = shift;

  $filename =~ m|^.*/([^.]+)\.m|;

  my $method_name = $1;

  my $contents = `cat $filename` || die "Cannot read method file $filename: $!";

  # Global replace
  #$contents =~ s/_/\\_/g;

  # Remove space before function line
  $contents =~ s/^\s*(function)/$1/ms ||
    die "Cannot find function keyword in file $filename.";

  # Extract function line and trailing spaces
  $contents =~ s/(function.*$)[^%]*%/%/m;

  my $func_def = $1;
  print STDERR "definition of $method_name with line:\n$func_def\n";

  $contents =~ /((?:%.*$(?:)\n)+)/m || die "cannot find comment block in $filename.";
  my $comments = $1;

  # strip comment characters
  $comments =~ s/^\s*%//mg;

  #print "Comment block:\n$comments\n";

  # separate into sections: brief summary, usage, description, parameters, returns.., operations, see also
  #$comments =~ m/($method_name.*)(Usage:.*)(Description:.*)(Parameters:.*)(^\s*return.*)(^\s*see also: .*)(\$Id$)(Author:.*)/msi || die "cannot parse comment block '$comments'\n";
  my @comment_sections = split /^\s*$/m, $comments;
  my %comment;

  foreach (@comment_sections) {
    print STDERR "BLOCK: '$_'\n";
    if (/^\s*$method_name\s*-\s*(.*)\s*$/s) {
      $comment{"summary"} = "\\item[Summary:]" .
	proper_latex_label($1);
    } elsif (/^\s*Usage:\s*(.*)\s*$/s) {
      $_ = proper_latex_label($1);
      $comment{"usage"} = << "ENDL";
\\item[Usage:]~%
\\begin{lyxcode}%
$_%
\\end{lyxcode}%
ENDL
    } elsif (/^\s*Description:\s*(?=\S)(.*)\s*$/is) {
      $_ = proper_latex_label($1);
      $comment{"description"} = "\\item[Description:]%\n$_%";
    }  elsif (/^\s*Parameters?:(.*)$/is) {
      $_ = parse_param_list($1);
      $comment{"params"} = "\\item[Parameters:]~\n$_";
    } elsif (/^\s*Example:\s*(?m:^)(.*)$/is) {
      my $example_text = expand(proper_latex_label($1));
      $example_text =~ s/\n/\\\\%\n/g;
      $comment{"example"} = "\\item[Example:]~\n\\begin{lyxcode}" . $example_text . "\\end{lyxcode}\n";
    } elsif (/^\s*(?m-s)(return.*)$\s*(?s-m)(.*)\s*$/is) {
      $comment{"returns"} = "\\item[" . proper_latex_label($1) . "]~\n" .
	proper_latex_label($2);
    } elsif (/^\s*see also:(.*)$/si) {
      $comment{"links"} = "\\item[See also:]%\n" . parse_links($1, $class_name);
    } elsif (/^\s*author:\s*(.*)\s*$/mi) {
      $comment{"author"} = "\\item[Author:]%\n" . proper_latex_label($1);
    }
  }

  my $flabel = ucfirst($label);
  my $proper_method_name = proper_latex_label($method_name);
  my $proper_class_name = proper_latex_label($class_name);

  my $latex_code = << "ENDL";
\\subsubsection[$flabel \\texttt{$proper_method_name}]{$flabel \\texttt{$proper_class_name/$proper_method_name}}%
\\index[funcref]{$class_name@\\fidxl{$proper_class_name}!$method_name@\\fidxl{$proper_method_name}}%
\\label{ref_${class_name}__$method_name}%
\\hypertarget{ref_${class_name}__$method_name}{}%
\\begin{description}
$comment{"summary"}%
$comment{"usage"}%
$comment{"description"}%
$comment{"params"}%
$comment{"returns"}%
$comment{"example"}%
$comment{"links"}%
$comment{"author"}%
\\end{description}
\\methodline%
ENDL

  #print STDERR "$latex_code";

  # Breakpoint during testing
  #exit -1;

  return $latex_code;
}

sub process_methods_dir {
  my $methods_dir = shift;
  my $dir_label = shift;
  my $method_label = shift;
  my $latex_code = "";

  # Do other methods
  opendir(CDIR, $methods_dir) || die "can't opendir $code_dir";

  my @method_files = grep { /\.m$/ } readdir(CDIR);

  # do not include the constructor a second time if doing a class dir
  @method_files = grep { ! /$dir_label.m/ } @method_files 
    if $method_label == "method";

  foreach (@method_files) {
    $latex_code .= process_method("$methods_dir/$_", $dir_label, $method_label);
  }

  return $latex_code;
}

sub process_class_dir {
  my $class_dir = shift;
  my $latex_code = "";

  my $class_name = $class_dir;
  #$class_name =~ s|^.*/\@([^/]*)$/|$1|;
  $class_name =~ s|^.*/\@||;

  print STDERR "class: $class_name\n";

  my $proper_class_name = proper_latex_label($class_name);

  my $constructor_file = "$class_dir/${class_name}.m";
  if ( -r $constructor_file ) {
    # put hyperref target
    $latex_code = << "ENDL";
\\subsection{Class \\texttt{$proper_class_name}}%
\\index[funcref]{$class_name@\\fidxl{$proper_class_name}|boldhyperpage}%
\\label{ref_$class_name}%
\\hypertarget{ref_$class_name}{}%
ENDL

    $latex_code .= process_method($constructor_file, $class_name, "constructor");
  } else {
    print STDERR "Missing constructor $constructor_file.\n";
  }

  # Process all other methods in dir
  $latex_code .= process_methods_dir($class_dir, $class_name, "method");

  return $latex_code;
}


my $latex_code = << "ENDL";
\\newcommand{\\fidxl}[1]{{\\small \\texttt{#1}}}
\\newcommand{\\fidxlb}[1]{{\\small \\bf \\texttt{#1}}}
\\newcommand{\\boldhyperpage}[1]{\\textbf{\\hyperpage{#1}}}
\\newcommand{\\methodline}{%
  {\\normalsize \\vspace{1ex} \\hrule width \\columnwidth \\vspace{1ex}}%
}%
ENDL

opendir(DIR, $code_dir) || die "can't opendir $code_dir";

my @all_files = readdir(DIR);

my @class_dirs = grep { /^\@/ } @all_files;

my $class_dir;
foreach $class_dir (sort @class_dirs) {
  $latex_code .= process_class_dir("$code_dir/$class_dir");
}

# Process utils dir
$latex_code .= << "ENDL";
\\subsection{Utility functions}%
\\label{ref_utils}%
\\hypertarget{ref_utils}{}%
ENDL
$latex_code .= process_methods_dir("$utils_dir", "functions", "function");

# Send created LaTeX contents to standard output
print "$latex_code\n";


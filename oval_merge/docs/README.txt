------------------------
OVAL Merge Utility 5.10.1
------------------------

This utility will take one or more files that contain valid OVAL content and combine
them into a single, valid OVAL file that contains the union of all of the definitions,
tests, objects, states, and variables found in the individual OVAL files.

NOTE:  This code is built against a specific version of the OVAL Language (reflected in
the title above and the utility's version).  There is not anything special about the code
itself, but the XMLBeans library that is used *is* built against a specific version of the
Language.  It is possible that the code will correctly merge other versions, but cannot be
guaranteed. 

In all cases the input files will not be altered.

Following are some additional items worth mentioning about this utility:
 * Java 1.6 command line utility
 * Command line flag to designate the input directory from which to pull the OVAL files to merge.
 * Optional command line flag to designate the output directory for the results file
 * Optional command line flag to designate the output filename for the results file
 * Freely available utility on the "ovalutils" sourceforge site: http://sourceforge.net/projects/ovalutils/
 * The tool assumes that there are not conflicting edits in the files.  That is, if
there is a file with an edit to def:1000, and it is combined with another file that also
has a different edit to def:1000, it will overwrite one of the edits and lose the other.  

Example command line output with no arguments specified:
\>java -jar dist/OvalMerge.jar
OVAL Document Merge Utility
Usage: > [options]

Options:
        -i <directory> This specifies the directory from which to grab OVAL files for merging.
        -f <filename> This specifies the name of the results file (optional).
        -o <directory> This specifies the directory name to save results (optional).
        -v Prints out the tool version.
        -h Usage


-- REPORTING PROBLEMS --

To report a problem with the OVAL Merge Utility, please post a bug report on the
OVAL Merge Utility SourceForge site (http://sourceforge.net/projects/ovalutils/).

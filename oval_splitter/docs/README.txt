------------------------
OVAL Splitter
------------------------

This utility will take an xml file that contains one or more definitions as a command line input and splits the input document in one of two ways:
 - If the user provides an id of an item the utility will create a new oval definition document that contains only the single item with the input id and anything it depends on. In this mode of operation the user may supply the id of a definition, test, object, state, or variable and any of those will be split into its own new valid document. 
 - If the user indicates on the command line that the input document should be fully split at a specified level (definitions, test, object, state, variable) the utility will create a new xml file for each item at the designated level. For example, if the input document has 5 definitions and the user indicates that the document should be split at the definition level the utility will create a new xml file for each definition in the input document.

In all cases the input document will not be altered. Following are some additional items worth mentioning about this utility:
 * java 1.6 command line utility
 * tied to specific versions of OVAL (different utility for each version of the oval language)
 * command line flag to designate the input oval-definition document to split.
 * optional command line flag to designate the output directory for all split items
 * optional command line flag to designate the id of a single item to extract from the input file
 * optional command line flag to designate the level at which to split the input document (definition, test, object, state, variable)
 * freely available utility on the "ovalutils" sourceforge site: http://sourceforge.net/projects/ovalutils/


Example commandline output with no arguments specified:
\>java -jar dist/Oval_Splitter.jar
OVAL Document Splitter
Usage: > [options] 

Options:
        -m [item|split]	This specifies the mode on whether to extract a single item from or split the document.
        -f <filename> This specifies the OVAL document to import.
        -o <direcotry> This specifies the directory name to save results (optional).
        -id <ovalid> This specifies the oval id of the item to extract (required when -m=item).
        -l [definitions|tests|objects|states|variables] This specifies how to split the document. (required when -m=split)
        -h usage


-- REPORTING PROBLEMS --

To report a problem with the OVAL Splitter, please post a bug report on the OVAL Splitter SourceForge site (http://sourceforge.net/projects/ovalutils/).


-- USEFUL LINKS --

XCCDF Web site -- http://nvd.nist.gov/xccdf.cfm

OVAL Web site -- http://oval.mitre.org/

OVAL Interpreter SourceForge Site -- http://sourceforge.net/projects/ovaldi/

OVAL Utilities SourceForge Site -- http://sourceforge.net/projects/ovalutils/

OVAL Repository -- http://oval.mitre.org/repository/

Terms of Use -- http://oval.mitre.org/about/bsd_license.html

CCE -- http://cpe.mitre.org/

CPE -- http://cce.mitre.org/

CWE -- http://cwe.mitre.org/

CVE -- http://cve.mitre.org/

Making Security Measurable - http://msm.mitre.org/

----------------------------------------------------------
OVAL is sponsored by US-CERT at the U.S. Department of Homeland Security. OVAL and the OVAL logo are trademarks of The MITRE Corporation. Copyright 2012, The MITRE Corporation (www.mitre.org).
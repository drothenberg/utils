----------------------------		
XCCDF Splitter
----------------------------
The XCCDF Splitter will take as input a complete SCAP Benchmark, like the FDCC for Windows XP, and allow the user to create a new benchmark that contains only one user selected Rule and all related material. This will allow a user to easily create a new benchmark to check for a single rule in an existing SCAP Benchmark for evaluation with an SCAP Validated Compliance Scanner.

This utility will take as input the XCCDF document portion of an SCAP Benchmark and the id of the user's desired rule. The utility will then output to a new directory a pared down xccdf document that contains only the user's selected rule and the minimal required set of oval definitions. 

Example commandline output with no arguments specified:
\>java -jar dist/Splitter.jar
XCCDF Document Splitter
Usage: > [options]

Options:
        -i XCCDF Document to import
        -r rule id to extract
        -ox output xccdf file (optional)
        -oo output oval file (optional)
        -h usage


-- REPORTING PROBLEMS --

To report a problem with the XCCDF Splitter, please post a bug report
on the XCCDF Splitter SourceForge site 
(https://sourceforge.net/projects/ovalutils/).


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
OVAL is sponsored by US-CERT at the U.S. Department of Homeland
Security. OVAL and the OVAL logo are trademarks of The MITRE
Corporation. Copyright 2012, The MITRE Corporation (www.mitre.org).

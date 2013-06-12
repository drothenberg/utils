   	

****************************************************

                  OVAL Normalizer

 Copyright (c) 2012 - The MITRE Corporation

****************************************************


The MITRE Corporation developed the Open Vulnerability and Assessment
Language (OVAL) Normalizer to provide the OVAL Community with an open
source utility that may help in working with and managin OVAL Definitions.

The OVAL Normalizer is a commandline utility that will take an xml file 
that contains one or more OVAL Definitions input and validate the document
against the OVAL Definitions Schema and the OVAL Definitions Schema Schematron
rules. Then if the input document is valid the utility will normalize the 
input xml file and output to a user specified xml file.

During the normailization process unused xml namespaces will be removed, 
attempt is made to clean up comments on all items, simplify the usage of xml 
namespaces, and remove optional attributes. This normalization process is 
intended to make the input definition more easily readable and give users some
consistency in the format of the oval definitions they work with. Following are
some additional items worth mentioning about this utility:

 * Requires Java 1.6
 * Tied to specific versions of OVAL (different utility for each version of the oval language)
 * command line flag to designate the input oval-definition document to validate.
 * optional command line flag to skip Schematron validation
 * optional command line flag for normalized output file. If the flag is not provided the document will not be normalized.
 * Updates are freely available utility on the "ovalutils" sourceforge site: https://sourceforge.net/projects/ovalutils/

You may download the Normalizer to any computer you wish, and to as
many computers as you wish.  

BY USING THE OVAL NORMALIZER, YOU SIGNIFY YOUR ACCEPTANCE OF THE TERMS AND
CONDITIONS OF USE.  IF YOU DO NOT AGREE TO THESE TERMS, DO NOT USE THE 
NORMALIZER.

Please refer to the terms.txt file for more information.


-- USING THE OVAL NORMALIZER --
Example commandline output with no arguments specified:
\>java -jar ovalNormalizer.jar
OVAL Document Normalizer:  Cleans Up OVAL Documents
Usage: > [options]

Options:
        -i Xml file to import
        -o output file (optional)
        -s skip schematron validation (optional)
        -h usage


-- REPORTING PROBLEMS --

To report a problem with the OVAL Normalizer, please post a bug report
on the OVAL Normalizer SourceForge site 
(https://sourceforge.net/projects/ovalutils/).


-- USEFUL LINKS --

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

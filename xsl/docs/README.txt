------------------------
OVAL XSL Utilities
------------------------

The OVAL XSL Utilities is a set of independent transformations that will perform specific functions upon an OVAL or XCCDF file. These include commonly performed operations for handling subsets of data, or to change the way the user interacts with the content. All may be called in a similar fashion with varying input parameters. The list of parameters are as follows:

extract.definition.by.rule.id.xsl:
	-desiredRuleId		(required)

extract.oval.item.by.id.xsl:
	-paramOvalId		(not required, but nothing extracted)
	-paramSplitLevel	(not required)
	-paramOutputDir		(not required)

extract.scap.oval.xsl:
	-(None)

extract.xccdf.rule.by.id.xsl:
	-desiredRuleId		(required)

oval-definitions-schematron.xsl:
	-(None)

oval-results-schematron.xsl:
	-(None)

oval-system-characteristics-schematron.xsl:
	-(None)

results_to_html.xsl:
	-(None)

sort-oval.xsl:
	-sortIdURI			(not required, default of ascending)
	-sortIdNum			(not required, default of ascending)

view.oval.content.xsl:
	-(None)

To call, use the following syntax:

	java -jar lib/saxon9.jar -s:[inputoval.xml] 
		-xsl:[inputtransform.xsl] param1=value1 param2=value2


-- REPORTING PROBLEMS --

To report a problem with the OVAL XSL Utilities, please post a bug report on the OVAL XSL Utilities SourceForge site (http://sourceforge.net/projects/ovalutils/).


-- USEFUL LINKS --

OVAL Web site -- http://oval.mitre.org/

OVAL Interpreter SourceForge Site -- http://sourceforge.net/projects/ovaldi/

OVAL Utilities SourceForge Site -- http://sourceforge.net/projects/ovalutils/

OVAL Repository -- http://oval.mitre.org/repository/

CCE -- http://cpe.mitre.org/

CPE -- http://cce.mitre.org/

CWE -- http://cwe.mitre.org/

CVE -- http://cve.mitre.org/

Making Security Measurable - http://msm.mitre.org/

----------------------------------------------------------
OVAL is sponsored by US-CERT at the U.S. Department of Homeland Security. OVAL and the OVAL logo are trademarks of The MITRE Corporation. Copyright 2012, The MITRE Corporation (www.mitre.org).
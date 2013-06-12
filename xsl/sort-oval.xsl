<?xml version="1.0" encoding="UTF-8"?>
<!--
    License Agreement
    
    Copyright (C) 2012. The MITRE Corporation (http://www.mitre.org/). All Rights Reserved.
    
    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
    
    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    
    * The US Government will not be charged any license fee and/or royalties related to this software.
    
    * Neither name of The MITRE Corporation; nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
    
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    `AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
    A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
    HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
    OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
    TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
    USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.    
-->

<!DOCTYPE stylesheet [
<!ENTITY cr "<xsl:text>
</xsl:text>">
<!ENTITY space "<xsl:text> </xsl:text>">
]>

<!--
    Author: Tim Harrison
    Date: 5/20/2011
    
    NOTE:
    
    For readability separators are included.  If additional readbility is a concern use an XML Editor to format the output.
	To reduce size comment out the lines which generate the separator and change the @indent value from 'yes' to 'no'.
    
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:oval="http://oval.mitre.org/XMLSchema/oval-common-5"
    xmlns:oval-def="http://oval.mitre.org/XMLSchema/oval-definitions-5"
    xmlns:foo="myFunctions" version="2.0">
    
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    
    <!--
         Parameters to specify sort method for URI and numeric id, respectively, of the id attribute.
         Allowed values are: 
                                ascending
                                descending
    -->
    <xsl:param name="sortIdURI">ascending</xsl:param>
    <xsl:param name="sortIdNum">ascending</xsl:param>
    
    
    <xsl:template match="oval-def:oval_definitions">
        <xsl:element name="oval_definitions" xmlns="http://oval.mitre.org/XMLSchema/oval-definitions-5">
            <xsl:copy-of select="root()/child::node()/namespace::node()"/>
            <xsl:copy-of select="root()/child::node()/@xsi:schemaLocation"/>
            <xsl:apply-templates select="current()/child::node()"/>
             <!-- Generate the end separator -->
            <xsl:copy-of select="foo:genSeparator('NoText')"/>
        </xsl:element>
    </xsl:template>

	<xsl:template match="oval-def:generator">
		<xsl:element name="generator" namespace="http://oval.mitre.org/XMLSchema/oval-definitions-5" inherit-namespaces="yes">
			<xsl:element name="oval:product_name">
				<xsl:value-of select="current()/oval:product_name"/>
			</xsl:element>
			<xsl:element name="oval:schema_version">
				<xsl:value-of select="current()/oval:schema_version"/>
			</xsl:element>
			<xsl:element name="oval:timestamp">
				<xsl:value-of select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01].[f001][Z01]')"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="node()[name()='definitions' or name()='tests' or name()='objects' or name()='states' or name()='variables']">
	<!-- If any child nodes exist for the current node then generate the section.
		 Otherwise don't generate the section -->
		<xsl:if test="exists(current()/child::node())">
			<!-- Generate the appropriate separator -->
			<xsl:copy-of select="foo:genSeparator(concat(' ', upper-case(current()/name())))"/>
			<!-- Output the current oval-def:oval_definitions child element and descendant nodes. -->
			<xsl:element name="{current()/name()}" namespace="http://oval.mitre.org/XMLSchema/oval-definitions-5" inherit-namespaces="yes">
				<!-- Sort the descendant nodes according to the sort parameters -->
				<xsl:perform-sort select="current()/child::node()">
					<xsl:sort select="tokenize(@id, ':')[2]" order="{$sortIdURI}"/>
					<xsl:sort select="xs:integer(tokenize(@id,':')[4])" order="{$sortIdNum}"/>
				</xsl:perform-sort>
			</xsl:element>
		</xsl:if>	
	</xsl:template>
   
    <xsl:function name="foo:genSeparator">
        <xsl:param name="sepText"/>
        <xsl:variable name="sepLine">
            <xsl:text> ==================================================================================================== </xsl:text>
        </xsl:variable>
        <!-- determine the location to insert the section text. -->
        <xsl:variable name="insertLoc" select="(string-length($sepLine) idiv 2) - round(string-length($sepText) idiv 2)" as="xs:double"/> &cr; <xsl:comment><xsl:value-of select="$sepLine"/></xsl:comment>&cr; <xsl:comment>
		<xsl:choose>
			<xsl:when test="$sepText='NoText'">
				<xsl:value-of select="$sepLine"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(substring($sepLine,0,$insertLoc),$sepText, substring($sepLine,0,$insertLoc))"/>
				<xsl:if test="not(string-length($sepText) mod 2 = 1)">
					<xsl:text>=</xsl:text>
				</xsl:if> &space; </xsl:otherwise>
		</xsl:choose>
        </xsl:comment>&cr;
        <xsl:comment><xsl:value-of select="$sepLine"/></xsl:comment>&cr;
    </xsl:function>
        
</xsl:stylesheet>

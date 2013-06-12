<?xml version="1.0" encoding="UTF-8"?>
<!--
	
	****************************************************************************************
	Copyright (c) 2002-2012, The MITRE Corporation
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without modification, are
	permitted provided that the following conditions are met:
	
	* Redistributions of source code must retain the above copyright notice, this list
	of conditions and the following disclaimer.
	* Redistributions in binary form must reproduce the above copyright notice, this 
	list of conditions and the following disclaimer in the documentation and/or other
	materials provided with the distribution.
	* Neither the name of The MITRE Corporation nor the names of its contributors may be
	used to endorse or promote products derived from this software without specific 
	prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
	OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
	SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
	SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
	OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
	HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
	TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
	EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	
	****************************************************************************************
	
	The extract.scap.oval stylesheet is designed to copy all OVAL, XCCDF, OCIL, and CPE scap components into their 
	respectively named files from an SCAP data stream. Furthermore, an OVAL external variables file is output
	for each XCCDF profile found. XSLT version 2.0 is required due to the multiple outputs.
	
	-->
<xsl:stylesheet version="2.0"
		    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		    xmlns:cat="urn:oasis:names:tc:entity:xmlns:xml:catalog"
		    xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:oval-def="http://oval.mitre.org/XMLSchema/oval-definitions-5"
            xmlns:scap="http://scap.nist.gov/schema/scap/source/1.2"
            xmlns:xccdf="http://checklists.nist.gov/xccdf/1.2"
            xmlns:ocil="http://scap.nist.gov/schema/ocil/2.0"
            xmlns:cpe="http://cpe.mitre.org/dictionary/2.0" >

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="/scap:data-stream-collection">
		<xsl:variable name="catalog_find" select="//cat:catalog/cat:uri"/>
		<xsl:variable name="catalog_replace" select="//scap:checks/scap:component-ref"/>
		<xsl:for-each select="//scap:component[oval-def:oval_definitions|ocil:ocil|cpe:cpe-list]">
			<xsl:call-template name="ExtractDocs">
				<xsl:with-param name="catalog_find" select="$catalog_find"/>
				<xsl:with-param name="catalog_replace" select="$catalog_replace"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="//scap:component[xccdf:Benchmark]">
			<xsl:call-template name="TraverseXCCDFProfiles">
				<xsl:with-param name="catalog_find" select="$catalog_find"/>
				<xsl:with-param name="catalog_replace" select="$catalog_replace"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<!-- copy each OVAL,OCIL, and CPE document into a separate file-->
	<xsl:template name="ExtractDocs">
		<xsl:param name="catalog_find"/>
		<xsl:param name="catalog_replace"/>
		<xsl:variable name="ComponentFileName" select="./@id"/>
		<xsl:result-document href="{$ComponentFileName}">
			<xsl:apply-templates mode="replace">
				<xsl:with-param name="catalog_find" select="$catalog_find"/>
				<xsl:with-param name="catalog_replace" select="$catalog_replace"/>
			</xsl:apply-templates>
		</xsl:result-document>
	</xsl:template>
	
	<!-- copy nodes and attributes that do not require refinement -->
	
	<xsl:template match="@*|node()" mode="replace">
		<xsl:param name="catalog_find"/>
		<xsl:param name="catalog_replace"/>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="replace">
				<xsl:with-param name="catalog_find" select="$catalog_find"/>
				<xsl:with-param name="catalog_replace" select="$catalog_replace"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<!-- replace catalog entries found in href attributes with their respective filenames -->
	
	<xsl:template match="@href" mode="replace">
		<xsl:param name="catalog_find"/>
		<xsl:param name="catalog_replace"/>
		<xsl:attribute name="href">
			<xsl:variable name="currentval" select="."/>
			<xsl:choose>
				<xsl:when test="$catalog_find[@name = $currentval]">
					<xsl:value-of select="replace($catalog_replace[@id=replace($catalog_find[@name = $currentval]/@uri,'#','')]/@xlink:href,'#','')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>	
	
	<!-- iterate over xccdf benchmarks and operate on all profiles, while outputting benchmark to file -->
	<xsl:template name="TraverseXCCDFProfiles">
		<xsl:param name="catalog_find"/>
		<xsl:param name="catalog_replace"/>
		<xsl:variable name="XCCDFFileName" select="./@id"/>
		<xsl:result-document href="{$XCCDFFileName}">
			<xsl:for-each select="./xccdf:Benchmark">
				<xsl:copy>
					<xsl:apply-templates select="@*|node()" mode="replace">
						<xsl:with-param name="catalog_find" select="$catalog_find"/>
						<xsl:with-param name="catalog_replace" select="$catalog_replace"/>
					</xsl:apply-templates>
				</xsl:copy>
			</xsl:for-each>
		</xsl:result-document>
		<xsl:for-each select="./xccdf:Benchmark/xccdf:Profile">
			<xsl:call-template name="ExtractExternalVars">
				<xsl:with-param name="profile_id">
					<xsl:value-of select="./@id"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<!-- for each profile, extract OVAL external variables file -->
	<xsl:template name="ExtractExternalVars" match="/xccdf:Benchmark">
		<xsl:param name="profile_id"/>
		
		<xsl:variable name="minSchemaVersion">
			<xsl:for-each select="/*//scap:component/oval-def:oval_definitions/oval-def:generator/*[local-name()='schema_version']">
				<xsl:sort select="number(substring-after(.,'5.'))" data-type="number" order="ascending"/>
				<!-- take minimum schema version found (first in ascending sort) -->
				<xsl:if test="position() = 1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:result-document href="{concat($profile_id,'_ext_vars.xml')}">
			<xsl:element name="oval_variables" namespace="http://oval.mitre.org/XMLSchema/oval-variables-5">
				<xsl:attribute name="xsi:schemaLocation"><xsl:text>http://oval.mitre.org/XMLSchema/oval-variables-5 oval-variables-schema.xsd http://oval.mitre.org/XMLSchema/oval-common-5 oval-common-schema.xsd</xsl:text></xsl:attribute>
				
				<xsl:element name="generator" namespace="http://oval.mitre.org/XMLSchema/oval-variables-5">
					<xsl:element name="product_name" namespace="http://oval.mitre.org/XMLSchema/oval-common-5">
						<xsl:text>SCAP datastream OVAL extraction stylesheet</xsl:text>
					</xsl:element>
					<xsl:element name="schema_version" namespace="http://oval.mitre.org/XMLSchema/oval-common-5">
						<xsl:value-of select="$minSchemaVersion"/>
					</xsl:element>
					<xsl:element name="timestamp" namespace="http://oval.mitre.org/XMLSchema/oval-common-5">
						<xsl:value-of select="current-dateTime()"/>
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="variables" namespace="http://oval.mitre.org/XMLSchema/oval-variables-5">
					<xsl:for-each select="//xccdf:Rule[not(./@hidden='true')]">
						<xsl:choose>
							<xsl:when test="./xccdf:check">
								<xsl:for-each select="./xccdf:check/xccdf:check-export">
									<xsl:variable name="var_name" select="@value-id"/>
									<xsl:variable name="export_name" select="@export-name"/>
									<xsl:for-each select="//xccdf:Profile[@id=$profile_id]/xccdf:refine-value[@idref=$var_name]">
										<xsl:variable name="selector_name" select="@selector"/>
										<xsl:for-each select="//xccdf:Value[@id=$var_name]/xccdf:value[@selector=$selector_name]">
											<xsl:variable name="var_comment" select="../xccdf:title"/>
											<xsl:variable name="var_datatype" select="../@type"/>
											
											<xsl:element name="variable" namespace="http://oval.mitre.org/XMLSchema/oval-variables-5">
												<xsl:attribute name="id"><xsl:value-of select="$export_name"/></xsl:attribute>
												<xsl:attribute name="datatype">
													<xsl:choose>
														<xsl:when test="$var_datatype='number'"><xsl:text>int</xsl:text></xsl:when>
														<xsl:otherwise><xsl:value-of select="$var_datatype"/></xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
												<xsl:attribute name="comment"><xsl:value-of select="$var_comment"/></xsl:attribute>
												<xsl:element name="value" namespace="http://oval.mitre.org/XMLSchema/oval-variables-5">
													<xsl:value-of select="."/>
												</xsl:element>
											</xsl:element>
										</xsl:for-each>
									</xsl:for-each>
									
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:result-document>
	</xsl:template>
	
	
</xsl:stylesheet>


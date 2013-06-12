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
            
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cdf="http://checklists.nist.gov/xccdf/1.1" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="cdf" xmlns="http://checklists.nist.gov/xccdf/1.1">

    <xsl:output method="xml" indent="yes" omit-xml-declaration="no" encoding="UTF-8"/>

    <!-- the id of the desired rule. -->
    <xsl:param name="desiredRuleId" required="yes" as="xsd:string"/>
    
    <!-- does the rule have a value id to get too?? -->
    <xsl:variable name="valueId" select="//cdf:Rule[@id = $desiredRuleId]/cdf:check/cdf:check-export/@value-id"/>

    <!-- Gets the top level node -->
    <xsl:template match="cdf:Benchmark">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            
            <!-- elements to simply copy -->
            <xsl:copy-of select="./cdf:status|./cdf:title|./cdf:description|./cdf:platform|./cdf:reference|./cdf:model|./cdf:version"/>            
            
            <!-- The value to copy -->
            <xsl:copy-of select=".//cdf:Value[@id = $valueId]"/>
            
            <xsl:for-each select=".//cdf:Rule[@id = $desiredRuleId]">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:copy-of  select="./child::*[local-name() != 'requires']"/>
                </xsl:copy>                
            </xsl:for-each>
            
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>

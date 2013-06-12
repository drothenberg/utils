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
            
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:oval-def="http://oval.mitre.org/XMLSchema/oval-definitions-5" xmlns:cdf="http://checklists.nist.gov/xccdf/1.1" xmlns:dc="http://purl.org/dc/elements/1.1/" version="2.0" xmlns:ovalfn="http://oval.mitre.org/xsl/functions" exclude-result-prefixes="cdf" xmlns="http://checklists.nist.gov/xccdf/1.1">

    <xsl:output method="xml" indent="yes" omit-xml-declaration="no" encoding="UTF-8"/>

    <!-- the id of the desired rule. -->
    <xsl:param name="desiredRuleId" required="yes" as="xsd:string"/>
    
    <xsl:variable name="debugMode" as="xsd:boolean" select="0=1"/>

    <!-- Get the file that holds the definition and the id of the definition -->
    <xsl:variable name="definitionFile" select="//cdf:Rule[@id = $desiredRuleId]/cdf:check/cdf:check-content-ref/@href"/>
    <xsl:variable name="definitionId" select="//cdf:Rule[@id = $desiredRuleId]/cdf:check/cdf:check-content-ref/@name"/>

    <!-- Get the definition document -->
    <xsl:variable name="definitionDoc" select="document($definitionFile)"/>

    <!--                                                                                -->
    <!-- Gets the top level xccdf node and starts processign of the definition document -->
    <!--                                                                                -->
    <xsl:template match="cdf:Benchmark">
        <xsl:apply-templates select="$definitionDoc"/>
    </xsl:template>

    <!--                                                                                -->
    <!-- Root of the processing of the oval definitions document                        -->
    <!--                                                                                -->
    <xsl:template match="oval-def:oval_definitions">
        
        <xsl:variable name="allIds" select="ovalfn:getAllIds(./oval-def:definitions/oval-def:definition[@id = 'no mathing id']/@id, $definitionId)"/>
        
        <xsl:if test="$debugMode">
            <xsl:comment>
                <xsl:for-each select="$allIds">
                    <xsl:sort select="." order="ascending"/>
                    <xsl:text>
                        
                    </xsl:text>
                    <xsl:value-of select="."></xsl:value-of>
                </xsl:for-each>
            </xsl:comment>
        </xsl:if>

        <xsl:copy>
            <xsl:copy-of select="@*"/>

            <xsl:copy-of select="oval-def:generator"/>
            
            <!-- write the needed definitions -->
            <xsl:if test="ovalfn:set-contains-substr($allIds, ':def:')">
                <xsl:element name="definitions" namespace="http://oval.mitre.org/XMLSchema/oval-definitions-5">
    
                    <xsl:for-each select="./oval-def:definitions/oval-def:definition[@id = $allIds]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    
                    <xsl:if test="$debugMode">
                        <xsl:for-each select="./oval-def:definitions/oval-def:definition">
                            <xsl:comment>
                                <xsl:text>Checking id: </xsl:text>
                                <xsl:value-of select="@id"/>
                            </xsl:comment>
                            <xsl:if test="ovalfn:member-of($allIds, @id)">
                                <xsl:copy-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
    
                </xsl:element>
            </xsl:if>

            <!-- write the needed tests -->
            <xsl:if test="ovalfn:set-contains-substr($allIds, ':tst:')">
                <xsl:element name="tests" namespace="http://oval.mitre.org/XMLSchema/oval-definitions-5">
                    <xsl:for-each select="./oval-def:tests/child::*[@id = $allIds]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    
                    <xsl:if test="$debugMode">    
                        <xsl:for-each select="./oval-def:tests/child::*">
                            <xsl:comment>
                                <xsl:text>Checking id: </xsl:text>
                                <xsl:value-of select="@id"/>
                            </xsl:comment>
                            <xsl:if test="ovalfn:member-of($allIds, @id)">
                                <xsl:copy-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                    
                </xsl:element>
            </xsl:if>
            

            <!-- write objects -->
            <xsl:if test="ovalfn:set-contains-substr($allIds, ':obj:')">
                <xsl:element name="objects" namespace="http://oval.mitre.org/XMLSchema/oval-definitions-5">
                    <xsl:for-each select="./oval-def:objects/child::*[@id = $allIds]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    
                    <xsl:if test="$debugMode">
                        <xsl:for-each select="./oval-def:objects/child::*">
                            <xsl:comment>
                                <xsl:text>Checking id: </xsl:text>
                                <xsl:value-of select="@id"/>
                            </xsl:comment>
                            <xsl:if test="ovalfn:member-of($allIds, @id)">
                                <xsl:copy-of select="."/>
                            </xsl:if>                        
                        </xsl:for-each>
                    </xsl:if>
                    
                </xsl:element>
            </xsl:if>
            

            <!-- write states -->
            <xsl:if test="ovalfn:set-contains-substr($allIds, ':ste:')">
                <xsl:element name="states" namespace="http://oval.mitre.org/XMLSchema/oval-definitions-5">
                    <xsl:for-each select="./oval-def:states/child::*[@id = $allIds]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    
                    <xsl:if test="$debugMode">
                        <xsl:for-each select="./oval-def:states/child::*">
                            <xsl:comment>
                                <xsl:text>Checking id: </xsl:text>
                                <xsl:value-of select="@id"/>
                            </xsl:comment>
                            <xsl:if test="ovalfn:member-of($allIds, @id)">
                                <xsl:copy-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                    
                </xsl:element>
            </xsl:if>

            <!-- write variables -->
            <xsl:if test="ovalfn:set-contains-substr($allIds, ':var:')">
                <xsl:element name="variables" namespace="http://oval.mitre.org/XMLSchema/oval-definitions-5">
                    <xsl:for-each select="./oval-def:variables/child::*[@id = $allIds]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    
                    <xsl:if test="$debugMode">
                        <xsl:for-each select="./oval-def:variables/child::*">
                            <xsl:comment>
                                <xsl:text>Checking id: </xsl:text>
                                <xsl:value-of select="@id"/>
                            </xsl:comment>
                            <xsl:if test="ovalfn:member-of($allIds, @id)">
                                <xsl:copy-of select="."/>
                            </xsl:if>                    
                        </xsl:for-each>
                    </xsl:if>
                    
                </xsl:element>
            </xsl:if>

        </xsl:copy>

    </xsl:template>

    <!--                             -->
    <!-- Functions                   -->
    <!--                             -->

    <!-- 
        definitions -> definitions
        definitions -> tests
        states -> variables
        variables -> variables
        variables -> objects
        objects -> variables
        objects -> objects
        objects -> states
        objects -> variables       
    -->

    <!-- recursively get all the ids needed for an id -->
    <xsl:function name="ovalfn:getAllIds" as="item()*">
        <xsl:param name="processedIds" as="item()*"/>
        <xsl:param name="inputId" as="item()"/>
        
        <xsl:if test="$debugMode">
            <xsl:comment>
                <xsl:text>looking for id: </xsl:text>
                <xsl:value-of select="$inputId"/>
            </xsl:comment>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="not(ovalfn:member-of($processedIds, $inputId))">

                <xsl:choose>

                    <xsl:when test="contains($inputId, ':def:')">

                        <xsl:for-each select="$definitionDoc//oval-def:definition[@id = $inputId]//oval-def:extend_definition/@definition_ref | 
                            $definitionDoc//oval-def:definition[@id = $inputId]//oval-def:criterion/@test_ref">
                           
                            <xsl:variable name="returnedIds" select="ovalfn:getAllIds(($processedIds | $inputId), .)"/>
                            <xsl:sequence select="$returnedIds | $processedIds | $inputId | ."/>
                        </xsl:for-each>

                    </xsl:when>

                    <xsl:when test="contains($inputId, ':tst:')">

                        <xsl:for-each select="$definitionDoc//oval-def:tests/child::*[@id = $inputId]/*:object/@object_ref | 
                            $definitionDoc//oval-def:tests/child::*[@id = $inputId]/*:state/@state_ref">
                            
                            <xsl:variable name="returnedIds" select="ovalfn:getAllIds(($processedIds | $inputId), .)"/>
                            <xsl:sequence select="$returnedIds | $processedIds | $inputId | ."/>
                        </xsl:for-each>

                    </xsl:when>

                    <xsl:when test="contains($inputId, ':obj:')">

                        <xsl:for-each select="$definitionDoc//oval-def:objects/child::*[@id = $inputId]/descendant::*/*:object_reference/text() | 
                            $definitionDoc//oval-def:objects/child::*[@id = $inputId]/descendant::*/*:filter/text() | 
                            $definitionDoc//oval-def:objects/child::*[@id = $inputId]/descendant::*/*:var_ref/text() |
                            $definitionDoc//oval-def:objects/child::*[@id = $inputId]/descendant::*/@var_ref">
                            
                            <xsl:variable name="returnedIds" select="ovalfn:getAllIds(($processedIds | $inputId), .)"/>
                            <xsl:sequence select="$returnedIds | $processedIds | $inputId | ."/>
                        </xsl:for-each>

                    </xsl:when>

                    <xsl:when test="contains($inputId, ':ste:')">

                        <xsl:for-each select="$definitionDoc//oval-def:states/child::*[@id = $inputId]/descendant::*/@var_ref">
                            
                            <xsl:variable name="returnedIds" select="ovalfn:getAllIds(($processedIds | $inputId), .)"/>
                            <xsl:sequence select="$returnedIds | $processedIds | $inputId | ."/>
                        </xsl:for-each>

                    </xsl:when>

                    <xsl:when test="contains($inputId, ':var:')">

                        <xsl:for-each select="$definitionDoc//oval-def:variables/child::*[@id = $inputId]/descendant::*/@object_ref |
                            $definitionDoc//oval-def:variables/child::*[@id = $inputId]/descendant::*/@var_ref |
                            $definitionDoc//oval-def:variables/child::*[@id = $inputId]/descendant::*/@object_ref">
                            
                            <xsl:variable name="returnedIds" select="ovalfn:getAllIds(($processedIds | $inputId), .)"/>
                            <xsl:sequence select="$returnedIds | $processedIds | $inputId | ."/>
                        </xsl:for-each>

                    </xsl:when>

                </xsl:choose>

            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$processedIds"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>

    <xsl:function name="ovalfn:set-contains-substr" as="xsd:boolean">
        <xsl:param name="set" as="item()*"/>
        <xsl:param name="subString" as="xsd:string"/>
        <xsl:variable name="contains-substr" as="xsd:boolean*" select="for $test in $set return if (contains($test, $subString)) then true() else ()"/>
        
        <xsl:sequence select="not(empty($contains-substr))"/>
    </xsl:function>
    
    <xsl:function name="ovalfn:element-equality" as="xsd:boolean">
        <xsl:param name="item1" as="item()?"/>
        <xsl:param name="item2" as="item()?"/>
        <xsl:sequence select="$item1 = $item2"/>
    </xsl:function>

    <xsl:function name="ovalfn:member-of" as="xsd:boolean">
        <xsl:param name="set" as="item()*"/>
        <xsl:param name="elem" as="item()"/>
        <xsl:variable name="member-of" as="xsd:boolean*" select="for $test in $set return if (ovalfn:element-equality($test, $elem)) then true() else ()"/>

        <xsl:sequence select="not(empty($member-of))"/>
    </xsl:function>

    <xsl:function name="ovalfn:difference" as="item()*">
        <xsl:param name="nodes1" as="item()*"/>
        <xsl:param name="nodes2" as="item()*"/>
        <xsl:sequence select="for $test in $nodes1 return if (ovalfn:member-of($nodes2,$test)) then () else $test"/>
    </xsl:function>

</xsl:stylesheet>

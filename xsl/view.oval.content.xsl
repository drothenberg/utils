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
    
    AUTHOR:David Rothenberg, The Mitre Corporation 
    DATE: 14 Jun 2012 
    
    The view.oval.content stylesheet converts an OVAL definition document into a more readable html format.
    Designed to mimic the web viewer, this transformation will display information about the definition
    and its components in greater detail.
    
-->
<xsl:stylesheet version="1.1" exclude-result-prefixes="oval oval-def" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oval="http://oval.mitre.org/XMLSchema/oval-common-5" 
    xmlns:oval-def="http://oval.mitre.org/XMLSchema/oval-definitions-5" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="no" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
    <xsl:variable name="hideChildrenCount">10</xsl:variable>
    <xsl:template match="/oval-def:oval_definitions">
        <html>
            <head>
                <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
                <title>OVAL Definition</title>
                <style type="text/css">
                    #Page { padding-bottom:5px; min-width: 900px;}
                    table { border: 1px solid #000000; width: 100%;}
                    td { padding: 0px 4px 1px 4px;}
                    .Label { font-family: Geneva, Arial, Helvetica, sans-serif; color: #000000; font-size: 95%; font-weight: bold; white-space: nowrap;}
                    .TitleLabel { font-family: Geneva, Arial, Helvetica, sans-serif; color: #ffffff; font-size: 95%; font-weight: bold; white-space: nowrap; text-align: left;}
                    .TitleLightLabel { font-family: Geneva, Arial, Helvetica, sans-serif; color: #000000; font-size: 95%; font-weight: bold; white-space: nowrap; text-align: left;}
                    .Text { font-family: Geneva, Arial, Helvetica, sans-serif; color: #000000; font-size: 95%; text-align: left;}
                    .Title { color: #FFFFFF; background-color: #706c60; padding: 0px 4px 1px 4px; font-size: 90%; border-bottom: 1px solid #000000;}
                    .TitleLight { color: #000000; background-color: #E0DBD2; padding: 0px 4px 1px 4px; font-size: 90%; border-bottom: 1px solid #000000;}
                    .LightRow { background-color: #FFFFFF;}
                    .DarkRow { background-color: #EDEDE8;}
                    .Right { text-align: right;}
                    .Center { text-align: center;}
                    .Top { vertical-align: top;}
                    ul { margin-left: 0; padding-left: 20px;}
                    
                    a { color:#676c63;}
                    a.Hover:hover { color:#7b0e0e; text-decoration:underline;}
                    
                    .Classcompliance{background-color: #93C572; display: inline-block; text-decoration: none; padding:0px;}
                    .Classinventory{background-color: #AEC6CF; display: inline-block; text-decoration: none; padding:0px;}
                    .Classmiscellaneous{background-color: #9966CC; display: inline-block; text-decoration: none; padding:0px;}
                    .Classpatch{background-color: #FFDD75; display: inline-block; text-decoration: none; padding:0px;}
                    .Classvulnerability{background-color: #FF9966; display: inline-block; text-decoration: none; padding:0px;}
                    .Box{width: 15px;}
                </style>
            </head>
            
            <body>
                <div id="Page">
                    <div id="Meta">
        				<xsl:for-each select="./oval-def:generator">
        					<xsl:call-template name="Generator" />
        					<br />
        					<hr />
        				</xsl:for-each>
        			</div>
                    <div id="Main">
        				<!-- try to display the highest level item -->
        				<xsl:choose>
        					<xsl:when test="./oval-def:definitions/oval-def:definition">
        						<xsl:for-each select="./oval-def:definitions/oval-def:definition">
        							<xsl:call-template name="SingleDefinition" >
        								<xsl:with-param name="showChildren">
        									<xsl:value-of select="1"/>
        								</xsl:with-param>
        								<xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
        								<xsl:with-param name="ancestorID">oval_</xsl:with-param>
        							</xsl:call-template>
        						</xsl:for-each>
        					</xsl:when>
        					<xsl:when test="./oval-def:tests/*[contains(local-name(.),'_test')]">
        						<xsl:for-each select="./oval-def:tests/*[contains(local-name(.),'_test')]">
        							<xsl:call-template name="SingleTest" >
        								<xsl:with-param name="showChildren">
        									<xsl:value-of select="1"/>
        								</xsl:with-param>
        								<xsl:with-param name="defaultShowHideStyle">block</xsl:with-param>
        								<xsl:with-param name="ancestorID">oval_</xsl:with-param>
        							</xsl:call-template>
        						</xsl:for-each>
        					</xsl:when>
        					<xsl:when test="./oval-def:objects/*[contains(local-name(.),'_object')]">
        						<xsl:for-each select="./oval-def:objects/*[contains(local-name(.),'_object')]">
        							<xsl:call-template name="SingleObject" >
        								<xsl:with-param name="showChildren">
        									<xsl:value-of select="1"/>
        								</xsl:with-param>
        								<xsl:with-param name="defaultShowHideStyle">block</xsl:with-param>
        								<xsl:with-param name="ancestorID">oval_</xsl:with-param>
        							</xsl:call-template>                
        						</xsl:for-each>
        					</xsl:when>
        					<xsl:when test="./oval-def:states/*[contains(local-name(.),'_state')]">
        						<xsl:for-each select="./oval-def:states/*[contains(local-name(.),'_state')]">
        							<xsl:call-template name="SingleState" >
        								<xsl:with-param name="showChildren">
        									<xsl:value-of select="1"/> 
        								</xsl:with-param>
        								<xsl:with-param name="defaultShowHideStyle">block</xsl:with-param>
        								<xsl:with-param name="ancestorID">oval_</xsl:with-param>
        							</xsl:call-template>
        						</xsl:for-each>
        					</xsl:when>
        					<xsl:when test="./oval-def:variables/*[contains(local-name(.),'_variable')]">
        						<xsl:for-each select="./oval-def:variables/*[contains(local-name(.),'_variable')]">
        							<xsl:call-template name="SingleVariable" >
        								<xsl:with-param name="showChildren">
        									<xsl:value-of select="1"/>
        								</xsl:with-param>
        								<xsl:with-param name="defaultShowHideStyle">block</xsl:with-param>
        								<xsl:with-param name="ancestorID">oval_</xsl:with-param>
        							</xsl:call-template>
        						</xsl:for-each>
        					</xsl:when>
        					<xsl:otherwise>
        						OVAL file contains no definitions, tests, objects, states, or variables.
        					</xsl:otherwise>
        				</xsl:choose>
        			</div>
        			<script type="text/javascript">
        			    /*toggle and toggleCollapsed separated to reduce DOM queries for the collapse div*/
        				function toggle(showHideDiv) {
        					var ele = document.getElementById(showHideDiv);
        					if(ele.style.display == "block") {
        							ele.style.display = "none";
        					  }
        					else {
        						ele.style.display = "block";
        					}
        				}
        				
        				function toggleCollapse(showHideDiv) {
        					var ele = document.getElementById(showHideDiv);
        					var cele = document.getElementById("collapse"+showHideDiv);
        					if(ele.style.display == "block") {
        							ele.style.display = "none";
        							cele.innerHTML = "[ + ]";
        					  }
        					else {
        						ele.style.display = "block";
        						cele.innerHTML = "[ - ]";
        					}
        				}
        				
        				function expandDiv(showHideDiv) {
        					var ele = document.getElementById(showHideDiv);
        					var cele = document.getElementById("collapse"+showHideDiv);
        					ele.style.display = "block";
        					cele.innerHTML = "[ - ]";
        					window.location.hash='#a_'+showHideDiv.substring(showHideDiv.lastIndexOf('_')+1);
        				}
        			</script>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- Contains information about the file metadata -->
    <xsl:template name="Generator">
        <xsl:variable name="MessyNumber" select="string(./oval:timestamp)"/>
        <table border="1" cellspacing="0" cellpadding="2">
            <tr class="Title">
                <td class="TitleLabel" colspan="5">OVAL Definition Generator Information</td>
            </tr>
            <tr class="DarkRow">
                <td class="Label">Schema Version</td>
                <td class="Label">Product Name</td>
                <td class="Label">Product Version</td>
                <td class="Label">Date</td>
                <td class="Label">Time</td>
            </tr>
            <tr class="LightRow">
                <td class="Text"><xsl:value-of select="./oval:schema_version"/>&#160;</td>
                <td class="Text"><xsl:value-of select="./oval:product_name"/>&#160;</td>
                <td class="Text"><xsl:value-of select="./oval:product_version"/>&#160;</td>
                <td class="Text">
                    <!--Create variable "MessyNumber" to make time stamp a string and then print it out in a readable version -->
                    <xsl:value-of select="substring($MessyNumber, 1, 4)"/>
                    <!-- year -->
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="substring($MessyNumber, 6, 2)"/>
                    <!-- month -->
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="substring($MessyNumber, 9, 2)"/>
                    <!-- day -->
                </td>
                <td class="Text">
                    <xsl:value-of select="substring($MessyNumber, 12, 2)"/>
                    <xsl:text>:</xsl:text>
                    <!-- hour -->
                    <xsl:value-of select="substring($MessyNumber, 15, 2)"/>
                    <xsl:text>:</xsl:text>
                    <!-- minute -->
                    <xsl:value-of select="substring($MessyNumber, 18, 2)"/>&#160; <!-- second -->
                </td>       
            </tr>
            <tr class="DarkRow">
                <td class="Label" style="width: 20%;">#Definitions</td>
                <td class="Label" style="width: 20%;">#Tests</td>
                <td class="Label" style="width: 20%;">#Objects</td>
                <td class="Label" style="width: 20%;">#States</td>
                <td class="Label" style="width: 20%;">#Variables</td>
            </tr>
            <tr class="LightRow Center">
                <td class="Text Center">
                    <xsl:value-of select="count(/oval-def:oval_definitions/oval-def:definitions/oval-def:definition)"/>&#160;Total<br />
                    <xsl:if test="/oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class]">
                        <table style="border: none;">
                            <tr class="Text Center">
                                <td class="Classcompliance" title="compliance" style="width:20%"><xsl:value-of select="count(/oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class='compliance'])"/></td>
                                <td class="Classinventory" title="inventory" style="width:20%"><xsl:value-of select="count(/oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class='inventory'])"/></td>
                                <td class="Classmiscellaneous" title="miscellaneous" style="width:20%"><xsl:value-of select="count(/oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class='miscellaneous'])"/></td>
                                <td class="Classpatch" title="patch" style="width:20%"><xsl:value-of select="count(/oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class='patch'])"/></td>
                                <td class="Classvulnerability" title="vulnerability" style="width:20%"><xsl:value-of select="count(/oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class='vulnerability'])"/></td>
                            </tr>
                        </table>
                    </xsl:if>
                </td>
                <td class="Text Center">
                    <xsl:value-of select="count(/oval-def:oval_definitions/oval-def:tests/*)"/>
                </td>
                <td class="Text Center">
                    <xsl:value-of select="count(/oval-def:oval_definitions/oval-def:objects/*)"/>
                </td>
                <td class="Text Center">
                    <xsl:value-of select="count(/oval-def:oval_definitions/oval-def:states/*)"/>
                </td>
                <td class="Text Center">
                    <xsl:value-of select="count(/oval-def:oval_definitions/oval-def:variables/*)"/>
                </td>
            </tr>
        </table>
    </xsl:template>
    
    <!-- Contains information for one definition -->
    <xsl:template name="SingleDefinition">
        <xsl:param name="showChildren"/>
        <xsl:param name="defaultShowHideStyle"/>
        <xsl:param name="ancestorID"/>
        <xsl:param name="isReferencedByTemplate"/>
        <xsl:variable name="curID"><xsl:value-of select="./@id"/></xsl:variable>
        <xsl:variable name="classPrefix">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 1">Title</xsl:when>
                <xsl:when test="position() mod 2 = 0">TitleLight</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <a name="{concat('a_',translate(./@id,':','-'))}" id="{concat('a_',translate(./@id,':','-'))}"/>
        <table border="0" cellpadding="0" cellspacing="0">
            <tbody>
                <tr class="{$classPrefix}">
                    <td class="{$classPrefix}Label Box">
                        <span class="{concat('Class',./@class)} Box" title="{./@class}">&#160;</span> 
                    </td>
                    <td class="{$classPrefix}Label" colspan="2" style="padding-left: 0px;">
                        <xsl:attribute name="onclick">javascript:toggleCollapse('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'))"/>');</xsl:attribute>
                        <xsl:attribute name="title">(<xsl:value-of select="./@class"/>)&#160;<xsl:value-of select="./oval-def:metadata/oval-def:description"/></xsl:attribute>
                        Definition Id:&#160;<xsl:value-of select="./@id"/>&#160;-&#160;<xsl:value-of select="substring(./oval-def:metadata/oval-def:title,1,50)"/>
                        <xsl:if test="string-length(./oval-def:metadata/oval-def:title) &gt; 50">...</xsl:if>
                    </td>
                    <td class="{$classPrefix}Label Right" colspan="1">
                        <a class="{$classPrefix}Label Hover" id="{concat('collapse',$ancestorID,translate($curID,':','-'))}" style="text-decoration: none">
                            <xsl:attribute name="title">Toggle show/hide</xsl:attribute>
                            <xsl:attribute name="href">javascript:toggleCollapse('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'))"/>');</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="$defaultShowHideStyle = 'block'">[ - ]</xsl:when>
                                <xsl:otherwise>[ + ]</xsl:otherwise>
                            </xsl:choose>
                        </a>&#160;
                    </td>
                </tr>
            </tbody>
        </table>
        <!-- unique name div -->
        <div style="display: {$defaultShowHideStyle};" id="{concat($ancestorID,translate($curID,':','-'))}">
            <table border="0" cellpadding="0" cellspacing="0">
                <tbody>
                    <tr class="DarkRow">
                        <td class="Label">Title:</td>
                        <td class="Text" colspan="3">
                            <xsl:value-of select="./oval-def:metadata/oval-def:title"/>
                        </td>
                    </tr>
                    <tr class="LightRow Top">
                        <td class="Label">Description:</td>
                        <td class="Text" colspan="3">
                            <xsl:value-of select="./oval-def:metadata/oval-def:description"/>
                        </td>
                    </tr>
                    <tr class="DarkRow">
                        <td class="Label" style="width: 10%;">Family:</td>
                        <td class="Text" style="width: 40%;">
                            <xsl:value-of select="./oval-def:metadata/oval-def:affected/@family"/>
                        </td>
                        <td class="Label" style="width: 10%;">Class:</td>
                        <td class="Text" style="width: 40%;">
                            <xsl:value-of select="./@class"/>
                        </td>
                    </tr>
                    <tr class="LightRow Top">
                        <td class="Label" style="width: 10%;">Reference(s):</td>
                        <td class="Text" style="width: 40%;">
                            <xsl:for-each select="./oval-def:metadata/oval-def:reference">
                                <a class="Hover" target="_blank" href="{./@ref_url}"><xsl:value-of select="./@ref_id"/></a>
                                <br />
                            </xsl:for-each>
                        </td>
                        <td class="Label" style="width: 10%;">
                            Version:
                        </td>
                        <td class="Text" style="width: 40%;">
                            <xsl:value-of select="./@version"/>
                        </td>
                    </tr>
                    <tr class="DarkRow Top">
                        <td class="Label">Platform(s):</td>
                        <td class="Text">
                            <xsl:for-each select="./oval-def:metadata/oval-def:affected/oval-def:platform">
                                <xsl:value-of select="."/>
                                <br/>
                            </xsl:for-each>
                        </td>
                        <td class="Label">Product(s):</td>
                        <td class="Text">
                            <xsl:for-each select="./oval-def:metadata/oval-def:affected/oval-def:product">
                                <xsl:value-of select="."/>
                                <br/>
                            </xsl:for-each>
                        </td>
                    </tr>
                    <tr class="Title">
                        <td class="TitleLabel" colspan="4" style="padding:1px 4px;">
                            Definition Synopsis:
                        </td>
                    </tr>
                    <tr class="LightRow">
                        <td class="Text" colspan="4">
                            <ul>
                                <xsl:for-each select="./oval-def:criteria/*">
                                    <xsl:call-template name="RecurseLogic">
                                        <xsl:with-param name="showChildren">
                                            <xsl:value-of select="$showChildren"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                        <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </ul>
                        </td>
                    </tr>
                    <xsl:if test="not($isReferencedByTemplate) and (/descendant-or-self::node()/*[@* = $curID and not(@id)])">
                        <tr class="Title">
                            <td class="TitleLabel" colspan="4">
                                Referenced By:
                            </td>
                        </tr>
                        <tr class="DarkRow">
                            <td class="Text" colspan="4" style='padding-left: 2em;'>
                                <xsl:call-template name="FindRefs">
                                    <xsl:with-param name="entityID"><xsl:value-of select="$curID"/></xsl:with-param>
                                    <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                    </xsl:if>
                </tbody>
            </table>
        </div><!--  end of unique name div--> 
    </xsl:template>
    
    <!-- Recursively build criteria tree -->
    <xsl:template name="RecurseLogic">
        <xsl:param name="showChildren"/>
        <xsl:param name="ancestorID"/>
        <!--build line text, all cases would use this same value -->
        <xsl:variable name="CriteriaText">
            <!-- Ignore operator if first child node(position[1] = name of the node), only show "NOT" when negated", always show comment -->
            <xsl:if test="position()!=1"><xsl:value-of select="../@operator"/>&#160;</xsl:if><xsl:if test="./@negate = 'true'">NOT&#160;</xsl:if><xsl:value-of select="./@comment"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="local-name(.)='criteria'">
                <li><xsl:value-of select="$CriteriaText"/>
                    <ul>
                        <xsl:for-each select="./*">
                            <xsl:call-template name="RecurseLogic">
                                <xsl:with-param name="showChildren">
                                    <xsl:value-of select="$showChildren"/>
                                </xsl:with-param>
                                <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                <xsl:with-param name="ancestorID"><xsl:value-of select="$ancestorID"/></xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </ul>
                </li>
            </xsl:when>
            <xsl:when test="local-name(.)='criterion'">
                <xsl:variable name="tstID" select="./@test_ref"/>
                <li>
                    <a class="Hover">
                        <xsl:attribute name="title">(<xsl:value-of select="local-name(/oval-def:oval_definitions/oval-def:tests/*[@id = $tstID])"/>)&#160;<xsl:value-of select="$tstID"/></xsl:attribute>
                        <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                            <xsl:attribute name="href">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($tstID,':','-'))"/>');</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="$CriteriaText"/>
                    </a>
                    <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                        <div style="width:100%">
                            <xsl:for-each select="/oval-def:oval_definitions/oval-def:tests/*[@id = $tstID]">
                                <xsl:call-template name="SingleTest" >
                                    <xsl:with-param name="showChildren">
                                        <xsl:value-of select="$showChildren + 1"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                    <xsl:with-param name="ancestorID"><xsl:value-of select="$ancestorID"/></xsl:with-param>
                                </xsl:call-template>
                            </xsl:for-each>
                        </div>
                    </xsl:if>
                </li>
            </xsl:when>
            <xsl:when test="local-name(.)='extend_definition'">
                <xsl:variable name="defID" select="./@definition_ref"/>
                <xsl:variable name="defRef" select="/oval-def:oval_definitions/oval-def:definitions/*[@id = $defID]"/>
                <li>
                    <span class="{concat('Class',$defRef/@class)} Box" title="{$defRef/@class}">&#160;</span>
                    <a class="Hover">
                        <xsl:attribute name="title">(<xsl:value-of select="$defRef/@class"/>)&#160;<xsl:value-of select="$defRef/oval-def:metadata/oval-def:description"/></xsl:attribute>
                        <xsl:attribute name="href">javascript:expandDiv('<xsl:value-of select="concat(substring-before($ancestorID,'_'),'_', translate($defID,':','-'))"/>');</xsl:attribute>
                        <xsl:value-of select="$CriteriaText"/>
                    </a>
                </li>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Contains information for one test -->
    <xsl:template name="SingleTest">
        <xsl:param name="showChildren"/>
        <xsl:param name="defaultShowHideStyle"/>
        <xsl:param name="ancestorID"/>
        <xsl:param name="isReferencedByTemplate"/>
        <xsl:variable name="curID"><xsl:value-of select="./@id"/></xsl:variable>
        <!-- unique name div -->
        <div style="display: {$defaultShowHideStyle};" id="{concat($ancestorID,translate($curID,':','-'))}">
            <table border="0" cellpadding="0" cellspacing="0">
                <tbody>
                    <xsl:variable name="objID" select="./*[local-name()='object']/@object_ref"/>
                    <tr class="Title">
                        <td class="TitleLabel" colspan="3">
                            <xsl:attribute name="onclick">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'))"/>');</xsl:attribute>
                            Test Id:&#160;<xsl:value-of select="./@id"/>
                        </td>
                        <td class="TitleLabel Right" colspan="1">
                            Version:<xsl:value-of select="./@version"/>&#160;
                            <a class="TitleLabel Hover" style="TEXT-DECORATION: none">
                                <xsl:attribute name="title">Hide</xsl:attribute>
                                <xsl:attribute name="href">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'))"/>');</xsl:attribute>
                                [X]</a>
                        </td>
                    </tr>
                    <tr class="DarkRow">
                        <td class="Label" style="width: 20%;">Comment:</td>
                        <td class="Text" colspan="3">                    
                            <xsl:value-of select="./@comment"/>
                        </td>
                    </tr>
                    <tr class="LightRow">
                        <td class="Label">Type:</td>
                        <td class="Text"><xsl:value-of select="local-name()"/></td>
                        <td class="Label" style="width: 20%;">Namespace:</td>
                        <td class="Text">
                            <xsl:attribute name="title"><xsl:value-of select="namespace-uri(.)"/></xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="contains(namespace-uri(.),'#')">
                                    <xsl:value-of select="substring-after(namespace-uri(.),'#')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    None
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                    </tr>
                    <tr class="DarkRow">
                        <td class="Label">Check_Existence:</td>
                        <td class="Text"><xsl:value-of select="./@check_existence"/></td>
                        <td class="Label">Check:</td>
                        <td class="Text"><xsl:value-of select="./@check"/></td> 
                    </tr>
                    <tr class="LightRow">
                        <td class="Label">State Operator:</td>
                        <td class="Text" colspan="3">
                            <xsl:choose>
                                <xsl:when test="./@state_operator">
                                    <xsl:value-of select="./@state_operator"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    AND
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                    </tr>
                    <tr class="Title">
                        <td class="TitleLabel" colspan="4">References:</td>
                    </tr>
                    <tr class="DarkRow">
                        <td class="Label Top">Object:</td>
                        <td class="Text" colspan="3">
                            <a class="Hover">
                                <xsl:attribute name="title">(<xsl:value-of select="local-name(/oval-def:oval_definitions/oval-def:objects/*[@id = $objID])"/>)&#160;<xsl:value-of select="/oval-def:oval_definitions/oval-def:objects/*[@id = $objID]/@comment"/></xsl:attribute>
                                <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                                    <xsl:attribute name="href">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_',translate($objID,':','-'))"/>');</xsl:attribute>
                               </xsl:if>
                                <xsl:value-of select="$objID"/>
                            </a>
                        </td>
                    </tr>
                    <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                        <tr class="DarkRow">
                            <td class="Text" colspan="4" style='padding-left: 2em;'>
                                <xsl:for-each select="/oval-def:oval_definitions/oval-def:objects/*[@id = $objID]">
                                    <xsl:call-template name="SingleObject" >
                                        <xsl:with-param name="showChildren">
                                            <xsl:value-of select="$showChildren + 1"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                        <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </td>
                        </tr>
                    </xsl:if>
                    <xsl:for-each select="./*[local-name()='state']">
                        <xsl:variable name="steID" select="./@state_ref"/>
                        <tr class="LightRow">
                            <td class="Label Top"><xsl:if test="position() = 1">State:</xsl:if></td>
                            <td class="Text" colspan="3">
                                <a class="Hover">
                                    <xsl:attribute name="title">(<xsl:value-of select="local-name(/oval-def:oval_definitions/oval-def:states/*[@id = $steID])"/>)&#160;<xsl:value-of select="/oval-def:oval_definitions/oval-def:states/*[@id = $steID]/@comment"/></xsl:attribute>
                                    <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                                        <xsl:attribute name="href">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_',translate($steID,':','-'))"/>');</xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="$steID"/>
                                </a>
                            </td>
                        </tr>
                        <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                            <tr class="LightRow">
                                <td class="Text" colspan="4" style='padding-left: 2em;'>
                                    <xsl:for-each select="/oval-def:oval_definitions/oval-def:states/*[@id = $steID]">
                                        <xsl:call-template name="SingleState" >
                                            <xsl:with-param name="showChildren">
                                                <xsl:value-of select="$showChildren + 1"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                            <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </td>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="not($isReferencedByTemplate) and (/descendant-or-self::node()/*[@* = $curID and not(@id)])">
                        <tr class="Title">
                            <td class="TitleLabel" colspan="4">
                                Referenced By:
                            </td>
                        </tr>
                        <tr class="DarkRow">
                            <td class="Text" colspan="4" style='padding-left: 2em;'>
                                <xsl:call-template name="FindRefs">
                                    <xsl:with-param name="entityID"><xsl:value-of select="$curID"/></xsl:with-param>
                                    <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                    </xsl:if>
                </tbody>
            </table>
        </div><!--  end of unique name div--> 
    </xsl:template>
    
    <!-- Contains information for one object -->
    <xsl:template name="SingleObject">
        <xsl:param name="showChildren"/>
        <xsl:param name="defaultShowHideStyle"/>
        <xsl:param name="ancestorID"/>
        <xsl:param name="isReferencedByTemplate"/>
        <xsl:variable name="curID"><xsl:value-of select="./@id"/></xsl:variable>
        <!-- unique name div -->
        <div style="display: {$defaultShowHideStyle};" id="{concat($ancestorID,translate($curID,':','-'))}">
            <table border="0" cellpadding="0" cellspacing="0">
                <tbody>
                    <tr class="Title">
                        <td class="TitleLabel" colspan="3">
                            <xsl:attribute name="onclick">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'))"/>');</xsl:attribute>
                            Object Id:&#160;<xsl:value-of select="./@id"/>
                        </td>
                        <td class="TitleLabel Right" colspan="1">
                            Version:<xsl:value-of select="./@version"/>&#160;
                            <a class="TitleLabel Hover" style="text-decoration: none">
                                <xsl:attribute name="title">Hide</xsl:attribute>
                                <xsl:attribute name="href">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'))"/>');</xsl:attribute>
                                [X]</a>
                        </td>
                    </tr>
                    <tr class="DarkRow">
                        <td class="Label">Comment:</td>
                        <td class="Text" colspan="3">
                            <xsl:value-of select="./@comment"/>
                        </td>
                    </tr>
                    <tr class="LightRow">
                        <td class="Label">Type:</td>
                        <td class="Text"><xsl:value-of select="local-name(.)"/></td>
                        <td class="Label">Namespace:</td>
                        <td class="Text">
                            <xsl:attribute name="title"><xsl:value-of select="namespace-uri(.)"/></xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="contains(namespace-uri(.),'#')">
                                    <xsl:value-of select="substring-after(namespace-uri(.),'#')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    None
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                    </tr>
                    <tr class="Title">
                        <td class="TitleLabel" colspan="4" style="padding:1px 4px;">Object Details:</td>
                    </tr>
                    <xsl:for-each select="./*[local-name()='behaviors']">
                        <tr class="DarkRow">
                            <td colspan="4" class="Label">Behaviors:</td>
                        </tr>
                        <xsl:for-each select="./@*">
                            <tr class="LightRow">
                                <td colspan="4" class="Text" style="padding-left: 2em;">
                                    <span class="Label"><xsl:value-of select="local-name(.)"/>:&#160;</span>
                                    "<xsl:value-of select="."/>"
                                </td>
                            </tr>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:for-each select="./*[not(self::oval-def:set)][not(local-name(self::node())='behaviors')]">
                        <tr class="DarkRow">
                            <td class="Label" colspan="4"><xsl:value-of select="local-name(.)"/>:</td>
                        </tr>
                        <tr class="LightRow">
                            <td colspan="4" style="padding-left: 2em;">
                                <table border="0" cellpadding="0" cellspacing="0" style="border:0;">
                                    <tr class="LightRow">
                                        <td class="Text">
                                            <span class="Label">operation:&#160;</span>
                                            <xsl:choose>
                                                <xsl:when test="./@operation">
                                                    "<xsl:value-of select="./@operation"/>"
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    "equals"
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                        <td class="Text">
                                            <span class="Label">datatype:&#160;</span>
                                            <xsl:choose>
                                                <xsl:when test="./@datatype">
                                                    "<xsl:value-of select="./@datatype"/>"
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    "string"
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                        <td class="Text">
                                            <span class="Label">mask:&#160;</span>
                                            <xsl:choose>
                                                <xsl:when test="./@mask">
                                                    "<xsl:value-of select="./@mask"/>"
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    "false"
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                    </tr>
                                    <xsl:choose>
                                        <xsl:when test="./@var_ref">
                                            <xsl:variable name="varID" select="./@var_ref"/>
                                            <tr class="LightRow">
                                                <td class="Text Top">
                                                    <span class="Label">var_check:&#160;</span>
                                                    <xsl:choose>
                                                        <xsl:when test="./@var_check">
                                                            "<xsl:value-of select="./@var_check"/>"
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            "all"
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </td>
                                                <td class="Text" colspan="2">
                                                    <span class="Label">var_ref:&#160;</span>
                                                    "<a class="Hover">
                                                        <xsl:attribute name="title">(<xsl:value-of select="local-name(/oval-def:oval_definitions/oval-def:variables/*[@id = $varID])"/>)&#160;<xsl:value-of select="/oval-def:oval_definitions/oval-def:variables/*[@id = $varID]/@comment"/></xsl:attribute>
                                                        <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                                                            <xsl:attribute name="href">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_',translate($varID,':','-'))"/>');</xsl:attribute>
                                                        </xsl:if>
                                                        <xsl:value-of select="$varID"/>
                                                    </a>"
                                                </td>
                                            </tr>
                                            <tr class="LightRow">
                                                <td class="Text" colspan="3">
                                                    <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                                                        <xsl:for-each select="/oval-def:oval_definitions/oval-def:variables/*[@id = $varID]">
                                                            <xsl:call-template name="SingleVariable" >
                                                                <xsl:with-param name="showChildren">
                                                                    <xsl:value-of select="$showChildren + 1"/>
                                                                </xsl:with-param>
                                                                <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                                                <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                                            </xsl:call-template>
                                                        </xsl:for-each>
                                                    </xsl:if>
                                                </td>
                                            </tr>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <tr class="LightRow">
                                                <td class="Text" colspan="3">
                                                    <span class="Label">value:&#160;</span>
                                                    <xsl:choose>
                                                        <xsl:when test="./@xsi:nil = 'true'">Nilled</xsl:when>
                                                        <xsl:otherwise>"<xsl:value-of select="."/>"</xsl:otherwise>
                                                    </xsl:choose>
                                                </td>
                                            </tr>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </table>
                            </td>
                        </tr>
                    </xsl:for-each>
                    <xsl:for-each select="./oval-def:set">
                        <tr class="DarkRow">
                            <td class="Label" colspan="4">Set:</td>
                        </tr>
                        <tr class="LightRow">
                            <td class="Text" colspan="4" style="padding-left: 2em; padding-top: 2px; padding-bottom: 2px;">
                                <xsl:call-template name="ObjectSet" >
                                    <xsl:with-param name="showChildren">
                                        <xsl:value-of select="$showChildren + 1"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="defaultShowHideStyle">block</xsl:with-param>
                                    <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                    </xsl:for-each>
                    <xsl:if test="count(./*) = 0">
                        <tr class="DarkRow">
                            <td class="Text" colspan="4">(No object entities)</td>
                        </tr>
                    </xsl:if>
                    <xsl:if test="not($isReferencedByTemplate) and (/descendant-or-self::node()/*[@* = $curID and not(@id)])">
                        <tr class="Title">
                            <td class="TitleLabel" colspan="4">
                                Referenced By:
                            </td>
                        </tr>
                        <tr class="DarkRow">
                            <td class="Text" colspan="4" style='padding-left: 2em;'>
                                <xsl:call-template name="FindRefs">
                                    <xsl:with-param name="entityID"><xsl:value-of select="$curID"/></xsl:with-param>
                                    <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                    </xsl:if>
                </tbody>
            </table>
        </div><!--  end of unique name div--> 
    </xsl:template>
    
    <!-- Contains information for a set of objects -->
    <xsl:template name="ObjectSet">
        <xsl:param name="showChildren"/>
        <xsl:param name="defaultShowHideStyle"/>
        <xsl:param name="ancestorID"/>
        <xsl:param name="isReferencedByTemplate"/>
        <xsl:variable name="curID"><xsl:text>set</xsl:text><xsl:value-of select="position()"/></xsl:variable>
        <!-- unique name div -->
        <div style="display: {$defaultShowHideStyle};" id="{concat($ancestorID,translate($curID,':','-'))}">
            <table border="0" cellpadding="0" cellspacing="0">
                <tbody>
                    <xsl:for-each select="./oval-def:set">
                        <tr class="DarkRow">
                            <td class="Label" colspan="4">Set:</td>
                        </tr>
                        <tr class="LightRow">
                            <td class="Text" colspan="4" style="padding-left: 2em; padding-top: 2px; padding-bottom: 2px;">
                                <xsl:call-template name="ObjectSet" >
                                    <xsl:with-param name="showChildren">
                                        <xsl:value-of select="$showChildren + 1"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="defaultShowHideStyle">block</xsl:with-param>
                                    <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                    </xsl:for-each>
                    <xsl:for-each select="./oval-def:object_reference">
                        <xsl:variable name="objID" select="text()"/>
                        <tr class="DarkRow">
                            <td class="Label Top">Object:</td>
                            <td class="Text" colspan="4">
                                <a class="Hover">
                                    <xsl:attribute name="title">(<xsl:value-of select="local-name(/oval-def:oval_definitions/oval-def:objects/*[@id = $objID])"/>)&#160;<xsl:value-of select="/oval-def:oval_definitions/oval-def:objects/*[@id = $objID]/@comment"/></xsl:attribute>
                                    <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                                        <xsl:attribute name="href">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_',translate($objID,':','-'))"/>');</xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="$objID"/>
                                </a>
                            </td>
                        </tr>
                        <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                            <tr class="LightRow">
                                <td class="Text" colspan="4" style='padding-left: 2em;'>
                                    <xsl:for-each select="/oval-def:oval_definitions/oval-def:objects/*[@id = $objID]">
                                        <xsl:call-template name="SingleObject" >
                                            <xsl:with-param name="showChildren">
                                                <xsl:value-of select="$showChildren + 1"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                            <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </td>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="count(./*) = 0">
                        <tr class="DarkRow">
                            <td class="Text" colspan="4">(No object entities)</td>
                        </tr>
                    </xsl:if>
                </tbody>
            </table>
        </div><!--  end of unique name div--> 
    </xsl:template>
    
    <!-- Contains information for one state -->
    <xsl:template name="SingleState">
        <xsl:param name="showChildren"/>
        <xsl:param name="defaultShowHideStyle"/>
        <xsl:param name="ancestorID"/>
        <xsl:param name="isReferencedByTemplate"/>
        <xsl:variable name="curID"><xsl:value-of select="./@id"/></xsl:variable>
        <!-- unique name div -->
        <div style="display: {$defaultShowHideStyle};" id="{concat($ancestorID,translate($curID,':','-'))}">
            <table border="0" cellpadding="0" cellspacing="0">
                <tbody>
                    <tr class="Title">
                        <td class="TitleLabel" colspan="2">
                            <xsl:attribute name="onclick">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'))"/>');</xsl:attribute>
                            State Id:&#160;<xsl:value-of select="./@id"/>
                        </td>
                        <td class="TitleLabel Right" colspan="2">
                            Version:<xsl:value-of select="./@version"/>&#160;
                            <a class="TitleLabel Hover" style="text-decoration: none">
                                <xsl:attribute name="title">Hide</xsl:attribute>
                                <xsl:attribute name="href">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'))"/>');</xsl:attribute>
                                [X]</a>
                        </td>
                    </tr>
                    <tr class="DarkRow">
                        <td class="Label">Comment:</td>
                        <td class="Text" colspan="3">
                            <xsl:value-of select="./@comment"/>
                        </td>
                    </tr>
                    <tr class="LightRow">
                        <td class="Label">Type:</td>
                        <td class="Text"><xsl:value-of select="local-name(.)"/></td>
                        <td class="Label">Namespace:</td>
                        <td class="Text">
                            <xsl:attribute name="title"><xsl:value-of select="namespace-uri(.)"/></xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="contains(namespace-uri(.),'#')">
                                    <xsl:value-of select="substring-after(namespace-uri(.),'#')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    None
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                    </tr>
                    <tr class="Title">
                        <td class="TitleLabel" colspan="4">State Details:</td>
                    </tr>
                    <xsl:for-each select="./*">
                        <tr class="DarkRow">
                            <td class="Label" colspan="4"><xsl:value-of select="local-name(.)"/>:</td>
                        </tr>
                        <tr class="LightRow">
                            <td colspan="4">
                                <table border="0" cellpadding="0" cellspacing="0" style="border:0;" class="Text">
                                    <tr class="LightRow">
                                        <td class="Text">
                                            <span class="Label">operation:&#160;</span>
                                            <xsl:choose>
                                                <xsl:when test="./@operation">
                                                    "<xsl:value-of select="./@operation"/>"
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    "equals"
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                        <td class="Text">
                                            <span class="Label">datatype:&#160;</span>
                                            <xsl:choose>
                                                <xsl:when test="./@datatype">
                                                    "<xsl:value-of select="./@datatype"/>"
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    "string"
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                    </tr>
                                    <tr class="LightRow">
                                        <td class="Text">
                                            <span class="Label">mask:&#160;</span>
                                            <xsl:choose>
                                                <xsl:when test="./@mask">
                                                    "<xsl:value-of select="./@mask"/>"
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    "false"
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                        <td class="Text">
                                            <span class="Label">entity_check:&#160;</span>
                                            <xsl:choose>
                                                <xsl:when test="./@entity_check">
                                                    "<xsl:value-of select="./@entity_check"/>"
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    "all"
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                    </tr>
                                    <xsl:choose>
                                        <xsl:when test="./@var_ref">
                                            <xsl:variable name="varID" select="./@var_ref"/>
                                            <tr class="LightRow">
                                                <td class="Text Top">
                                                    <span class="Label">var_check:&#160;</span>
                                                    <xsl:choose>
                                                        <xsl:when test="./@var_check">
                                                            "<xsl:value-of select="./@var_check"/>"
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            "all"
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </td>
                                                <td class="Text" colspan="2">
                                                    <span class="Label">var_ref:&#160;</span>
                                                    "<a class="Hover">
                                                        <xsl:attribute name="title">(<xsl:value-of select="local-name(/oval-def:oval_definitions/oval-def:variables/*[@id = $varID])"/>)&#160;<xsl:value-of select="/oval-def:oval_definitions/oval-def:variables/*[@id = $varID]/@comment"/></xsl:attribute>
                                                        <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                                                            <xsl:attribute name="href">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_',translate($varID,':','-'))"/>');</xsl:attribute>
                                                        </xsl:if>
                                                        <xsl:value-of select="$varID"/>
                                                    </a>"
                                                </td>
                                            </tr>
                                            <tr class="LightRow">
                                                <td class="Text" colspan="3">
                                                    <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                                                        <xsl:for-each select="/oval-def:oval_definitions/oval-def:variables/*[@id = $varID]">
                                                            <xsl:call-template name="SingleVariable" >
                                                                <xsl:with-param name="showChildren">
                                                                    <xsl:value-of select="$showChildren + 1"/>
                                                                </xsl:with-param>
                                                                <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                                                <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                                            </xsl:call-template>
                                                        </xsl:for-each>
                                                    </xsl:if>
                                                </td>
                                            </tr>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <tr class="LightRow">
                                                <td class="Text" colspan="3">
                                                    <span class="Label">value:&#160;</span>
                                                    "<xsl:value-of select="."/>"
                                                </td>
                                            </tr>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </table>
                            </td>
                        </tr>
                    </xsl:for-each>
                    <xsl:if test="not($isReferencedByTemplate) and (/descendant-or-self::node()/*[@* = $curID and not(@id)])">
                        <tr class="Title">
                            <td class="TitleLabel" colspan="4">
                                Referenced By:
                            </td>
                        </tr>
                        <tr class="DarkRow">
                            <td class="Text" colspan="4" style='padding-left: 2em;'>
                                <xsl:call-template name="FindRefs">
                                    <xsl:with-param name="entityID"><xsl:value-of select="$curID"/></xsl:with-param>
                                    <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                    </xsl:if>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <!-- Contains information for one variable -->
    <xsl:template name="SingleVariable">
        <xsl:param name="showChildren"/>
        <xsl:param name="defaultShowHideStyle"/>
        <xsl:param name="ancestorID"/>
        <xsl:param name="isReferencedByTemplate"/>
        <xsl:variable name="curID"><xsl:value-of select="./@id"/></xsl:variable>
        <!-- unique name div -->
        <div style="display: {$defaultShowHideStyle};" id="{concat($ancestorID,translate($curID,':','-'))}">
            <table border="0" cellpadding="0" cellspacing="0">
                <tbody>
                    <tr class="Title">
                        <td class="TitleLabel" colspan="3">
                            <xsl:attribute name="onclick">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'))"/>');</xsl:attribute>
                            Variable Id:&#160;<xsl:value-of select="./@id"/>
                        </td>
                        <td class="TitleLabel Right">
                            Version:<xsl:value-of select="./@version"/>&#160;
                            <a class="TitleLabel Hover" style="text-decoration: none">
                                <xsl:attribute name="title">Hide</xsl:attribute>
                                <xsl:attribute name="href">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($curID,':','-'))"/>');</xsl:attribute>
                                [X]</a>
                        </td>
                    </tr>
                    <tr class="LightRow">
                        <td class="Label">Comment:</td>
                        <td class="Text" colspan="3">
                            <xsl:value-of select="./@comment"/>
                        </td>
                    </tr>
                    <tr class="DarkRow">
                        <td class="Label">Type:</td>
                        <td class="Text"><xsl:value-of select="local-name(.)"/></td>
                        <td class="Label">Namespace:</td>
                        <td class="Text">
                            <xsl:attribute name="title"><xsl:value-of select="namespace-uri(.)"/></xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="contains(namespace-uri(.),'#')">
                                    <xsl:value-of select="substring-after(namespace-uri(.),'#')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    None
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                    </tr>
                    <tr class="LightRow">
                        <td class="Label">Datatype:</td>
                        <td class="Text" colspan="3">
                            <xsl:value-of select="./@datatype"/>
                        </td>
                    </tr>
                    <tr class="Title">
                        <td class="TitleLabel" colspan="4">Variable Details:</td>
                    </tr>
                    <xsl:choose>
                        <xsl:when test="local-name(.) = 'constant_variable'">
                            <xsl:for-each select="./oval-def:value">
                                <tr class="LightRow">
                                    <td class="Text" colspan="4">
                                        <table border="0" cellpadding="0" cellspacing="0" style="border:0">
                                            <tr class="LightRow">
                                                <td class="Text">
                                                    <span class="Label">value: </span>
                                                    <xsl:value-of select="."/>
                                                </td>
                                            </tr>
                                        </table>                    
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="local-name(.) = 'local_variable'">
                            <tr class="LightRow">
                                <td colspan="4">
                                    <table border="0" cellpadding="0" cellspacing="0" style="border:0">
                                        <xsl:call-template name="RecurseLocalVar" >
                                            <xsl:with-param name="showChildren">
                                                <xsl:value-of select="$showChildren + 1"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                            <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                        </xsl:call-template>
                                    </table>
                                </td>
                            </tr>
                        </xsl:when>
                        <xsl:when test="local-name(.) = 'external_variable'">
                            <xsl:for-each select="./oval-def:possible_value">
                                <tr class="LightRow">
                                    <td class="Text" colspan="4" title="{./@hint}">
                                        <span class="Label">Possible Value:&#160;</span>
                                        <xsl:value-of select="."/>  
                                    </td>
                                </tr>
                            </xsl:for-each>
                            <xsl:for-each select="./oval-def:possible_restriction">
                                <tr class="LightRow">
                                    <td class="Text" colspan="4" title="{./@hint}">
                                        <span class="Label">Possible Restriction:&#160;</span>
                                        <xsl:value-of select="."/>
                                    </td>
                                </tr>
                                <tr class="LightRow">
                                    <td class="Text" colspan="4" style='padding-left: 2em;'>
                                        <span class="Label">Operation:&#160;</span>
                                        <xsl:value-of select="./oval-def:restriction/@operation"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                            <!-- When no restriction given, limit to datatype -->
                            <xsl:if test="count(./*) = 0">
                                <tr class="LightRow">
                                    <td class="Text" colspan="4">
                                        <span class="Label">Datatype Restriction:&#160;</span>
                                        <xsl:value-of select="./@datatype"/>  
                                    </td>
                                </tr>
                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:if test="not($isReferencedByTemplate) and (/descendant-or-self::node()/*[@* = $curID and not(@id)])">
                        <tr class="Title">
                            <td class="TitleLabel" colspan="4">
                                Referenced By:
                            </td>
                        </tr>
                        <tr class="DarkRow">
                            <td class="Text" colspan="4">
                                <xsl:call-template name="FindRefs">
                                    <xsl:with-param name="entityID"><xsl:value-of select="$curID"/></xsl:with-param>
                                    <xsl:with-param name="ancestorID"><xsl:value-of select="concat($ancestorID,translate($curID,':','-'),'_')"/></xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                    </xsl:if>
                </tbody>
            </table>
        </div>
    </xsl:template>
    
    <!-- Recursively build local variable tree -->
    <xsl:template name="RecurseLocalVar">
        <xsl:param name="showChildren"/>
        <xsl:param name="ancestorID"/>
        <xsl:variable name="lvFunction" select="./*[not(contains(local-name(.),'_component'))]" />
        <xsl:if test="$lvFunction">
            <tr class="LightRow">
                <td class="Text" colspan="4">
                    <span class="Label" style="text-transform: capitalize"><xsl:value-of select="local-name($lvFunction)"/>&#160;Function:&#160;</span>
                    <xsl:for-each select="$lvFunction">
                        <table border="0" cellpadding="0" cellspacing="0" style="border:0">
                            <xsl:call-template name="RecurseLocalVar" >
                                <xsl:with-param name="showChildren">
                                    <xsl:value-of select="$showChildren + 1"/>
                                </xsl:with-param>
                                <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                <xsl:with-param name="ancestorID"><xsl:value-of select="$ancestorID"/></xsl:with-param>
                            </xsl:call-template>
                        </table>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
        <tr class="LightRow">
            <td class="Text" style='padding-left: 2em;'>
                <xsl:for-each select="./oval-def:object_component|./oval-def:variable_component|./oval-def:literal_component">
                    <xsl:choose>
                        <xsl:when test="self::oval-def:object_component">
                            <xsl:variable name="objID" select="./@object_ref"/>
                            <table border="0" cellpadding="0" cellspacing="0" style="border:0;">
                                <tr class="LightRow">
                                    <td class="Label" colspan="4">
                                        Object Component: 
                                    </td>
                                </tr>
                                <tr class="LightRow">
                                    <td class="Text Top" colspan="4" style='padding-left:2em;'>
                                        <span class='Label'>Object Reference: </span>
                                        <a class="Hover">
                                            <xsl:attribute name="title">(<xsl:value-of select="local-name(/oval-def:oval_definitions/oval-def:objects/*[@id = $objID])"/>)&#160;<xsl:value-of select="/oval-def:oval_definitions/oval-def:objects/*[@id = $objID]/@comment"/></xsl:attribute>
                                            <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                                                <xsl:attribute name="href">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($objID,':','-'))"/>');</xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="$objID"/>
                                        </a>
                                    </td>
                                </tr>
                                <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                                    <tr class="LightRow">
                                        <td class="Text Top" colspan="4" style='padding-left:4em;'>
                                            <xsl:for-each select="/oval-def:oval_definitions/oval-def:objects/*[@id = $objID]">
                                                <xsl:call-template name="SingleObject" >
                                                    <xsl:with-param name="showChildren">
                                                        <xsl:value-of select="$showChildren + 1"/>
                                                    </xsl:with-param>
                                                    <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                                    <xsl:with-param name="ancestorID"><xsl:value-of select="$ancestorID"/></xsl:with-param>
                                                </xsl:call-template>
                                            </xsl:for-each>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <tr class="LightRow">
                                    <td class="Text" colspan="4" style='padding-left:2em;'>
                                        <span class='Label'>Item Field: </span>
                                        <xsl:value-of select="@item_field"/>
                                    </td>
                                </tr>
                                <xsl:if test="./@record_field">
                                    <tr class="LightRow">
                                        <td class="Text" style='padding-left:2em;'>
                                            <span class='Label'>Record Field: </span>
                                            <xsl:value-of select="@record_field"/>
                                        </td>
                                    </tr>
                                </xsl:if>
                            </table>
                        </xsl:when>
                        <xsl:when test="self::oval-def:variable_component">
                            <xsl:variable name="varID" select="./@var_ref"/>
                            <table border="0" cellpadding="0" cellspacing="0" style="border:0;">
                                <tr class="LightRow">
                                    <td class="Label" colspan="4">
                                        Variable Component: 
                                    </td>
                                </tr>
                                <tr class="LightRow">
                                    <td class="Text" colspan="4" style='padding-left:2em;'>
                                        <span class="Label">Variable Reference:&#160;</span>
                                        <a class="Hover">
                                            <xsl:attribute name="title">(<xsl:value-of select="local-name(/oval-def:oval_definitions/oval-def:variables/*[@id = $varID])"/>)&#160;<xsl:value-of select="/oval-def:oval_definitions/oval-def:variables/*[@id = $varID]/@comment"/></xsl:attribute>
                                            <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                                                <xsl:attribute name="href">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($varID,':','-'))"/>');</xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="$varID"/>
                                        </a>
                                        <xsl:if test="$showChildren &gt; 0 and $showChildren &lt; $hideChildrenCount">
                                            <xsl:for-each select="/oval-def:oval_definitions/oval-def:variables/*[@id = $varID]">
                                                <xsl:call-template name="SingleVariable" >
                                                    <xsl:with-param name="showChildren">
                                                        <xsl:value-of select="$showChildren + 1"/>
                                                    </xsl:with-param>
                                                    <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                                    <xsl:with-param name="ancestorID"><xsl:value-of select="$ancestorID"/></xsl:with-param>
                                                </xsl:call-template>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </td>
                                </tr>
                            </table>
                        </xsl:when>
                        <xsl:when test="self::oval-def:literal_component">
                            <table border="0" cellpadding="0" cellspacing="0" style="border:0;">
                                <tr class="LightRow">
                                    <td class="Label" colspan="4">
                                        Literal Component: 
                                    </td>
                                </tr>
                                <tr class="LightRow">
                                    <td class="Text" colspan="4" style='padding-left:2em;'>
                                        <span class='Label'>
                                            <xsl:choose>
                                                <xsl:when test="./@datatype">
                                                    <xsl:value-of select="./@datatype"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    string
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            :&#160;</span>
                                        <xsl:value-of select="."/>
                                    </td>
                                </tr>
                            </table>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </td>
        </tr>
    </xsl:template>
    
    <!-- prints out views of all referencing IDs -->
    <xsl:template name="FindRefs">
        <xsl:param name="ancestorID"/>
        <xsl:param name="entityID" />
        <!-- Get the elements that reference the ID and is not the item itself -->
        <xsl:for-each select="/descendant-or-self::node()/*[@* = $entityID and not(@id) ]">
            <!-- previous gets the direct node that references the desired ID, we want the containing item (has an ID itself) -->
            <xsl:for-each select="./ancestor::node()[@id][1]">
                <xsl:variable name="entityRef">
                    <xsl:value-of select="./@id" />
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains($ancestorID,translate($entityRef,':','-'))">
                        <xsl:value-of select="$entityRef"/>&#160;(Current view)
                    </xsl:when>
                    <xsl:otherwise>
                        <a class="Hover">
                            <xsl:choose>
                                <xsl:when test="contains(translate($entityRef,':','-'),'-def-')">
                                    <xsl:attribute name="title">(<xsl:value-of select="./@class"/>)&#160;<xsl:value-of select="./oval-def:metadata/oval-def:description"/></xsl:attribute>
                                    <xsl:attribute name="href">javascript:expandDiv('<xsl:value-of select="concat(substring-before($ancestorID,'_'),'_', translate($entityRef,':','-'))"/>');</xsl:attribute>
                                    <span class="{concat('Class',./@class)} Box" title="{./@class}" style="margin-right:5px; margin-top:2px;">&#160;</span>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="title">(<xsl:value-of select="local-name(.)"/>)&#160;<xsl:value-of select="./@comment"/></xsl:attribute>
                                    <xsl:attribute name="href">javascript:toggle('<xsl:value-of select="concat($ancestorID,translate($entityRef,':','-'))"/>');</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:value-of select="$entityRef"/>
                        </a>
                        <!-- choose the right template to call -->
                        <xsl:choose>
                            <xsl:when test="contains(translate($entityRef,':','-'),'-def-')">
                                <!-- already handled -->
                            </xsl:when>
                            <xsl:when test="contains(translate($entityRef,':','-'),'-tst-')">
                                <xsl:call-template name="SingleTest">
                                    <xsl:with-param name="showChildren"><xsl:value-of select="$hideChildrenCount"/></xsl:with-param>
                                    <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                    <xsl:with-param name="ancestorID"><xsl:value-of select="$ancestorID"/></xsl:with-param>
                                    <xsl:with-param name="isReferencedByTemplate">true</xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="contains(translate($entityRef,':','-'),'-obj-')">
                                <xsl:call-template name="SingleObject">
                                    <xsl:with-param name="showChildren"><xsl:value-of select="$hideChildrenCount"/></xsl:with-param>
                                    <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                    <xsl:with-param name="ancestorID"><xsl:value-of select="$ancestorID"/></xsl:with-param>
                                    <xsl:with-param name="isReferencedByTemplate">true</xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="contains(translate($entityRef,':','-'),'-ste-')">
                                <xsl:call-template name="SingleState">
                                    <xsl:with-param name="showChildren"><xsl:value-of select="$hideChildrenCount"/></xsl:with-param>
                                    <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                    <xsl:with-param name="ancestorID"><xsl:value-of select="$ancestorID"/></xsl:with-param>
                                    <xsl:with-param name="isReferencedByTemplate">true</xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="contains(translate($entityRef,':','-'),'-var-')">
                                <xsl:call-template name="SingleVariable">
                                    <xsl:with-param name="showChildren"><xsl:value-of select="$hideChildrenCount"/></xsl:with-param>
                                    <xsl:with-param name="defaultShowHideStyle">none</xsl:with-param>
                                    <xsl:with-param name="ancestorID"><xsl:value-of select="$ancestorID"/></xsl:with-param>
                                    <xsl:with-param name="isReferencedByTemplate">true</xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:if test="not(position() = last())"><br/></xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>

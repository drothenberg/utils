<?xml version="1.0" encoding="UTF-8" standalone="yes"?>

<!--
      License Agreement
      
      Copyright (C) 2012. The MITRE Corporation (http://www.mitre.org/). All Rights Reserved.
      
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
-->

<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xsd="http://www.w3.org/2001/XMLSchema" queryBinding="xslt">
      <sch:title>OVAL Authoring Style Checker</sch:title>
      <sch:p>This set of Schematron rules was developed to check OVAL Definitions documents for compliance with OVAL Repository style guide (http://oval.mitre.org/repository/about/style.html). Both the style guide and these rules are intended to evolve over time. This set of rules is also likely to
            be generally useful in improving the quality of OVAL Definitions.</sch:p>
      <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
      <sch:ns prefix="oval" uri="http://oval.mitre.org/XMLSchema/oval-common-5"/>
      <sch:ns prefix="oval-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5"/>
      <sch:ns prefix="ind-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#independent"/>
      <sch:ns prefix="aix-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#aix"/>
      <sch:ns prefix="apache-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#apache"/>
      <sch:ns prefix="catos-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#catos"/>
      <sch:ns prefix="esx-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#esx"/>
      <sch:ns prefix="freebsd-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#freebsd"/>
      <sch:ns prefix="hpux-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#hpux"/>
      <sch:ns prefix="ios-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#ios"/>
      <sch:ns prefix="linux-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#linux"/>
      <sch:ns prefix="macos-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#macos"/>
      <sch:ns prefix="pixos-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#pixos"/>
      <sch:ns prefix="sp-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#sharepoint"/>
      <sch:ns prefix="sol-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#solaris"/>
      <sch:ns prefix="unix-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#unix"/>
      <sch:ns prefix="win-def" uri="http://oval.mitre.org/XMLSchema/oval-definitions-5#windows"/>
      
      <!--
            Definition Comments
      -->
      <sch:pattern id="definition_root_criteria_comment">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition/oval-def:criteria">
                  <sch:assert test="not(@comment)">
                        <sch:value-of select="../@id"/> - Comment on the definition's root criteria element should not be set.</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <sch:pattern id="definition_element_comment">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition/oval-def:criteria//oval-def:criteria">
                  <sch:assert test="@comment">There should be a comment on all other (non-root) criteria, criterion, and extend_definition elements.</sch:assert>
            </sch:rule>
            
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition/oval-def:criteria//oval-def:criterion">
                  <sch:assert test="@comment">There should be a comment on all other (non-root) criteria, criterion, and extend_definition elements.</sch:assert>
            </sch:rule>
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition/oval-def:criteria//oval-def:extend_definition">
                  <sch:assert test="@comment">There should be a comment on all other (non-root) criteria, criterion, and extend_definition elements.</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <sch:pattern id="definition_referenced_comment">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition/oval-def:criteria//oval-def:criterion">
                  <sch:let name="criterion_comment" value="@comment"/>
                  <sch:let name="criterion_test_ref" value="@test_ref"/>
                  <sch:let name="ref_test_comment" value="/oval-def:oval_definitions/oval-def:tests/*[@id=$criterion_test_ref]/@comment"/>
                  <sch:assert test="$criterion_comment = $ref_test_comment">Comment on the criterion element should match the comment on the referenced test.</sch:assert>
            </sch:rule>
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition/oval-def:criteria//oval-def:extend_definition">
                  <sch:let name="extend_definition_comment" value="@comment"/>
                  <sch:let name="extend_definition_ref" value="@definition_ref"/>
                  <sch:let name="extend_definition_title" value="/oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@id=$extend_definition_ref]/oval-def:metadata/oval-def:title"/>
                  <sch:assert test="$extend_definition_comment = $extend_definition_title">Comment on extend_definition should match it's title. <sch:value-of select="$extend_definition_comment"/> - <sch:value-of select="$extend_definition_title"/> - <sch:value-of select="$extend_definition_ref"/></sch:assert>
            </sch:rule>
            
      </sch:pattern>
      
      <!--
            Do not include the negate attribute on criteria, criterion, or extend_definition elements when the element is not negated.
            Setting negate to false simply reduces readability
      -->
      <sch:pattern id="negate_attribute">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition//oval-def:criteria[@negate='false']">
                  <sch:assert test="not(@negate)">Attribute negate should not be included when element is not negated.</sch:assert>
            </sch:rule>
            
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition/oval-def:criteria//oval-def:criterion[@negate='false']">
                  <sch:assert test="not(@negate)">Attribute negate should not be included when element is not negated.</sch:assert>
            </sch:rule>
            
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition/oval-def:criteria//oval-def:extend_definition[@negate='false']">
                  <sch:assert test="not(@negate)">Attribute negate should not be included when element is not negated.</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <sch:pattern id="definition_new_submission_check">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition">
                  <sch:assert test="(@version != 0 and (./oval-def:metadata/oval-def:oval_repository/oval-def:status != 'INITIAL SUBMISSION')) 
                                or ((@version = 0) and (./oval-def:metadata/oval-def:oval_repository/oval-def:status = 'INITIAL SUBMISSION'))">
                        <sch:value-of select="../@id"/> - New submissions must have a version of '0' and a status of 'INITIAL SUBMISSION.</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <!--
            Patch definitions
      -->
      <sch:pattern id="patch_definitions">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class='patch']">
                  <sch:assert test="count(./oval-def:metadata/oval-def:reference[@source='VENDOR']) = 1">
                        <sch:value-of select="@id"/> - Patch based OVAL Definitions should include only a single reference to a binary patch name with the source set to VENDOR.</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <!--
            Vulnerability Definitions count
      -->
      <sch:pattern id="vulnerability_definitions_count">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class='vulnerability']">
                  <sch:assert test="count(./oval-def:metadata/oval-def:reference[@source='CVE']) &lt; 2">
                        <sch:value-of select="@id"/> - Vulnerability based OVAL definitions include only a single CVE reference. Other references can be derived from the CVE reference.</sch:assert>
                  <sch:assert test="count(./oval-def:metadata/oval-def:reference[@source='CVE']) &gt; 0">
                        Warning: <sch:value-of select="@id"/> - Vulnerability based OVAL definitions should include a CVE reference.</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <!--
            Vulnerability Definitions content
      -->
      <sch:pattern id="vulnerability_definitions_content">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class='vulnerability']/oval-def:metadata/oval-def:reference[@source='CVE']">
                  <!-- Vulnerability defs ref_ids must start with CVE- -->
                  <sch:assert test="starts-with(./@ref_id, 'CVE-')">
                        <sch:value-of select="../../@id"/> - Vulnerability based on OVAL definitions must have a CVE ref_id starting with 'CVE-'</sch:assert>
                  <sch:assert test="starts-with(./@ref_url, 'http://') or starts-with(./@ref_url, 'https://')">
                        <sch:value-of select="../../@id"/> - Vulnerability based on OVAL definitions must have a CVE ref_url starting with 'http(s)://'</sch:assert>
                  <sch:assert test="not(@ref_id) or not(@ref_url) or (@ref_id and @ref_url and contains(@ref_url, @ref_id))">
                        <sch:value-of select="../../@id"/> - Reference url (<sch:value-of select="@ref_url"/>) 
                        must contain the relevant reference ID (<sch:value-of select="@ref_id"/>).</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <!--
            Inventory Definitions count
      -->
      <sch:pattern id="inventory_definitions_count">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class='inventory']">
                  <sch:assert test="count(./oval-def:metadata/oval-def:reference[@source='CPE']) &lt; 2">
                        <sch:value-of select="@id"/> - Inventory OVAL definitions must include only a single CPE reference.</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <!--
            Inventory Definitions content
      -->
      <sch:pattern id="inventory_definitions_content">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class='inventory']/oval-def:metadata/oval-def:reference">
                  <sch:assert test="starts-with(./@ref_id, 'cpe:/o') or starts-with(./@ref_id, 'cpe:/a') or starts-with(./@ref_id, 'cpe:/h')">
                        <sch:value-of select="../../@id"/> - Inventory OVAL definitions must start with 'cpe:/[aoh]'</sch:assert>
                  <sch:assert test="not(./@ref_url)">
                        <sch:value-of select="../../@id"/> - Inventory OVAL definitions should not contain ref_url</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <!--
            Inventory Warnings
      -->
      <sch:pattern id="inventory_warnings">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class='inventory']">
                  <sch:assert test="count(./oval-def:metadata/oval-def:reference[@source='CPE']) != 0">
                        Warning: <sch:value-of select="@id"/> - Inventory OVAL definitions should include a CPE when possible.</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <!--
            Compliance Definitions count
      -->
      <sch:pattern id="compliance_definitions_count">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class='compliance']">
                  <sch:assert test="count(./oval-def:metadata/oval-def:reference[@source='CCE']) &lt; 2">
                        <sch:value-of select="@id"/> - Compliance based OVAL definitions include only a single CCE reference. Other references can be derived from the CCE reference.</sch:assert>
                  <sch:assert test="count(./oval-def:metadata/oval-def:reference[@source='CCE']) > 0">
                        <sch:value-of select="@id"/> - Compliance based OVAL definitions must include a CCE reference.</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <!--
            Inventory Definitions content
      -->      
      <sch:pattern id="compliance_definitions_content">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition[@class='compliance']/oval-def:metadata/oval-def:reference">
                  <sch:let name="refId" value="./@ref_id"/>
                  <sch:let name="numbers" value="'12345567890'"/>
                  <sch:let name="middleAndEnd" value="substring-after($refId, '-')"/>
                  <sch:let name="middle" value="substring-before($middleAndEnd, '-')"/>
                  <sch:let name="end" value="substring-after($middleAndEnd, '-')"/>
                  <sch:let name="middleNumber" value="number($middle)"/>
                  <sch:assert test="starts-with($refId, 'CCE-') 
                        and contains($numbers, $end)
                        and ($middleNumber &lt;= 0 or $middleNumber &gt; 0)">
                        <sch:value-of select="../../@id"/> - Compliance based OVAL definitions must match the pattern 'CCE-\d\d*-\d'</sch:assert>
                  <sch:assert test="starts-with(./@ref_url, 'http://') or starts-with(./@ref_url, 'https://')">
                        <sch:value-of select="../../@id"/> - Compliance based on OVAL definitions must have a CVE ref_url starting with 'http(s)://'</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <!--
            Definition Metadata
      -->
      <sch:pattern id="definition_metadata">
            <sch:rule context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition/oval-def:metadata/oval-def:affected[@family='windows']">
                  <sch:assert test="not(oval-def:platform) or oval-def:platform='Microsoft Windows 95' or oval-def:platform='Microsoft Windows 98' or oval-def:platform='Microsoft Windows ME' or oval-def:platform='Microsoft Windows NT' or oval-def:platform='Microsoft Windows 2000' or oval-def:platform='Microsoft Windows XP' or oval-def:platform='Microsoft Windows Server 2003' or oval-def:platform='Microsoft Windows Vista' or oval-def:platform='Microsoft Windows Server 2008' or oval-def:platform='Microsoft Windows 7' or oval-def:platform='Microsoft Windows Server 2008 R2' or oval-def:platform='Microsoft Windows 8' or oval-def:platform='Microsoft Windows Server 2012'">
                        <sch:value-of select="../../@id"/> - the value "<sch:value-of select="oval-def:platform"/>" found in platform element as part of the affected element is not a valid windows platform.</sch:assert>
            </sch:rule>      
      </sch:pattern>
      
      <!--
            Tests
      -->
      <sch:pattern id="tests">
            <sch:rule context="oval-def:oval_definitions/oval-def:tests/*">
                  <sch:assert test="@check_existence"><sch:value-of select="@id"/> - The check_existence attribute must always be included in tests.</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <!--
            Objects
      -->
      <sch:pattern id="objects">
            <sch:rule context="oval-def:oval_definitions/oval-def:objects/*[@operation='equals']">
                  <sch:assert test="not(@operation = 'equals')"><sch:value-of select="../@id"/> - Attribute operation should only be set when it's not the default value ('equals') to improve readability.</sch:assert>
            </sch:rule>
            <sch:rule context="oval-def:oval_definitions/oval-def:objects/*[@datatype='string']">
                  <sch:assert test="not(@datatype = 'string')"><sch:value-of select="../@id"/> - Attribute datatype should only be set when it's not the default value ('string') to improve readability.</sch:assert>
            </sch:rule>
            <sch:rule context="oval-def:oval_definitions/oval-def:objects/*//*[@operation='pattern match'] |
                  oval-def:oval_definitions/oval-def:objects/*//oval-def:pattern | 
                  oval-def:oval_definitions/oval-def:objects/*//oval-def:line">
                  <sch:let name="exp" value="."/>
                  <sch:report test="not(starts-with($exp, '^'))">
                        Warning: <sch:value-of select="$exp"/> - Regular expressions should start with ^ to avoid matching to more than the desired strings.</sch:report>
                  <sch:report test="not(substring($exp, string-length($exp)) = '$')">
                        Warning: <sch:value-of select="$exp"/> - Regular expressions should end with a $ to avoid matching to more than the desired strings.</sch:report>
            </sch:rule>
      </sch:pattern>
      
      <!--
            States
      -->
      <sch:pattern id="states">
            <sch:rule context="oval-def:oval_definitions/oval-def:states/*[@operator='AND']">
                  <sch:assert test="not(@operator = 'AND')"><sch:value-of select="../@id"/> - Attribute operator should only be set when it's not the default value ('AND') to improve readability.</sch:assert>
            </sch:rule>
            <sch:rule context="oval-def:oval_definitions/oval-def:states/*[@operation='equals']">
                  <sch:assert test="not(@operation = 'equals')"><sch:value-of select="../@id"/> - Attribute operation should only be set when it's not the default value ('equals') to improve readability.</sch:assert>
            </sch:rule>
            <sch:rule context="oval-def:oval_definitions/oval-def:states/*[@datatype='string']">
                  <sch:assert test="not(@datatype = 'string')"><sch:value-of select="../@id"/> - Attribute datatype should only be set when it's not the default value ('string') to improve readability.</sch:assert>
            </sch:rule>
            <sch:rule context="oval-def:oval_definitions/oval-def:states/*//*[@operation='pattern match'] |
                  oval-def:oval_definitions/oval-def:states/*//oval-def:pattern | 
                  oval-def:oval_definitions/oval-def:states/*//oval-def:subexpression">
                  <sch:let name="exp" value="."/>
                  <sch:report test="not(starts-with($exp, '^'))">
                        Warning: <sch:value-of select="$exp"/> - Regular expressions should start with ^ to avoid matching to more than the desired strings.</sch:report>
                  <sch:report test="not(substring($exp, string-length($exp)) = '$')">
                        Warning: <sch:value-of select="$exp"/> - Regular expressions should end with a $ to avoid matching to more than the desired strings.</sch:report>
            </sch:rule>
      </sch:pattern>
      
      <!--
            Variables
      -->
      <sch:pattern id="variables">
            <sch:rule context="oval-def:oval_definitions/oval-def:variables/oval-def:external_variable">
                  <sch:assert test="count(./oval-def:possible_value) > 0">
                        Warning: <sch:value-of select="@id"/> - Missing possible_value in external variable element. External variables should make use of possible_value and possible_restriction elements to tightly restrict the allowable set of input values.</sch:assert>
                  <sch:assert test="count(./oval-def:possible_restriction) > 0">
                        Warning: <sch:value-of select="@id"/> - Missing possible_restriction in external variable element. External variables should make use of possible_value and possible_restriction elements to tightly restrict the allowable set of input values.</sch:assert>
            </sch:rule>
      </sch:pattern>
      
      <sch:diagnostics/>
      
</sch:schema>

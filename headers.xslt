<!DOCTYPE stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:sitemap="http://panax.io/sitemap"
  xmlns:layout="http://panax.io/layout/view/form"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:px="http://panax.io/entity"
  xmlns:data="http://panax.io/source"
  xmlns:form="http://panax.io/widgets/form"
  xmlns:datagrid="http://panax.io/widgets/datagrid"
  xmlns:container="http://panax.io/layout/container"
  exclude-result-prefixes="xo xsl sitemap layout px data form"
>
	<xsl:key name="field" match="px:Field" use="concat(ancestor::px:Entity[1]/@Schema,'.',ancestor::px:Entity[1]/@Name,'.',@Name)"/>
	<xsl:key name="field" match="px:Association" use="concat(ancestor::px:Entity[1]/@Schema,'.',ancestor::px:Entity[1]/@Name,'.',@AssociationName)"/>
	<xsl:template mode="headerText" match="*">
		<xsl:value-of select="@headerText"/>
	</xsl:template>

	<xsl:template mode="headerText" match="@*">
		<xsl:param name="fields" select="ancestor::px:Entity[1]/px:Record/px:*"/>
		<xsl:param name="dataset" select="dummy"/>
		<xsl:variable name="field" select="key('field', concat(ancestor::px:Entity[1]/@Schema,'.',ancestor::px:Entity[1]/@Name,'.',local-name()))"/>
		<xsl:value-of select="$field/@headerText"/>
	</xsl:template>

	<xsl:template mode="headerText" match="layout:layout//*|layout:layout//@*">
		<xsl:param name="fields" select="ancestor::px:Entity[1]/px:Record/px:*"/>
		<xsl:param name="dataset" select="dummy"/>
		<xsl:variable name="field" select="$fields[@Id=current()/ancestor-or-self::*/@Id]"/>
		<xsl:value-of select="$field/@headerText"/>
	</xsl:template>

	<xsl:template mode="headerText" match="layout:layout//container:*|layout:layout//container:*/@*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:variable name="field" select="$fields[@Name=current()/ancestor-or-self::*/@Name]"/>
		<xsl:apply-templates mode="headerText" select="$field"/>
	</xsl:template>
	
</xsl:stylesheet>
﻿<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:xo="http://panax.io/xover"
xmlns:px="http://panax.io/entity"
xmlns:appendTo-data="http://panax.io/listener"
xmlns:data="http://panax.io/source"
xmlns:site="http://panax.io/site"
xmlns:shell="http://panax.io/shell"
xmlns:meta="http://panax.io/metadata"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:widget="http://panax.io/widget"
exclude-result-prefixes="#default xsl px xsi xo data site widget"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>
	<xsl:param name="site:seed">''</xsl:param>
	<xsl:param name="appendTo-data:rows"/>

	<xsl:template match="/">
		<span class="page-menu">
			<xsl:apply-templates mode="widget" select="*/@xo:id"/>
		</span>
	</xsl:template>

	<xsl:template match="px:Entity//*">
	</xsl:template>

	<xsl:template mode="widget" match="shell:shell/@*"/>

	<xsl:template mode="widget" match="px:Entity/@*"/>

	<xsl:template mode="widget" match="px:Entity[@xsi:type='datagrid:control']/@*">
		<xsl:apply-templates mode="widget" select="../px:Parameters"/>
	</xsl:template>

	<xsl:template match="px:Entity[@xsi:type='datagrid:control']/data:rows">
		<xsl:apply-templates mode="widget" select="../px:Parameters"/>
	</xsl:template>

	<xsl:template mode="widget" match="px:Parameters[px:Parameter]">
		<style>
			<![CDATA[span.page-menu nav {
    padding-top: 0rem !important;
    padding-right: 1rem !important;
    padding-left: 1rem !important;
			}
			]]>
		</style>
		<nav class="navbar navbar-expand-md">
			<form action="javascript:void(0);">
				<xsl:apply-templates mode="widget" select="px:Parameter"/>
				<button type="submit" class="btn btn-success" onclick="px.applyFilters(scope)" xo-scope="{parent::px:Entity/@xo:id}" xo-slot="data:rows">
					<xsl:text>Filtrar</xsl:text>
				</button>
			</form>
		</nav>
	</xsl:template>

	<xsl:template mode="widget" match="px:Parameter">
		<xsl:apply-templates mode="widget" select="@xo:id"/>
	</xsl:template>

	<xsl:template mode="widget" match="px:Parameter/@*">
		<div class="input-group">
			<div class="input-group-prepend">
				<span class="input-group-text" id="basic-addon1">
					<xsl:apply-templates mode="headerText" select="../@parameterName"/>
					<xsl:text>: </xsl:text>
				</span>
			</div>
			<xsl:apply-templates mode="widget" select="../@parameterName"/>
		</div>
	</xsl:template>

	<xsl:key name="parameter" match="px:Parameter/@parameterName" use="."/>

	<xsl:template mode="headerText" match="px:Parameter/@parameterName">
		<xsl:value-of select="substring(.,2)"/>
	</xsl:template>

	<xsl:template mode="widget" match="px:Parameter/@parameterName">
		<input type="text" class="form-control" placeholder="" aria-label="" xo-scope="{../@xo:id}" xo-slot="value" value="{../@value}" list="options_{../@xo:id}"/>
		<xsl:variable name="catalog" select="key('parameter-options',.)"/>
		<datalist id="options_{../@xo:id}">
			<xsl:apply-templates mode="widget:options" select="$catalog"/>
		</datalist>
	</xsl:template>

	<xsl:key name="parameter-options" match="px:Parameter/data:rows/xo:r" use="../../@parameterName"/>
	<xsl:template mode="widget:options" match="*">
		<xsl:variable name="value" select="ancestor::px:Parameter[1]/@value"/>
		<option value="{@meta:id}">
			<xsl:if test="$value=@meta:id">
				<xsl:attribute name="selected"/>
			</xsl:if>
			<xsl:value-of select="@meta:text"/>
		</option>
	</xsl:template>

	<!--<xsl:key name="parameter-options" match="px:Parameter[not(@data:rows)][@parameterName='@Estatus']" use="@parameterName"/>
	<xsl:template mode="widget:options" match="key('parameter-options','@Estatus')">
		<xsl:param name="catalog" select="xo:dummy"/>
		<xsl:variable name="value" select="@value"/>
		<option value="null">Todos</option>
		<option>
			<xsl:if test="$value='Abierto'">
				<xsl:attribute name="selected"/>
			</xsl:if> Abierto
		</option>
		<option>
			<xsl:if test="$value='Cerrado'">
				<xsl:attribute name="selected"/>
			</xsl:if>Cerrado
		</option>
	</xsl:template>-->
</xsl:stylesheet>

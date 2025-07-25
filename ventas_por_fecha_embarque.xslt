﻿<xsl:stylesheet version="1.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:data="http://panax.io/data"
xmlns:document="http://panax.io/document"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:state="http://panax.io/state"
xmlns:group="http://panax.io/state/group"
xmlns:filter="http://panax.io/state/filter"
xmlns:visible="http://panax.io/state/visible"
xmlns:datagrid="http://widgets.panaxbi.com/datagrid"
xmlns:total="http://panax.io/total"
xmlns:xo="http://panax.io/xover"
>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="datagrid.xslt"/>
	<xsl:param name="document:storeKey"></xsl:param>

	<xsl:key name="dates" match="fechas/row/@key" use="'active'"/>
	<xsl:key name="filter" match="@filter:*" use="local-name()"/>

	<xsl:key name="state:hidden" match="@xo:*" use="name()"/>
	<xsl:key name="state:hidden" match="@state:*" use="name()"/>

	<xsl:key name="data_type" match="ventas//@od" use="'date'"/>
	<xsl:key name="data_type" match="ventas//@sd" use="'date'"/>
	<xsl:key name="data_type" match="ventas//@ivd" use="'date'"/>
	<xsl:key name="data_type" match="ventas//@pd" use="'date'"/>
	<xsl:key name="data_type" match="ventas//@lot_rd" use="'date'"/>
	<xsl:key name="data_type" match="ventas//@clm_dt" use="'date'"/>

	<xsl:key name="data_type" match="ventas//@sls" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@cos" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@abs_exp" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@upce" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@ucos" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@tcos" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@pfit" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@pfit_c" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@pce" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@pce_ad" use="'money'"/>
	<!--<xsl:key name="data_type" match="ventas//@comm" use="'money'"/>-->

	<xsl:key name="data_type" match="ventas//@comm_p" use="'percent'"/>

	<xsl:key name="data_type" match="ventas//@amt" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@amt_ad" use="'money'"/>

	<xsl:key name="data_type" match="ventas//@qtym" use="'integer'"/>
	<xsl:key name="data_type" match="ventas//@qtys" use="'integer'"/>
	<xsl:key name="data_type" match="ventas//@qty_rcv" use="'integer'"/>

	<xsl:key name="rows" match="/model/ventas/row[not(@xsi:type)]" use="name(..)"/>
	<xsl:key name="facts" match="/model/ventas/row/@*[.!='' and namespace-uri()='']" use="name()"/>

	<xsl:key name="data" match="/model/ventas[not(row/@xsi:type)]/row" use="'*'"/>

	<xsl:key name="data:group" match="model/ventas[not(@group:*)][row]" use="'*'"/>

	<xsl:key name="x-dimension" match="/model/ventas[not(row/@xsi:type)]/@*[namespace-uri()='']" use="name(..)"/>
	<xsl:key name="y-dimension" match="/model/ventas[not(row/@xsi:type)]/*" use="name(..)"/>

	<xsl:param name="data_node">'ventas'</xsl:param>
	<xsl:param name="state:groupBy">*</xsl:param>

	<xsl:template match="/">
		<main xmlns="http://www.w3.org/1999/xhtml" xo-source="seed">
			<xsl:apply-templates mode="datagrid:widget" select="model/ventas"/>
		</main>
	</xsl:template>

	<xsl:template match="@total:upce">
		<xsl:param name="data" select="node-expected"/>
		<xsl:variable name="rows" select="$data/ancestor-or-self::*[1][@qtym and @amt]"/>
		<xsl:value-of select="sum($rows/@amt) div sum($rows/@qtym)"/>
	</xsl:template>

	<xsl:template match="@total:ucos">
		<xsl:param name="data" select="node-expected"/>
		<xsl:variable name="rows" select="$data/ancestor-or-self::*[1][@qtym and @amt]"/>
		<xsl:value-of select="sum($rows/@tcos) div sum($rows/@qtym)"/>
	</xsl:template>

	<xsl:template match="@total:pce">
		<xsl:param name="data" select="node-expected"/>
		<xsl:variable name="rows" select="$data/ancestor-or-self::*[1][@qtym and @qtym]"/>
		<xsl:value-of select="(sum($rows/@amt) - sum($rows/@amt_ad) - sum($rows/@pce_ad)) div sum($rows/@qtym)"/>
	</xsl:template>

	<xsl:template mode="datagrid:caption" match="@*">
		<xsl:text>Vigencia de la información: </xsl:text>
		<xsl:apply-templates select="."/>
		<xsl:if test="$document:storeKey!=''"> (cached)</xsl:if>
		<button class="btn" onclick="refreshStorehouse.call(this, '{$document:storeKey}')" title="Actualizar">
			<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-clockwise" viewBox="0 0 16 16">
				<path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2z"/>
				<path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466"/>
			</svg>
		</button>
	</xsl:template>
</xsl:stylesheet>
<xsl:stylesheet version="1.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:data="http://panax.io/data"
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
	<xsl:import href="common.xslt"/>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="functions.xslt"/>
	<xsl:import href="widgets/datagrid/datagrid.xslt"/>

	<xsl:key name="dates" match="fechas/row/@key" use="'active'"/>
	<xsl:key name="filter" match="@filter:*" use="local-name()"/>

	<xsl:key name="state:hidden" match="@xo:*" use="name()"/>
	<xsl:key name="state:hidden" match="@state:*" use="name()"/>

	<xsl:key name="rows" match="//ventas/row[not(@xsi:type)]" use="name(..)"/>

	<xsl:key name="data" match="/model/ventas[not(row/@xsi:type)]/row" use="'*'"/>

	<xsl:key name="data:group" match="model/ventas[not(@group:*)][row]" use="'*'"/>

	<xsl:key name="x-dimension" match="//ventas[not(row/@xsi:type)]/@*[namespace-uri()='']" use="name(..)"/>
	<xsl:key name="y-dimension" match="//ventas[not(row/@xsi:type)]/*" use="name(..)"/>

	<xsl:param name="data_node">'ventas'</xsl:param>
	<xsl:param name="state:groupBy">*</xsl:param>

	<xsl:template match="/">
		<main xmlns="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates mode="datagrid:widget" select="model/ventas"/>
		</main>
	</xsl:template>

	<xsl:key name="commodity" match="model/commodity/row/@desc" use="../@id"/>
	<xsl:key name="variety" match="model/variedad/row/@desc" use="../@id"/>

	<!--<xsl:template match="@cmm|@cmmc">
		<xsl:apply-templates select="key('commodity', .)"/>
	</xsl:template>

	<xsl:template match="@vr">
		<xsl:apply-templates select="key('variety', .)"/>
	</xsl:template>-->

	<xsl:template match="@total:upce">
		<xsl:param name="data" select="node-expected"/>
		<xsl:variable name="rows" select="$data/ancestor-or-self::*[1][@rqty and @amt]"/>
		<xsl:value-of select="sum($rows/@amt) div sum($rows/@rqty)"/>
	</xsl:template>
</xsl:stylesheet>
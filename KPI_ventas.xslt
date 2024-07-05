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
xmlns:datagrid="http://panaxbi.com/widget/datagrid"
xmlns:xo="http://panax.io/xover"
>
	<xsl:import href="common.xslt"/>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="functions.xslt"/>
	<xsl:import href="widgets/datagrid.xslt"/>

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
	<xsl:key name="data_type" match="ventas//@comm" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@ntp" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@nt" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@ar" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@pce_po" use="'money'"/>

	<xsl:key name="data_type" match="ventas//@amt" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@amt_ad" use="'money'"/>
	<xsl:key name="data_type" match="ventas//@amt_ad_p" use="'percent'"/>
	<xsl:key name="data_type" match="ventas//@comm_p" use="'percent'"/>

	<xsl:key name="data_type" match="ventas//@qtym" use="'integer'"/>
	<xsl:key name="data_type" match="ventas//@qtys" use="'integer'"/>
	<xsl:key name="data_type" match="ventas//@qty_rcv" use="'integer'"/>

	<xsl:key name="rows" match="//ventas/row[not(@xsi:type)]" use="name(..)"/>
	<xsl:key name="facts" match="//ventas/row/@*[.!='' and namespace-uri()='']" use="name()"/>

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


	<xsl:template mode="datagrid:aggregate" match="@upce" priority="1">
		<xsl:value-of select="ancestor::ventas[1]/@state:avg_upce"/>
	</xsl:template>

	<xsl:template mode="datagrid:aggregate" match="@pce" priority="1">
		<xsl:value-of select="ancestor::ventas[1]/@state:avg_pce"/>
	</xsl:template>

	<xsl:template mode="datagrid:footer-cell" match="@ucos" priority="1">
		<td></td>
	</xsl:template>
</xsl:stylesheet>
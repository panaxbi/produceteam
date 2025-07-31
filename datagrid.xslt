<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:data="http://panax.io/data"
	xmlns:datagrid="http://widgets.panaxbi.com/datagrid"
	xmlns:filter="http://panax.io/state/filter"
	xmlns:group="http://panax.io/state/group"
	xmlns:state="http://panax.io/state"
	xmlns:xo="http://panax.io/xover"
>
	<xsl:import href="widgets/datagrid/datagrid.xslt"/>
	<xsl:import href="datagrid-footer.xslt"/>

	<xsl:key name="datagrid:caption" match="@state:data_date" use="../@xo:id"/>

	<xsl:key name="dates" match="fechas/row/@key" use="'active'"/>
	<xsl:key name="filter" match="@filter:*" use="local-name()"/>

	<xsl:key name="state:hidden" match="@xo:*" use="name()"/>
	<xsl:key name="state:hidden" match="@state:*" use="name()"/>

	<xsl:key name="rows" match="//data/row[not(@xsi:type)]" use="name(..)"/>
	<xsl:key name="facts" match="//data/row/@*[.!='' and namespace-uri()='']" use="name()"/>

	<xsl:key name="data" match="/model/data[not(row/@xsi:type)]/row" use="'*'"/>

	<xsl:key name="data:group" match="model/data[not(@group:*)][row]" use="'*'"/>

	<xsl:key name="x-dimension" match="/model/ventas[not(row/@xsi:type)]/@*[namespace-uri()='']" use="name(..)"/>
	<xsl:key name="y-dimension" match="/model/ventas[not(row/@xsi:type)]/*" use="name(..)"/>
	<xsl:key name="x-dimension" match="/model/data[not(row/@xsi:type)]/@*[namespace-uri()='']" use="name(..)"/>
	<xsl:key name="y-dimension" match="/model/data[not(row/@xsi:type)]/*" use="name(..)"/>

	<xsl:param name="data_node">'data'</xsl:param>
	<xsl:param name="state:groupBy">*</xsl:param>
	
	<xsl:template match="/">
		<main xmlns="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates mode="datagrid:widget" select="model/data"/>
		</main>
	</xsl:template>	
</xsl:stylesheet>
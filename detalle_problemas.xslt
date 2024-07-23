<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:session="http://panax.io/session"
xmlns:data="http://panax.io/data"
xmlns:state="http://panax.io/state"
xmlns:group="http://panax.io/state/group"
xmlns:filter="http://panax.io/state/filter"
xmlns:visible="http://panax.io/state/visible"
xmlns:env="http://panax.io/state/environment"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:datagrid="http://widgets.panaxbi.com/datagrid"
xmlns:xo="http://panax.io/xover"
>
	<xsl:import href="common.xslt"/>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="widgets/datagrid/datagrid.xslt"/>

	<xsl:key name="dates" match="fechas/row/@key" use="'active'"/>
	<xsl:key name="filter" match="@filter:*" use="local-name()"/>

	<xsl:key name="state:hidden" match="@xo:*" use="name()"/>
	<xsl:key name="state:hidden" match="@state:*" use="name()"/>
	<xsl:key name="state:hidden" match="@xsi:*" use="name()"/>

	<xsl:key name="data_type" match="trouble//@Description" use="'description'"/>
	<xsl:key name="data_type" match="trouble//@AccountName" use="'description'"/>

	<xsl:key name="data_type" match="trouble//@TransDate" use="'date'"/>
	<xsl:key name="data_type" match="trouble//@PostDate" use="'date'"/>

	<xsl:key name="data_type" match="trouble//@dto" use="'money'"/>

	<xsl:key name="rows" match="//trouble/row[not(@xsi:type)]" use="name(..)"/>
	<xsl:key name="facts" match="//trouble/row/@*[.!='' and namespace-uri()='']" use="name()"/>

	<xsl:key name="data" match="//trouble[not(row/@xsi:type)]/row" use="@Account"/>
	<xsl:key name="data" match="/model/trouble[not(row/@xsi:type)]/row" use="'*'"/>

	<xsl:key name="data:group" match="model/trouble[not(@group:*)][row]" use="'*'"/>

	<xsl:key name="x-dimension" match="//trouble[not(row/@xsi:type)]/@*[namespace-uri()='']" use="name(..)"/>
	<xsl:key name="y-dimension" match="//trouble[not(row/@xsi:type)]/*" use="name(..)"/>

	<xsl:param name="data_node">'trouble'</xsl:param>
	<xsl:param name="state:groupBy">*</xsl:param>

	<xsl:template match="/">
		<!--<xsl:param name="data_node" select="name($data_node)"/>-->
		<main xmlns="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates mode="datagrid:widget" select="model/trouble"/>
		</main>
	</xsl:template>
</xsl:stylesheet>
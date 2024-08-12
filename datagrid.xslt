<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:state="http://panax.io/state"
	xmlns:datagrid="http://widgets.panaxbi.com/datagrid"
>
	<xsl:import href="widgets/datagrid/datagrid.xslt"/>

	<xsl:key name="datagrid:caption" match="@state:data_date" use="generate-id(..)"/>
</xsl:stylesheet>
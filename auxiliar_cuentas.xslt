<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:session="http://panax.io/session"
xmlns:data="http://panax.io/data"
xmlns:shell="http://panax.io/shell"
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
	<xsl:import href="datagrid.xslt"/>
	<xsl:param name="state:hide_empty">false</xsl:param>

	<xsl:key name="state:hidden" match="@*[namespace-uri()!='']" use="name()"/>

	<xsl:key name="data_type" match="movimientos/row/@Description" use="'description'"/>
	<xsl:key name="data_type" match="movimientos/row/@AccountName" use="'description'"/>

	<xsl:key name="data_type" match="movimientos/row/@TransDate" use="'date'"/>
	<xsl:key name="data_type" match="movimientos/row/@PostDate" use="'date'"/>

	<xsl:key name="data_type" match="movimientos//@Debit" use="'money'"/>
	<xsl:key name="data_type" match="movimientos//@Credit" use="'money'"/>
	<xsl:key name="data_type" match="movimientos//@Balance" use="'money'"/>
	<xsl:key name="data_type" match="movimientos//@Amount" use="'money'"/>

	<xsl:key name="facts" match="//movimientos/row/@*[.!='' and namespace-uri()='']" use="name()"/>
	<xsl:key name="data" match="//movimientos/row/@*[.!='' and namespace-uri()='']" use="concat(generate-id(),'::',name())"/>

	<xsl:key name="data" match="/model/movimientos/row" use="@acc"/>
	<xsl:key name="data" match="/model/movimientos/row" use="@Account"/>
	<xsl:key name="data" match="/model/movimientos/row" use="'*'"/>

	<xsl:key name="data:group" match="model/movimientos[not(@group:*)][row]" use="'*'"/>

	<xsl:key name="x-dimension" match="//movimientos/@*[namespace-uri()='']" use="name(..)"/>
	<xsl:key name="y-dimension" match="//movimientos/*" use="name(..)"/>

	<xsl:param name="state:groupBy">*</xsl:param>

	<xsl:template match="/">
		<main xmlns="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates mode="datagrid:widget" select="model/movimientos"/>
		</main>
	</xsl:template>

	<xsl:template mode="datagrid:cell-content" match="@Amount">
		<a class="link" href="?value={.}#detalle_movimientos?@fecha_inicio={//fechas/@state:fecha_inicio}&amp;@fecha_fin={//fechas/@state:fecha_fin}&amp;@account={../@Code}">
			<xsl:apply-templates select="."/>
		</a>
	</xsl:template>

	<xsl:template mode="datagrid:cell-class" match="@Amount">
		<xsl:text> remove-row-if-empty</xsl:text>
	</xsl:template>
</xsl:stylesheet>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:state="http://panax.io/state"
>

	<xsl:template match="/">
		<main xmlns="http://www.w3.org/1999/xhtml">
			<xsl:variable name="fecha_inicio" select="//dates/@state:fecha_inicio"/>
			<xsl:variable name="fecha_fin" select="//dates/@state:fecha_fin"/>
			<xsl:value-of select="//month[@state:selected='true']/@desc"/>
			<google-chart>
				<xsl:attribute name="title">
					Ventas x cultivo con cajas<xsl:apply-templates mode="title" select="$fecha_inicio"/><xsl:apply-templates mode="title" select="$fecha_fin"/>
				</xsl:attribute>
				<xsl:for-each select="//data/row">
					<option value="{@qty}">
						<xsl:value-of select="@vty"/>
					</option>
				</xsl:for-each>
			</google-chart>
			<google-chart type="ComboChart">
				<xsl:attribute name="title">
					Ventas x cultivo con cajas<xsl:apply-templates mode="title" select="$fecha_inicio"/><xsl:apply-templates mode="title" select="$fecha_fin"/>
				</xsl:attribute>
				<xsl:attribute name="options">{vAxis: {title: 'Facturación'}, hAxis: {title: 'Variety'}, seriesType: 'bars', series: {1: {type: 'line'}}}</xsl:attribute>
				<xsl:for-each select="//data/row">
					<option value="{@qty}" Invoiced="{@amt}">
						<xsl:value-of select="@vty"/>
					</option>
				</xsl:for-each>
			</google-chart>
			<!--<google-chart title="Ventas x cultivo con cajas" type="LineChart">
				<xsl:attribute name="options">{vAxis: {title: 'Facturación'}, hAxis: {title: 'Variety'}, seriesType: 'bars', series: {1: {type: 'line'}}}</xsl:attribute>
				<xsl:for-each select="//data/row">
					<option value="{@amt}">
						<xsl:value-of select="@vty"/>
					</option>
				</xsl:for-each>
			</google-chart>-->
		</main>
	</xsl:template>

	<xsl:template mode="title" match="@state:fecha_inicio">
		<xsl:text/> desde el <xsl:value-of select="."/>
	</xsl:template>
	<xsl:template mode="title" match="@state:fecha_fin">
		<xsl:text/> al <xsl:value-of select="."/>
	</xsl:template>
</xsl:stylesheet>
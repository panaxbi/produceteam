<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:state="http://panax.io/state"
>

	<xsl:template match="/">
		<main xmlns="http://www.w3.org/1999/xhtml">
			<xsl:value-of select="//month[@state:selected='true']/@desc"/>
			<google-chart title="Ventas x cultivo con cajas">
				<xsl:for-each select="//data/row">
					<option value="{@qty}">
						<xsl:value-of select="@vty"/>
					</option>
				</xsl:for-each>
			</google-chart>
			<google-chart title="Ventas x cultivo con cajas" type="ComboChart">
				<xsl:attribute name="options">{vAxis: {title: 'Cajas'}, hAxis: {title: 'Variety'}, seriesType: 'bars', series: {1: {type: 'line'}}}</xsl:attribute>
				<xsl:for-each select="//data/row">
					<option value="{@qty}">
						<xsl:value-of select="@vty"/>
					</option>
				</xsl:for-each>
			</google-chart>
			<google-chart title="Ventas x cultivo con cajas" type="LineChart">
				<xsl:attribute name="options">{vAxis: {title: 'Facturación'}, hAxis: {title: 'Variety'}, seriesType: 'bars', series: {1: {type: 'line'}}}</xsl:attribute>
				<xsl:for-each select="//data/row">
					<option value="{@amt}">
						<xsl:value-of select="@vty"/>
					</option>
				</xsl:for-each>
			</google-chart>
		</main>
	</xsl:template>
</xsl:stylesheet>
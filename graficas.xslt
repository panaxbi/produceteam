<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:state="http://panax.io/state"
>
	<xsl:template match="/">
		<main xmlns="http://www.w3.org/1999/xhtml">
			<xsl:variable name="fecha_embarque" select="//fecha_embarque/@state:selected"/>
			<xsl:value-of select="//month[@state:selected='true']/@desc"/>
			<google-chart>
				<xsl:attribute name="title">
					Ventas x cultivo con cajas <xsl:apply-templates mode="title" select="$fecha_embarque"/>
				</xsl:attribute>
				<xsl:for-each select="//data/row">
					<option value="{@qty}">
						<xsl:value-of select="@vty"/>
					</option>
				</xsl:for-each>
			</google-chart>
			<google-chart type="ComboChart">
				<xsl:attribute name="title">
					Ventas x cultivo con cajas <xsl:apply-templates mode="title" select="$fecha_embarque"/>
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

	<xsl:template mode="title" match="@*">
		<xsl:text>desde el </xsl:text>
		<xsl:call-template name="format-date">
			<xsl:with-param name="value" select="substring-before(.,'-')"/>
		</xsl:call-template>
		<xsl:text> al </xsl:text>
		<xsl:call-template name="format-date">
			<xsl:with-param name="value" select="substring-after(.,'-')"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="format-date">
		<xsl:param name="value"/>
		<xsl:value-of select="substring($value,7,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($value,5,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($value,1,4)"/>
	</xsl:template>
</xsl:stylesheet>
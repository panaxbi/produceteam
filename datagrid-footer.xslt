<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:datagrid="http://widgets.panaxbi.com/datagrid"
	xmlns:xo="http://panax.io/xover"
	xmlns:data="http://panax.io/data"
	xmlns:debug="http://panax.io/debug"
	xmlns:group="http://panax.io/state/group"
	xmlns:file="http://panax.io/file"
>
	<xsl:import href="functions.xslt"/>
	<xsl:output method="xml" standalone="yes"/>
	<!--<xsl:key name="datagrid:record-data" match="row/@*" use="../@xo:id"/>-->

	<xsl:key name="data:group" match="*[row]/@group:*" use="local-name()"/>
	<xsl:template match="/">
		<xsl:param name="x-dimension" select="*/@*[namespace-uri()='' or starts-with(namespace-uri(),'http://panax.io/state/group')][not(key('data:group',name()))]"/>
		<xsl:param name="y-dimension" select="*/row"/>
		<xsl:param name="data" select="to-be-removed"/>
		<tr>
			<xsl:attribute name="xo-source">inherit</xsl:attribute>
			<xsl:attribute name="xo-stylesheet">
				<xsl:value-of select="file:href"/>
			</xsl:attribute>
			<th style="white-space: nowrap;">
				<xsl:if test="not(*/row/row)">
					<xsl:value-of select="count($y-dimension)"/> resultados
				</xsl:if>
			</th>
			<xsl:apply-templates mode="datagrid:footer-cell" select="$x-dimension">
				<xsl:sort select="namespace-uri()" order="descending"/>
				<xsl:with-param name="rows" select="$y-dimension"/>
				<xsl:with-param name="data" select="$data"/>
			</xsl:apply-templates>
		</tr>
	</xsl:template>

	<xsl:template mode="datagrid:footer-row" match="*">
		<tr>
			<xsl:attribute name="xo-source">inherit</xsl:attribute>
			<xsl:attribute name="xo-stylesheet">
				<xsl:value-of select="file:href"/>
			</xsl:attribute>
		</tr>
	</xsl:template>

	<xsl:template mode="datagrid:footer-cell" match="@*">
		<xsl:param name="rows" select="node-expected"/>
		<xsl:param name="data" select="node-expected"/>
		<td>
			<xsl:apply-templates mode="datagrid:footer-value" select=".">
				<xsl:with-param name="rows" select="$rows"/>
				<xsl:with-param name="data" select="$data"/>
			</xsl:apply-templates>
		</td>
	</xsl:template>

	<xsl:template mode="datagrid:footer-value" match="@*">
		<xsl:comment>
			<xsl:value-of select="name()"/>
		</xsl:comment>
	</xsl:template>

	<xsl:template mode="datagrid:format" match="@*"></xsl:template>

	<xsl:template mode="format-mask" match="@*">$###,##0.##;-$###,##0.##</xsl:template>
	<xsl:template mode="format-mask" match="@qtym">###,##0;-###,##0</xsl:template>

	<xsl:template mode="datagrid:footer-value" match="@*">
		<xsl:param name="rows" select="node-expected"/>
		<xsl:param name="data" select="@attributes-expected"/>
		<xsl:variable name="value">
			<xsl:apply-templates mode="datagrid:aggregate" select=".">
				<xsl:with-param name="data" select="$rows/@*[name()=local-name(current())]"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:call-template name="format">
			<xsl:with-param name="value" select="$value"/>
			<xsl:with-param name="mask">
				<xsl:apply-templates mode="format-mask" select="."/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template mode="datagrid:aggregate" match="@*">
		<xsl:param name="data" select="node-expected"/>
		<xsl:value-of select="sum($data)"/>
	</xsl:template>

	<xsl:template mode="datagrid:aggregate" match="@*[contains(.,'-')]">
	</xsl:template>

	<xsl:template mode="datagrid:aggregate" match="@sd|@on|@comm_p|@wh|@qty_rcv|@lbl|@rdt|@po|@rcv|@rd">
	</xsl:template>

	<xsl:template mode="datagrid:aggregate" match="@upce">
		<xsl:param name="data" select="node-expected"/>
		<xsl:variable name="rows" select="$data/ancestor-or-self::*[1][@qtym and @amt]"/>
		<xsl:value-of select="sum($rows/@amt) div sum($rows/@qtym)"/>
	</xsl:template>

	<xsl:template mode="datagrid:aggregate" match="@ucos">
		<xsl:param name="data" select="node-expected"/>
		<xsl:variable name="rows" select="$data/ancestor-or-self::*[1][@qtym and @amt]"/>
		<xsl:value-of select="sum($rows/@tcos) div sum($rows/@qtym)"/>
	</xsl:template>

	<xsl:template mode="datagrid:aggregate" match="@pce">
		<xsl:param name="data" select="node-expected"/>
		<xsl:variable name="rows" select="$data/ancestor-or-self::*[1][@qtym and @qtym]"/>
		<xsl:value-of select="(sum($rows/@amt) - sum($rows/@amt_ad) - sum($rows/@pce_ad)) div sum($rows/@qtym)"/>
	</xsl:template>

</xsl:stylesheet>
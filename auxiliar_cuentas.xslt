<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:state="http://panax.io/state"
>
	<xsl:import href="detalle_movimientos_operativos.xslt"/>

	<xsl:template mode="bodies" match="@*">
		<xsl:variable name="rows" select="key('data',.)"/>
		<tbody class="table-group-divider">
			<tr class="header sticky">
				<th scope="row"></th>
				<th colspan="3">
					<strong>
						<xsl:value-of select="../@desc"/>
					</strong>
				</th>
				<th colspan="{count(key('mock',$data_node)[1]/@*[not(key('state:hidden',name()))])-4}" class="money">
					<strong>
						<xsl:call-template name="format">
							<xsl:with-param name="value" select="sum($rows/@Debit[.!='']|$rows/@Credit[.!=''])"/>
						</xsl:call-template>
					</strong>
				</th>
			</tr>
			<xsl:apply-templates mode="row" select="$rows"/>
		</tbody>
	</xsl:template>
</xsl:stylesheet>
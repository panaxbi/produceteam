<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:shell="http://panax.io/shell"
xmlns:state="http://panax.io/state"
xmlns:store="http://panax.io/store"
xmlns:filter="http://panax.io/state/filter"
xmlns:visible="http://panax.io/state/visible"
xmlns:env="http://panax.io/state/environment"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns:v="urn:schemas-microsoft-com:office:excel"
xmlns:xo="http://panax.io/xover"
exclude-result-prefixes="#default session sitemap shell"
>
	<xsl:import href="common.xslt"/>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="functions.xslt"/>

	<xsl:key name="dates" match="fechas/row/@key" use="'active'"/>
	<xsl:key name="filter" match="model/@filter:*" use="local-name()"/>

	<xsl:key name="state:hidden" match="@xo:*" use="name()"/>
	<xsl:key name="state:hidden" match="@state:*" use="name()"/>
	<xsl:key name="state:hidden" match="@xsi:*" use="name()"/>

	<xsl:key name="datatype" match="movimientos/row/@Description" use="'description'"/>
	<xsl:key name="datatype" match="movimientos/row/@AccountName" use="'description'"/>

	<xsl:key name="datatype" match="movimientos/row/@TransDate" use="'date'"/>
	<xsl:key name="datatype" match="movimientos/row/@PostDate" use="'date'"/>

	<xsl:key name="datatype" match="movimientos/row/@Debit" use="'money'"/>
	<xsl:key name="datatype" match="movimientos/row/@Credit" use="'money'"/>
	<xsl:key name="datatype" match="movimientos/row/@Balance" use="'money'"/>
	<xsl:key name="datatype" match="movimientos/row/@Amount" use="'money'"/>

	<xsl:key name="mock" match="//movimientos/row[@xsi:type]" use="name(..)"/>
	<xsl:key name="rows" match="//movimientos/row[not(@xsi:type)]" use="name(..)"/>
	<xsl:key name="facts" match="//movimientos/row/@*[.!='' and namespace-uri()='']" use="name()"/>

	<xsl:key name="groupBy" match="model/account/row/@desc" use="''"/>

	<xsl:key name="data" match="//movimientos/row/@Amount" use="../@Category"/>
	<xsl:key name="data" match="//movimientos/row/@Amount" use="../@Type"/>
	<xsl:key name="data" match="//movimientos/row/@Amount" use="concat(../@Type,':',../@Category)"/>
	<xsl:key name="data" match="//movimientos/row/@Amount" use="'*'"/>

	<xsl:template mode="week" match="fechas/row/@*">
		<xsl:value-of select="../@week"/>
	</xsl:template>

	<xsl:param name="data_node">'movimientos'</xsl:param>
	<xsl:param name="state:groupBy"></xsl:param>
	<xsl:param name="store:searchParams"></xsl:param>
	<xsl:param name="store:tag"></xsl:param>

	<xsl:template match="/">
		<style>
			<![CDATA[
				table tbody td span.filterable { cursor: pointer }
				table tbody td span.groupable { cursor: pointer }

				table .sortable { cursor: pointer }
				table .groupable { cursor: pointer }
				
				table thead {
					text-wrap: nowrap;
				}
				
				table tfoot .money
				, table tbody .money
				, table tbody .number
				, table tfoot .number
				{
					text-align: end;
				}
				
				td[xo-slot=amt],td[xo-slot=qtym],td[xo-slot=qtys],td[xo-slot=qty_rcv],td[xo-slot=trb],td[xo-slot=upce] {
					text-align: end;
				}
				
				tfoot {
					font-weight: 900;
				}
				
				:root {
					--sticky-top: 34px;
				}
				
				[xo-source="#balance_operativo"] tbody [scope=row] {
					background-color: #fc0;
					font-weight: bolder;
				}
				
				[xo-source="#balance_operativo"] a {
					text-decoration: none;
					color: inherit;
					cursor: pointer;
				}
			]]>
		</style>
		<main xmlns="http://www.w3.org/1999/xhtml">
			<table class="table table-hover w-50">
				<colgroup>
					<col width="150"></col>
					<col width="100"></col>
					<col width="100"></col>
					<col width="100"></col>
				</colgroup>
				<thead class="freeze">
					<tr>
						<th colspan="4" class="text-center" style="border-block: 1pt solid black;">
							<strong>COMPARATIVA INGRESOS VS GASTOS OPERATIVOS</strong>
							<hr style="width: 60%; margin: auto; margin-block: .3rem;"/>
							<label>
								<xsl:value-of select="//@state:fecha_inicio"/> al <xsl:value-of select="//@state:fecha_fin"/>
							</label>
						</th>
					</tr>
					<tr class="text-center">
						<th></th>
						<th scope="col" class="sortable">Income</th>
						<th scope="col" class="sortable">Expense</th>
						<th scope="col" class="sortable">Difference</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates mode="row" select="key('groupBy','')"/>
				</tbody>
				<tfoot>
					<tr>
						<xsl:variable name="income" select="sum(key('data','I'))"/>
						<xsl:variable name="expense" select="sum(key('data','E'))"/>
						<xsl:variable name="balance" select="sum(key('data','*'))"/>

						<xsl:variable name="class_balance">
							<xsl:choose>
								<xsl:when test="$balance &gt; 0">danger</xsl:when>
								<xsl:when test="$balance &lt; 0">success</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<th scope="row">
							<strong>TOTALS</strong>
						</th>
						<td class="money">
							<xsl:call-template name="format">
								<xsl:with-param name="value" select="$income"></xsl:with-param>
								<xsl:with-param name="mask">$###,##0;$-###,##0</xsl:with-param>
							</xsl:call-template>
						</td>
						<td class="money">
							<xsl:call-template name="format">
								<xsl:with-param name="value" select="$expense"></xsl:with-param>
								<xsl:with-param name="mask">$###,##0;$-###,##0</xsl:with-param>
							</xsl:call-template>
						</td>
						<td class="money table-{$class_balance}">
							<xsl:call-template name="format">
								<xsl:with-param name="value" select="$balance"></xsl:with-param>
								<xsl:with-param name="mask">$###,##0;$-###,##0</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
				</tfoot>
			</table>
		</main>
	</xsl:template>

	<xsl:template mode="row" match="@*">
		<xsl:variable name="income" select="sum(key('data',concat('I:',.)))"/>
		<xsl:variable name="expense" select="sum(key('data',concat('E:',.)))"/>
		<xsl:variable name="balance" select="sum(key('data',.))"/>

		<xsl:variable name="class_balance">
			<xsl:choose>
				<xsl:when test="$balance &gt; 0">danger</xsl:when>
				<xsl:when test="$balance &lt; 0">success</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<th scope="row">
				Total <xsl:value-of select="."/>
			</th>
			<td class="money">
				<a href="?value={$income}#detalle_ingresos_operativos?@fecha_inicio={//fechas/@state:fecha_inicio}&amp;@fecha_fin={//fechas/@state:fecha_fin}&amp;{$store:searchParams}&amp;@classification={../@key}">
					<xsl:call-template name="format">
						<xsl:with-param name="value" select="$income"></xsl:with-param>
						<xsl:with-param name="mask">$###,##0;$-###,##0</xsl:with-param>
					</xsl:call-template>
				</a>
			</td>
			<td class="money">
				<a href="?value={$expense}#detalle_gastos_operativos?@fecha_inicio={//fechas/@state:fecha_inicio}&amp;@fecha_fin={//fechas/@state:fecha_fin}&amp;{$store:searchParams}&amp;@classification={../@key}">
					<xsl:call-template name="format">
						<xsl:with-param name="value" select="$expense"></xsl:with-param>
						<xsl:with-param name="mask">$###,##0;$-###,##0</xsl:with-param>
					</xsl:call-template>
				</a>
			</td>
			<td class="money table-{$class_balance}">
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="$balance"></xsl:with-param>
					<xsl:with-param name="mask">$###,##0;$-###,##0</xsl:with-param>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
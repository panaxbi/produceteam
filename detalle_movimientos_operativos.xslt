<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:session="http://panax.io/session"
xmlns:data="http://panax.io/data"
xmlns:state="http://panax.io/state"
xmlns:filter="http://panax.io/state/filter"
xmlns:visible="http://panax.io/state/visible"
xmlns:env="http://panax.io/state/environment"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:datagrid="http://panaxbi.com/widget/datagrid"
xmlns:xo="http://panax.io/xover"
>
	<xsl:import href="common.xslt"/>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="widgets/datagrid.xslt"/>

	<xsl:key name="dates" match="fechas/row/@key" use="'active'"/>
	<xsl:key name="filter" match="@filter:*" use="local-name()"/>

	<xsl:key name="state:hidden" match="@xo:*" use="name()"/>
	<xsl:key name="state:hidden" match="@state:*" use="name()"/>
	<xsl:key name="state:hidden" match="@xsi:*" use="name()"/>

	<xsl:key name="data_type" match="movimientos//@Description" use="'description'"/>
	<xsl:key name="data_type" match="movimientos//@AccountName" use="'description'"/>

	<xsl:key name="data_type" match="movimientos//@TransDate" use="'date'"/>
	<xsl:key name="data_type" match="movimientos//@PostDate" use="'date'"/>

	<xsl:key name="data_type" match="movimientos//@Debit" use="'money'"/>
	<xsl:key name="data_type" match="movimientos//@Credit" use="'money'"/>
	<xsl:key name="data_type" match="movimientos//@Balance" use="'money'"/>
	<xsl:key name="data_type" match="movimientos//@Amount" use="'money'"/>

	<xsl:key name="rows" match="//movimientos/row[not(@xsi:type)]" use="name(..)"/>
	<xsl:key name="facts" match="//movimientos/row/@*[.!='' and namespace-uri()='']" use="name()"/>

	<xsl:key name="data" match="//movimientos[not(row/@xsi:type)]/row" use="@Account"/>
	<xsl:key name="data" match="/model/movimientos[not(row/@xsi:type)]/row" use="'*'"/>

	<xsl:key name="data:group" match="model/account/row/@key" use="name(../..)"/>
	<xsl:key name="data:group" match="model/movimientos[not(row/@xsi:type)]" use="'*'"/>

	<xsl:key name="x-dimension" match="//movimientos[not(row/@xsi:type)]/@*[namespace-uri()='']" use="name(..)"/>
	<xsl:key name="y-dimension" match="//movimientos[not(row/@xsi:type)]/*" use="name(..)"/>
	
	<xsl:param name="data_node">'movimientos'</xsl:param>
	<xsl:param name="state:groupBy">*</xsl:param>

	<xsl:template match="/">
		<main xmlns="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates mode="datagrid:widget" select="model/movimientos"/>
		</main>
	</xsl:template>

	<xsl:template mode="datagrid:cell-content" match="@Amount">
		<a class="link" href="?value={.}#detalle_{translate(/*/@env:store,'#','')}?@fecha_inicio={//fechas/@state:fecha_inicio}&amp;@fecha_fin={//fechas/@state:fecha_fin}&amp;@account={../@Code}">
			<xsl:apply-templates select="."/>
		</a>
	</xsl:template>

	<xsl:template mode="bodies" match="@*">
		<xsl:variable name="rows" select="key('data',.)"/>
		<tbody class="table-group-divider">
			<tr class="header sticky">
				<th scope="row"></th>
				<th colspan="4">
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

	<xsl:template mode="bodies" match="model[@env:store='#ingresos_operativos' or @env:store='#gastos_operativos']//@*">
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
							<xsl:with-param name="value" select="sum($rows/@Amount[.!=''])"/>
						</xsl:call-template>
					</strong>
				</th>
			</tr>
			<xsl:apply-templates mode="row" select="$rows"/>
		</tbody>
	</xsl:template>

	<xsl:template mode="bodies" match="*">
		<xsl:variable name="rows" select="key('rows',name())"/>
		<tbody>
			<xsl:apply-templates mode="row" select="$rows"/>
		</tbody>
	</xsl:template>

	<xsl:template mode="colgroup" match="*">
		<colgroup>
			<col width="50"/>
			<xsl:apply-templates mode="colgroup-col" select="@*[not(key('state:hidden',name()))]"/>
		</colgroup>
	</xsl:template>

	<xsl:template mode="colgroup-col" match="@*">
		<xsl:comment>
			<xsl:value-of select="name()"/>
		</xsl:comment>
		<col width="100"/>
	</xsl:template>

	<xsl:template mode="colgroup-col" match="key('data_type','description')">
		<xsl:comment>
			<xsl:value-of select="name()"/>
		</xsl:comment>
		<col width="280"/>
	</xsl:template>

	<xsl:template mode="row" match="*">
		<tr>
			<th scope="row">
				<xsl:value-of select="position()"/>
			</th>
			<xsl:apply-templates mode="cell" select="@*[not(key('state:hidden',name()))]"/>
		</tr>
	</xsl:template>

	<xsl:template mode="header-row" match="*">
		<tr>
			<th scope="col">#</th>
			<xsl:apply-templates mode="header-cell" select="@*[not(key('state:hidden',name()))]"/>
		</tr>
	</xsl:template>

	<xsl:template mode="footer-row" match="*">
		<tr>
			<th></th>
			<xsl:apply-templates mode="footer-cell" select="@*[not(key('state:hidden',name()))]"/>
		</tr>
		<!--<tr>
			<th></th>
			<th colspan="6"></th>
			<th>
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="sum(//movimientos/row/@qtym)"/>
					<xsl:with-param name="mask">###,##0.00;-###,##0.00</xsl:with-param>
				</xsl:call-template>
			</th>
			<th>
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="sum(//movimientos/row/@qtys)"/>
					<xsl:with-param name="mask">###,##0.00;-###,##0.00</xsl:with-param>
				</xsl:call-template>
			</th>
			<th>
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="sum(//movimientos/row/@amt)"/>
				</xsl:call-template>
			</th>
			<th>
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="//movimientos/@state:avg_upce"/>
				</xsl:call-template>
			</th>
			<th>
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="sum(//movimientos/row/@amt_ad)"/>
				</xsl:call-template>
			</th>
			<th colspan="14">
				-->
		<!--<xsl:value-of select="avg(//movimientos/row/@upce)"/>-->
		<!--
			</th>
			<th>
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="sum(//movimientos/row/@qty_rcv)"/>
					<xsl:with-param name="mask">###,##0.00;-###,##0.00</xsl:with-param>
				</xsl:call-template>
			</th>
			<th>
				-->
		<!--<xsl:value-of select="avg(//movimientos/row/@upce)"/>-->
		<!--
			</th>
		</tr>-->
	</xsl:template>

	<xsl:template mode="cell-class" match="key('data_type', 'number')">
		<xsl:text/> number<xsl:text/>
	</xsl:template>

	<xsl:template mode="cell-class" match="key('data_type', 'money')">
		<xsl:text/> number<xsl:text/>
	</xsl:template>

	<xsl:template mode="cell" match="@*">
		<xsl:variable name="text-filter">
			<xsl:if test="key('filter',name())">bg-info</xsl:if>
		</xsl:variable>
		<xsl:variable name="classes">
			<xsl:apply-templates mode="cell-class" select="."/>
		</xsl:variable>
		<td class="text-nowrap {$text-filter} {$classes} cell domain-{name()}">
			<span class="filterable">
				<xsl:apply-templates select="."/>
			</span>
		</td>
	</xsl:template>

	<xsl:template mode="header-cell" match="@*">
		<th scope="col">
			<label class="sortable">
				<xsl:apply-templates mode="headerText" select="."/>
			</label>
		</th>
	</xsl:template>

	<xsl:template mode="header-cell" match="@Account">
		<th scope="col" class="groupable">
			<xsl:apply-templates mode="headerText" select="."/>
		</th>
	</xsl:template>

	<xsl:template mode="header-cell" match="@Type">
		<th scope="col" class="groupable">
			<xsl:apply-templates mode="headerText" select="."/>
		</th>
	</xsl:template>

	<xsl:template mode="footer-cell" match="@*" priority="-1">
		<td>
			<xsl:comment>
				<xsl:value-of select="name()"/>
			</xsl:comment>
		</td>
	</xsl:template>

	<xsl:template mode="footer-cell" match="key('data_type', 'number')">
		<td class="number">
			<xsl:call-template name="format">
				<xsl:with-param name="value">
					<xsl:apply-templates mode="aggregate" select="."/>
				</xsl:with-param>
				<xsl:with-param name="mask">###,##0.00;-###,##0.00</xsl:with-param>
			</xsl:call-template>
		</td>
	</xsl:template>

	<xsl:template mode="footer-cell" match="key('data_type', 'integer')">
		<td>
			<xsl:call-template name="format">
				<xsl:with-param name="value">
					<xsl:apply-templates mode="aggregate" select="."/>
				</xsl:with-param>
				<xsl:with-param name="mask">###,##0;-###,##0</xsl:with-param>
			</xsl:call-template>
		</td>
	</xsl:template>

	<xsl:template mode="footer-cell" match="key('data_type', 'money')">
		<td class="money">
			<xsl:call-template name="format">
				<xsl:with-param name="value">
					<xsl:apply-templates mode="aggregate" select="."/>
				</xsl:with-param>
				<xsl:with-param name="mask">$###,##0.00;-$###,##0.00</xsl:with-param>
			</xsl:call-template>
		</td>
	</xsl:template>

	<xsl:template mode="aggregate" match="@*">
		<xsl:value-of select="count(key('facts',name()))"/>
	</xsl:template>

	<xsl:template mode="aggregate" match="key('data_type', 'money')|key('data_type', 'integer')|key('data_type', 'number')">
		<xsl:value-of select="sum(key('facts',name()))"/>
	</xsl:template>

	<xsl:template mode="aggregate" match="@upce" priority="1">
		<xsl:value-of select="ancestor::movimientos[1]/@state:avg_upce"/>
	</xsl:template>

	<xsl:template mode="footer-cell" match="@ucos" priority="1">
		<td></td>
	</xsl:template>

	<xsl:template mode="footer-cell" match="key('data_type', 'avg')">
		<td>
			<xsl:call-template name="format">
				<xsl:with-param name="value" select="sum(key('facts',name()))"/>
				<xsl:with-param name="mask">$###,##0.00;-$###,##0.00</xsl:with-param>
			</xsl:call-template>
		</td>
	</xsl:template>

	<xsl:template match="@*[starts-with(.,'*')]">
		<xsl:value-of select="substring-after(.,'*')"/>
	</xsl:template>

	<xsl:template match="key('data_type', 'money')">
		<xsl:call-template name="format">
			<xsl:with-param name="value" select="."></xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="key('data_type', 'number')">
		<xsl:call-template name="format">
			<xsl:with-param name="value" select="number(.)"></xsl:with-param>
			<xsl:with-param name="mask">###,##0.00;-###,##0.00</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="key('data_type', 'integer')">
		<xsl:call-template name="format">
			<xsl:with-param name="value" select="number(.)"></xsl:with-param>
			<xsl:with-param name="mask">###,##0;-###,##0</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="key('data_type', 'date')">
		<xsl:value-of select="substring(.,1,4)"/>
		<xsl:text>-</xsl:text>
		<xsl:value-of select="substring(.,5,2)"/>
		<xsl:text>-</xsl:text>
		<xsl:value-of select="substring(.,7,2)"/>
	</xsl:template>
</xsl:stylesheet>
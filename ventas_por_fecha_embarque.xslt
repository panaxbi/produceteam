﻿<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:js="http://panax.io/xover/javascript"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:shell="http://panax.io/shell"
xmlns:state="http://panax.io/state"
xmlns:filter="http://panax.io/state/filter"
xmlns:visible="http://panax.io/state/visible"
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

	<xsl:key name="datatype" match="ventas/row/@od" use="'date'"/>
	<xsl:key name="datatype" match="ventas/row/@sd" use="'date'"/>
	<xsl:key name="datatype" match="ventas/row/@ivd" use="'date'"/>
	<xsl:key name="datatype" match="ventas/row/@pd" use="'date'"/>
	<xsl:key name="datatype" match="ventas/row/@lot_rd" use="'date'"/>

	<xsl:key name="datatype" match="ventas/row/@upce" use="'money'"/>

	<xsl:key name="datatype" match="ventas/row/@amt" use="'money'"/>
	<xsl:key name="datatype" match="ventas/row/@amt_ad" use="'number'"/>

	<xsl:key name="datatype" match="ventas/row/@qtym" use="'integer'"/>
	<xsl:key name="datatype" match="ventas/row/@qtys" use="'integer'"/>
	<xsl:key name="datatype" match="ventas/row/@qty_rcv" use="'integer'"/>

	<xsl:key name="facts" match="//ventas/row/@*" use="name()"/>

	<xsl:template mode="week" match="fechas/row/@*">
		<xsl:value-of select="../@week"/>
	</xsl:template>

	<xsl:template match="/">
		<main xmlns="http://www.w3.org/1999/xhtml">
			<style>
				<![CDATA[
        table td.freeze {
          background-color: white;
        }

        table thead.freeze > tr td, table thead.freeze > tr th {
          position: sticky;
        }

        table > thead.freeze > tr:nth-child(1) > td, table > thead.freeze > tr:nth-child(1) > th {
          top: 0px;
        }

        table > thead.freeze > tr:nth-child(2) > td, table > thead.freeze > tr:nth-child(2) > th {
          top: 20px;
        }

        table > thead.freeze > tr:nth-child(3) > td, table > thead.freeze > tr:nth-child(3) > th {
          top: 40px;
        }

        table > thead.freeze > tr:nth-child(4) > td, table > thead.freeze > tr:nth-child(4) > th {
          top: 60px;
        }

        table > thead.freeze > tr:nth-child(5) > td, table > thead.freeze > tr:nth-child(5) > th {
          top: 80px;
        }

        table tr.freeze td.freeze, table tr.freeze th.freeze {
          z-index: 911;
        }

        table tr.freeze td.freeze img, table tr.freeze th.freeze img {
          z-index: 912;
        }

        table thead.freeze tr {
          background-color: white;
        }
		
		.sticky {
			position: sticky;
			top: var(--sticky-top, 45px);
			background-color: var(--sticky-bg-color, white);
		}
		
		div:has(>table) {
			width: fit-content;
		}
			
		table {
			margin-right: 50px;
			max-width: max-content;
		}
			]]>
			</style>
			<style>
				<![CDATA[
				table tbody td span.filterable { cursor: pointer }
				table .sortable { cursor: pointer }
				
				table thead {
					text-wrap: nowrap;
				}
				
				td[xo-slot=amt],td[xo-slot=qtym],td[xo-slot=qtys],td[xo-slot=qty_rcv] {
					text-align: end;
				}
			]]>
			</style>
			<table class="table table-striped">
				<colgroup>
					<col width="50"/>
					<!-- #</th>-->
					<col width="280"/>
					<!-- Customer Name		</th>-->
					<col width="100"/>
					<!-- Ship Date			</th>-->
					<col width="100"/>
					<!-- Invoice Date		</th>-->
					<col width="100"/>
					<!-- Post Date			</th>-->
					<col width="100"/>
					<!-- Order No.			</th>-->
					<col width="100"/>
					<!-- Ship To (Location)	</th>-->
					<col width="100"/>
					<!-- Qty (UOM)			</th>-->
					<col width="100"/>
					<!-- Qty (UOS)			</th>-->
					<col width="100"/>
					<!-- Amount Invoiced		</th>-->
					<col width="100"/>
					<!-- Unit Price			</th>-->
					<col width="100"/>
					<!-- Amount Adjusted		</th>-->
					<col width="100"/>
					<!-- Commodity Name		</th>-->
					<col width="100"/>
					<!-- Variety Name		</th>-->
					<col width="100"/>
					<!-- Pack Style Name		</th>-->
					<col width="100"/>
					<!-- Size Name			</th>-->
					<col width="100"/>
					<!-- Label Code			</th>-->
					<col width="100"/>
					<!-- Grower Code			</th>-->
					<col width="100"/>
					<!-- Grower Name			</th>-->
					<col width="100"/>
					<!-- PO					</th>-->
					<col width="100"/>
					<!-- Order Status		</th>-->
					<col width="100"/>
					<!-- Salesperson Code	</th>-->
					<col width="100"/>
					<!-- Warehouse Code		</th>-->
					<col width="100"/>
					<!-- Ship Terms Name		</th>-->
					<col width="100"/>
					<!-- Grower Lot			</th>-->
					<col width="100"/>
					<!-- Lot Received Date	</th>-->
					<col width="100"/>
					<!-- Qty Received		</th>-->
					<col width="100"/>
					<!-- Trouble No			</th>-->
				</colgroup>
				<thead class="freeze">
					<xsl:apply-templates mode="header-row" select="//ventas/row[1]"/>
				</thead>
				<tbody>
					<xsl:apply-templates mode="row" select="//ventas/row"/>
				</tbody>
				<tfoot>
					<xsl:apply-templates mode="footer-row" select="//ventas/row[1]"/>
				</tfoot>
			</table>
		</main>
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
			<th>#</th>
			<xsl:apply-templates mode="footer-cell" select="@*[not(key('state:hidden',name()))]"/>
		</tr>
		<!--<tr>
			<th></th>
			<th colspan="6"></th>
			<th>
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="sum(//ventas/row/@qtym)"/>
					<xsl:with-param name="mask">###,##0.00;-###,##0.00</xsl:with-param>
				</xsl:call-template>
			</th>
			<th>
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="sum(//ventas/row/@qtys)"/>
					<xsl:with-param name="mask">###,##0.00;-###,##0.00</xsl:with-param>
				</xsl:call-template>
			</th>
			<th>
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="sum(//ventas/row/@amt)"/>
				</xsl:call-template>
			</th>
			<th>
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="//ventas/@state:avg_upce"/>
				</xsl:call-template>
			</th>
			<th>
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="sum(//ventas/row/@amt_ad)"/>
				</xsl:call-template>
			</th>
			<th colspan="14">
				--><!--<xsl:value-of select="avg(//ventas/row/@upce)"/>--><!--
			</th>
			<th>
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="sum(//ventas/row/@qty_rcv)"/>
					<xsl:with-param name="mask">###,##0.00;-###,##0.00</xsl:with-param>
				</xsl:call-template>
			</th>
			<th>
				--><!--<xsl:value-of select="avg(//ventas/row/@upce)"/>--><!--
			</th>
		</tr>-->
	</xsl:template>

	<xsl:template mode="cell" match="@*">
		<xsl:variable name="text-filter">
			<xsl:if test="key('filter',name())">bg-info</xsl:if>
		</xsl:variable>
		<td class="text-nowrap {$text-filter}">
			<span class="filterable">
				<xsl:apply-templates select="."/>
			</span>
		</td>
	</xsl:template>

	<xsl:template mode="header-cell" match="@*">
		<th scope="col" class="sortable">
			<xsl:apply-templates mode="headerText" select="."/>
		</th>
	</xsl:template>

	<xsl:template mode="footer-cell" match="@*" priority="-1">
		<th>
			<xsl:comment>
				<xsl:value-of select="name()"/>
			</xsl:comment>
		</th>
	</xsl:template>

	<xsl:template mode="footer-cell" match="key('datatype', 'integer')|key('datatype', 'number')">
		<th>
			<xsl:call-template name="format">
				<xsl:with-param name="value">
					<xsl:apply-templates mode="aggregate" select="."/>
				</xsl:with-param>
				<xsl:with-param name="mask">###,##0.00;-###,##0.00</xsl:with-param>
			</xsl:call-template>
		</th>
	</xsl:template>

	<xsl:template mode="footer-cell" match="key('datatype', 'money')">
		<th>
			<xsl:call-template name="format">
				<xsl:with-param name="value">
					<xsl:apply-templates mode="aggregate" select="."/>
				</xsl:with-param>
				<xsl:with-param name="mask">$###,##0.00;-$###,##0.00</xsl:with-param>
			</xsl:call-template>
		</th>
	</xsl:template>

	<xsl:template mode="aggregate" match="@*">
		<xsl:value-of select="count(key('facts',name()))"/>
	</xsl:template>

	<xsl:template mode="aggregate" match="key('datatype', 'money')|key('datatype', 'integer')|key('datatype', 'number')">
		<xsl:value-of select="sum(key('facts',name()))"/>
	</xsl:template>

	<xsl:template mode="aggregate" match="@upce" priority="1">
		<xsl:value-of select="ancestor::ventas[1]/@state:avg_upce"/>
	</xsl:template>

	<xsl:template mode="footer-cell" match="key('datatype', 'avg')">
		<th>
			<xsl:call-template name="format">
				<xsl:with-param name="value" select="sum(key('facts',name()))"/>
				<xsl:with-param name="mask">$###,##0.00;-$###,##0.00</xsl:with-param>
			</xsl:call-template>
		</th>
	</xsl:template>

	<xsl:template match="@*[starts-with(.,'*')]">
		<xsl:value-of select="substring-after(.,'*')"/>
	</xsl:template>

	<xsl:template match="key('datatype', 'money')">
		<xsl:call-template name="format">
			<xsl:with-param name="value" select="."></xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="key('datatype', 'number')">
		<xsl:call-template name="format">
			<xsl:with-param name="value" select="number(.)"></xsl:with-param>
			<xsl:with-param name="mask">###,##0.00;-###,##0.00</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="key('datatype', 'integer')">
		<xsl:call-template name="format">
			<xsl:with-param name="value" select="number(.)"></xsl:with-param>
			<xsl:with-param name="mask">###,##0;-###,##0</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="key('datatype', 'date')">
		<xsl:value-of select="substring(.,1,4)"/>
		<xsl:text>-</xsl:text>
		<xsl:value-of select="substring(.,5,2)"/>
		<xsl:text>-</xsl:text>
		<xsl:value-of select="substring(.,7,2)"/>
	</xsl:template>
</xsl:stylesheet>
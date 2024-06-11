<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:data="http://panax.io/data"
xmlns:shell="http://panax.io/shell"
xmlns:state="http://panax.io/state"
xmlns:filter="http://panax.io/state/filter"
xmlns:visible="http://panax.io/state/visible"
xmlns:env="http://panax.io/state/environment"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:datagrid="http://panaxbi.com/widget/datagrid"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns:v="urn:schemas-microsoft-com:office:excel"
xmlns:xo="http://panax.io/xover"
exclude-result-prefixes="#default session sitemap shell"
>
	<xsl:import href="../functions.xslt"/>
	<xsl:key name="state:hidden" match="@*[namespace-uri()!='']" use="name()"/>

	<xsl:key name="data:filter" match="@filter:*" use="local-name()"/>
	<xsl:key name="data_type" match="node-expected/@*" use="'type'"/>

	<xsl:key name="facts" match="node-expected" use="name()"/>
	<xsl:key name="data" match="node-expected" use="concat(generate-id(),'::',name())"/>

	<xsl:key name="data:group" match="node-expected/@key" use="name(../..)"/>
	<xsl:key name="data:group" match="node-expected" use="'*'"/>

	<xsl:key name="x-dimension" match="node-expected/@*[namespace-uri()='']" use="name(..)"/>
	<xsl:key name="y-dimension" match="node-expected/*" use="name(..)"/>

	<xsl:param name="state:groupBy">*</xsl:param>

	<xsl:template mode="datagrid:widget" match="*|@*">
		<xsl:param name="x-dimensions" select="key('x-dimension', name(ancestor-or-self::*[1]))"/>
		<xsl:param name="y-dimensions" select="key('y-dimension', name(ancestor-or-self::*[1]))"/>
		<xsl:variable name="data" select="key('data',node)"/>
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
					font-weight: bolder;
				}
				
				:root {
					--sticky-top: 34px;
				}
			]]>
		</style>
		<table class="table table-striped selection-enabled">
			<xsl:apply-templates mode="datagrid:colgroup" select=".">
				<xsl:with-param name="x-dimension" select="$x-dimensions"/>
			</xsl:apply-templates>
			<thead class="freeze">
				<xsl:apply-templates mode="datagrid:header-row" select=".">
					<xsl:with-param name="x-dimension" select="$x-dimensions"/>
				</xsl:apply-templates>
			</thead>
			<xsl:apply-templates mode="datagrid:tbody" select="key('data:group',$state:groupBy)">
				<xsl:with-param name="x-dimension" select="$x-dimensions"/>
				<xsl:with-param name="y-dimension" select="$y-dimensions"/>
			</xsl:apply-templates>
			<tfoot>
				<xsl:apply-templates mode="datagrid:footer-row" select=".">
					<xsl:with-param name="x-dimension" select="$x-dimensions"/>
				</xsl:apply-templates>
			</tfoot>
		</table>
	</xsl:template>

	<xsl:template mode="datagrid:tbody" match="*|@*">
		<xsl:param name="dimensions" select="."/>
		<xsl:param name="x-dimension" select="node-expected"/>
		<xsl:param name="y-dimension" select="node-expected"/>

		<xsl:variable name="key">
			<xsl:choose>
				<xsl:when test="self::*">*</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="rows" select="key('data',$key)"/>
		<tbody class="table-group-divider">
			<xsl:apply-templates mode="datagrid:tbody-header" select=".">
				<xsl:with-param name="x-dimension" select="$x-dimension"/>
				<xsl:with-param name="rows" select="$rows"/>
			</xsl:apply-templates>
			<xsl:apply-templates mode="datagrid:row" select="$rows">
				<xsl:with-param name="x-dimension" select="$x-dimension"/>
			</xsl:apply-templates>
			<xsl:apply-templates mode="datagrid:tbody-footer" select=".">
				<xsl:with-param name="x-dimension" select="$x-dimension"/>
				<xsl:with-param name="rows" select="$rows"/>
			</xsl:apply-templates>
		</tbody>
	</xsl:template>

	<xsl:template mode="datagrid:tbody-header" match="*|@*"/>
	<xsl:template mode="datagrid:tbody-footer" match="*|@*"/>

	<xsl:template mode="datagrid:colgroup" match="*">
		<xsl:param name="x-dimension" select="@*[not(key('state:hidden',name()))]"/>
		<colgroup>
			<col width="50"/>
			<xsl:apply-templates mode="datagrid:colgroup-col" select="$x-dimension"/>
		</colgroup>
	</xsl:template>

	<xsl:template mode="datagrid:colgroup-col" match="@*">
		<xsl:comment>
			<xsl:value-of select="name()"/>
		</xsl:comment>
		<col width="100"/>
	</xsl:template>

	<xsl:template mode="datagrid:colgroup-col" match="key('data_type','description')">
		<xsl:comment>
			<xsl:value-of select="name()"/>
		</xsl:comment>
		<col width="280"/>
	</xsl:template>

	<xsl:template mode="datagrid:row" match="*">
		<xsl:param name="x-dimension" select="@*[not(key('state:hidden',name()))]"/>
		<tr>
			<th scope="row">
				<xsl:value-of select="position()"/>
			</th>
			<xsl:apply-templates mode="datagrid:cell" select="$x-dimension">
				<xsl:with-param name="row" select="."/>
			</xsl:apply-templates>
		</tr>
	</xsl:template>

	<xsl:template mode="datagrid:header-row" match="*">
		<xsl:param name="x-dimension" select="node-expected"/>
		<tr>
			<th scope="col">#</th>
			<xsl:apply-templates mode="datagrid:header-cell" select="$x-dimension"/>
		</tr>
	</xsl:template>

	<xsl:template mode="datagrid:footer-row" match="*">
		<xsl:param name="x-dimension" select="node-expected"/>
		<tr>
			<th></th>
			<xsl:apply-templates mode="datagrid:footer-cell" select="$x-dimension"/>
		</tr>
	</xsl:template>

	<xsl:template mode="datagrid:cell-class" match="key('data_type', 'number')">
		<xsl:text/> number<xsl:text/>
	</xsl:template>

	<xsl:template mode="datagrid:cell-class" match="key('data_type', 'money')">
		<xsl:text/> money<xsl:text/>
	</xsl:template>

	<xsl:template mode="datagrid:cell" match="@*">
		<xsl:param name="row" select="ancestor-or-self::*[1]"/>
		<xsl:variable name="cell" select="$row/@*[name()=name(current())]"/>
		<xsl:variable name="text-filter">
			<xsl:if test="key('data:filter',name())">bg-info</xsl:if>
		</xsl:variable>
		<xsl:variable name="classes">
			<xsl:apply-templates mode="datagrid:cell-class" select="."/>
		</xsl:variable>
		<td xo-scope="inherit" xo-slot="{name()}" class="text-nowrap {$text-filter} {$classes} cell domain-{name()}">
			<span class="filterable">
				<xsl:apply-templates select="$cell"/>
			</span>
		</td>
	</xsl:template>

	<xsl:template mode="datagrid:header-cell" match="@*">
		<xsl:variable name="classes">
			<xsl:apply-templates mode="datagrid:header-cell-classes" select="."/>
		</xsl:variable>
		<th scope="col">
			<div class="d-flex flex-nowrap">
				<xsl:apply-templates mode="datagrid:header-cell-options" select="."/>
				<label class="{$classes}">
					<xsl:apply-templates mode="datagrid:header-cell-content" select="."/>
				</label>
				<xsl:apply-templates mode="datagrid:header-cell-icons" select="."/>
			</div>
		</th>
	</xsl:template>

	<xsl:template mode="datagrid:header-cell-options" match="@*">
		<div class="dropdown">
			<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-down-square dropdown-toggle" data-bs-toggle="dropdown" viewBox="0 0 16 16">
				<path d="M3.626 6.832A.5.5 0 0 1 4 6h8a.5.5 0 0 1 .374.832l-4 4.5a.5.5 0 0 1-.748 0z"/>
				<path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2zm15 0a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1z"/>
			</svg>
			<ul class="dropdown-menu">
				<li>
					<a class="dropdown-item" href="#">Action</a>
				</li>
				<li>
					<a class="dropdown-item" href="#">Another action</a>
				</li>
				<li>
					<a class="dropdown-item" href="#">Something else here</a>
				</li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template mode="datagrid:headerText" match="@*">
		<xsl:apply-templates mode="headerText"/>
	</xsl:template>

	<xsl:template mode="datagrid:header-cell-options" match="@*">
	</xsl:template>

	<xsl:template mode="datagrid:header-cell-content" match="@*">
		<xsl:apply-templates mode="datagrid:headerText" select="."/>
	</xsl:template>

	<xsl:template mode="datagrid:header-cell-classes" match="@*">
		<xsl:text/>sortable<xsl:text/>
	</xsl:template>

	<xsl:template mode="datagrid:header-cell-classes" match="@Account|@acc|@Type">
		<xsl:text/>groupable<xsl:text/>
	</xsl:template>

	<xsl:template mode="datagrid:header-cell-icons" match="@*">
	</xsl:template>

	<xsl:template mode="datagrid:header-cell-icons" match="@Account">
		<xsl:if test="$state:groupBy='account'">
			<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-stack ms-2" viewBox="0 0 16 16">
				<path d="m14.12 10.163 1.715.858c.22.11.22.424 0 .534L8.267 15.34a.6.6 0 0 1-.534 0L.165 11.555a.299.299 0 0 1 0-.534l1.716-.858 5.317 2.659c.505.252 1.1.252 1.604 0l5.317-2.66zM7.733.063a.6.6 0 0 1 .534 0l7.568 3.784a.3.3 0 0 1 0 .535L8.267 8.165a.6.6 0 0 1-.534 0L.165 4.382a.299.299 0 0 1 0-.535z"/>
				<path d="m14.12 6.576 1.715.858c.22.11.22.424 0 .534l-7.568 3.784a.6.6 0 0 1-.534 0L.165 7.968a.299.299 0 0 1 0-.534l1.716-.858 5.317 2.659c.505.252 1.1.252 1.604 0z"/>
			</svg>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="datagrid:footer-cell" match="@*" priority="-1">
		<td>
			<xsl:comment>
				<xsl:value-of select="name()"/>
			</xsl:comment>
		</td>
	</xsl:template>

	<xsl:template mode="datagrid:footer-cell" match="key('data_type', 'number')">
		<td class="number">
			<xsl:call-template name="format">
				<xsl:with-param name="value">
					<xsl:apply-templates mode="datagrid:aggregate" select="."/>
				</xsl:with-param>
				<xsl:with-param name="mask">###,##0.00;-###,##0.00</xsl:with-param>
			</xsl:call-template>
		</td>
	</xsl:template>

	<xsl:template mode="datagrid:footer-cell" match="key('data_type', 'integer')">
		<td>
			<xsl:call-template name="format">
				<xsl:with-param name="value">
					<xsl:apply-templates mode="datagrid:aggregate" select="."/>
				</xsl:with-param>
				<xsl:with-param name="mask">###,##0;-###,##0</xsl:with-param>
			</xsl:call-template>
		</td>
	</xsl:template>

	<xsl:template mode="datagrid:footer-cell" match="key('data_type', 'money')">
		<td class="money">
			<xsl:call-template name="format">
				<xsl:with-param name="value">
					<xsl:apply-templates mode="datagrid:aggregate" select="."/>
				</xsl:with-param>
				<xsl:with-param name="mask">$###,##0.00;-$###,##0.00</xsl:with-param>
			</xsl:call-template>
		</td>
	</xsl:template>

	<xsl:template mode="datagrid:aggregate" match="@*">
		<xsl:value-of select="count(key('facts',name()))"/>
	</xsl:template>

	<xsl:template mode="datagrid:aggregate" match="key('data_type', 'money')|key('data_type', 'integer')|key('data_type', 'number')">
		<xsl:value-of select="sum(key('facts',name()))"/>
	</xsl:template>

	<xsl:template mode="datagrid:aggregate" match="@upce" priority="1">
		<xsl:value-of select="ancestor::movimientos[1]/@state:avg_upce"/>
	</xsl:template>

	<xsl:template mode="datagrid:footer-cell" match="@ucos" priority="1">
		<td></td>
	</xsl:template>

	<xsl:template mode="datagrid:footer-cell" match="key('data_type', 'avg')">
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

	<xsl:template mode="datagrid:tbody-header" match="@*">
		<xsl:param name="dimensions" select="."/>
		<xsl:param name="x-dimension" select="node-expected"/>
		<xsl:param name="y-dimension" select="node-expected"/>
		<xsl:param name="rows" select="key('data',.)"/>
		<tr class="header sticky">
			<th scope="row"></th>
			<th colspan="{count($x-dimension)-1}">
				<strong>
					<xsl:value-of select="../@desc"/>
				</strong>
			</th>
			<th class="money">
				<strong>
					<xsl:call-template name="format">
						<xsl:with-param name="value" select="sum($rows/@Amount[.!=''])"/>
					</xsl:call-template>
				</strong>
			</th>
		</tr>
	</xsl:template>
</xsl:stylesheet>
<xsl:stylesheet version="1.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:data="http://panax.io/data"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:state="http://panax.io/state"
xmlns:group="http://panax.io/state/group"
xmlns:filter="http://panax.io/state/filter"
xmlns:visible="http://panax.io/state/visible"
xmlns:datagrid="http://widgets.panaxbi.com/datagrid"
xmlns:total="http://panax.io/total"
xmlns:xo="http://panax.io/xover"
>
	<xsl:import href="common.xslt"/>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="functions.xslt"/>
	<xsl:import href="datagrid.xslt"/>

	<xsl:key name="dates" match="fechas/row/@key" use="'active'"/>
	<xsl:key name="filter" match="@filter:*" use="local-name()"/>

	<xsl:key name="state:hidden" match="@xo:*" use="name()"/>
	<xsl:key name="state:hidden" match="@state:*" use="name()"/>

	<xsl:key name="rows" match="//ventas/row[not(@xsi:type)]" use="name(..)"/>

	<xsl:key name="data" match="/model/ventas[not(row/@xsi:type)]/row" use="'*'"/>

	<xsl:key name="data:group" match="model/ventas[not(@group:*)][row]" use="'*'"/>

	<xsl:key name="x-dimension" match="//ventas[not(row/@xsi:type)]/@*[namespace-uri()='']" use="name(..)"/>
	<xsl:key name="y-dimension" match="//ventas[not(row/@xsi:type)]/*" use="name(..)"/>

	<xsl:param name="data_node">'ventas'</xsl:param>
	<xsl:param name="state:groupBy">*</xsl:param>

	<xsl:template match="/">
		<main xmlns="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates mode="datagrid:widget" select="model/ventas"/>
		</main>
	</xsl:template>

	<xsl:key name="commodity" match="model/commodity/row/@desc" use="../@id"/>
	<xsl:key name="variety" match="model/variedad/row/@desc" use="../@id"/>

	<xsl:template match="@total:upce">
		<xsl:param name="data" select="node-expected"/>
		<xsl:variable name="rows" select="$data/ancestor-or-self::*[1][@rqty and @r_amt]"/>
		<xsl:value-of select="sum($rows/@r_amt) div sum($rows/@rqty)"/>
	</xsl:template>

	<xsl:key name="section" match="ventas/@rd" use="'po'"/>
	<xsl:key name="section" match="ventas/@po" use="'po'"/>
	<xsl:key name="section" match="ventas/@vek" use="'po'"/>
	<xsl:key name="section" match="ventas/@ve" use="'po'"/>
	<xsl:key name="section" match="ventas/@nm" use="'po'"/>
	<xsl:key name="section" match="ventas/@cmd" use="'product'"/>
	<xsl:key name="section" match="ventas/@var" use="'product'"/>
	<xsl:key name="section" match="ventas/@sz" use="'product'"/>
	<xsl:key name="section" match="ventas/@lc" use="'product'"/>
	<xsl:key name="section" match="ventas/@qtyr" use="'product'"/>
	<xsl:key name="section" match="ventas/@up" use="'product'"/>
	<xsl:key name="section" match="ventas/@prd" use="'product'"/>
	<xsl:key name="section" match="ventas/@dc_a" use="'product_adjustments'"/>
	<xsl:key name="section" match="ventas/@trb_a" use="'product_adjustments'"/>
	<xsl:key name="section" match="ventas/@adj_t" use="'product_adjustments'"/>
	<xsl:key name="section" match="ventas/@fr_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@us_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@mx_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@insp_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@rp_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@crt_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@ioes_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@fe_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@ios_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@ms_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@com_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@ls_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@cpe_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@cgs_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@rntp_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@co_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@usf_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@sli_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@frj_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@tr_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@fr2_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@db_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@cp_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@la_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@dbntp_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@dms_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@srcc_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@io_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@rps_c" use="'charges'"/>
	<xsl:key name="section" match="ventas/@chr_t" use="'charges'"/>
	<xsl:key name="section" match="ventas/@nt_p" use="'other'"/>
	<xsl:key name="section" match="ventas/@gr_r" use="'other'"/>
	<xsl:key name="section" match="ventas/@dc_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@trb_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@fr_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@ac_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@mc_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@insp_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@rp_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@crt_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@ioes_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@fe_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@ios_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@ms_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@com_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@ls_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@cpe_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@cgs_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@rntp_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@co_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@usf_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@sli_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@frj_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@tr_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@fr2_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@db_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@cp_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@la_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@dbntp_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@dms_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@srcc_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@io_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@rps_e" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@exp_t" use="'absorbed_expenses'"/>
	<xsl:key name="section" match="ventas/@ns" use="'profit_loss'"/>
	<xsl:key name="section" match="ventas/@cos_t" use="'profit_loss'"/>
	<xsl:key name="section" match="ventas/@prf_l" use="'profit_loss'"/>
	<xsl:key name="section" match="ventas/@un_p" use="'profit_loss'"/>

	<xsl:template mode="datagrid:header-row" match="*">
		<xsl:param name="x-dimension" select="node-expected"/>
		<xsl:param name="y-dimension" select="node-expected"/>
		<tr style="text-align: center;">
			<th scope="col">
			</th>
			<th scope="col" class="po" colspan="{count(key('section','po'))}"></th>
			<th scope="col" class="product" colspan="{count(key('section','product'))}">
				PRODUCT
			</th>
			<th scope="col" class="product_adjustments" colspan="{count(key('section','product_adjustments'))}">
				PRODUCT ADJUSTMENTS
			</th>
			<th scope="col" class="charges" colspan="{count(key('section','charges'))}">
				CHARGES
			</th>
			<th scope="col" class="other" colspan="{count(key('section','other'))}"></th>
			<th scope="col" class="absorbed_expenses" colspan="{count(key('section','absorbed_expenses'))}">
				ABSORBED EXPENSES
			</th>
			<th scope="col" class="profit_loss" colspan="{count(key('section','profit_loss'))}">
				PROFIT &amp; LOSS
			</th>
		</tr>
		<xsl:if test="$y-dimension">
			<tr>
				<th scope="col">
					<div class="dropdown">
						<button class="btn btn-secondary dropdown-toggle btn-sm" type="button" data-bs-toggle="dropdown" aria-expanded="false">
							<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="currentColor" class="bi bi-gear-fill" viewBox="0 0 16 16">
								<path d="M9.405 1.05c-.413-1.4-2.397-1.4-2.81 0l-.1.34a1.464 1.464 0 0 1-2.105.872l-.31-.17c-1.283-.698-2.686.705-1.987 1.987l.169.311c.446.82.023 1.841-.872 2.105l-.34.1c-1.4.413-1.4 2.397 0 2.81l.34.1a1.464 1.464 0 0 1 .872 2.105l-.17.31c-.698 1.283.705 2.686 1.987 1.987l.311-.169a1.464 1.464 0 0 1 2.105.872l.1.34c.413 1.4 2.397 1.4 2.81 0l.1-.34a1.464 1.464 0 0 1 2.105-.872l.31.17c1.283.698 2.686-.705 1.987-1.987l-.169-.311a1.464 1.464 0 0 1 .872-2.105l.34-.1c1.4-.413 1.4-2.397 0-2.81l-.34-.1a1.464 1.464 0 0 1-.872-2.105l.17-.31c.698-1.283-.705-2.686-1.987-1.987l-.311.169a1.464 1.464 0 0 1-2.105-.872zM8 10.93a2.929 2.929 0 1 1 0-5.86 2.929 2.929 0 0 1 0 5.858z"/>
							</svg>
						</button>
						<ul class="dropdown-menu">
							<xsl:if test="$state:hide_empty!=''">
								<li>
									<a class="dropdown-item" href="#" onclick="xo.state.hide_empty = !xo.state.hide_empty">
										<xsl:choose>
											<xsl:when test="$state:hide_empty='true'">Mostrar registros en ceros</xsl:when>
											<xsl:otherwise>Ocultar registros en ceros</xsl:otherwise>
										</xsl:choose>
									</a>
								</li>
							</xsl:if>
							<xsl:if test="//@group:*[1]|//@filter:*[1]">
								<li>
									<a class="dropdown-item" href="#" onclick="xo.stores.active.select(`//@group:*|//@filter:*`).remove()">Borrar filtros y agrupaciones</a>
								</li>
							</xsl:if>
							<xsl:if test="//@group:*[1]">
								<li>
									<a class="dropdown-item" href="#" onclick="xo.state.collapse_all = true">
										<xsl:choose>
											<xsl:when test="$state:collapse_all = 'true'">
												<xsl:attribute name="onclick">xo.state.collapse_all = false</xsl:attribute>
												Expandir todo
											</xsl:when>
											<xsl:otherwise>Colapsar todo</xsl:otherwise>
										</xsl:choose>
									</a>
								</li>
							</xsl:if>
						</ul>
					</div>
				</th>
				<xsl:apply-templates mode="datagrid:header-cell" select="$x-dimension">
					<xsl:sort select="namespace-uri()" order="descending"/>
				</xsl:apply-templates>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="datagrid:widget" match="ventas[@filter:po]">
		<div xo-stylesheet="liquidation_report.xslt" xo-source="active">
		</div>	
	</xsl:template>
</xsl:stylesheet>
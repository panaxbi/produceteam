﻿<xsl:stylesheet version="1.0"
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

	<xsl:key name="data_type" match="@amt" use="'money'"/>

	<xsl:param name="data_node">'ventas'</xsl:param>
	<xsl:param name="state:groupBy">*</xsl:param>

	<xsl:template match="/">
		<main xmlns="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates mode="datagrid:widget" select="model/ventas">
				<xsl:with-param name="y-dimensions" select="model/ventas/row/row"/>
			</xsl:apply-templates>
		</main>
	</xsl:template>

	<xsl:template mode="datagrid:row" match="*">
		<xsl:param name="x-dimension" select="@*[not(key('state:hidden',name()))]"/>
		<xsl:param name="parent-groups" select="node-expected"/>
		<tr>
			<th scope="row">
				<xsl:value-of select="position()"/>
			</th>
			<xsl:apply-templates mode="datagrid:cell" select="$x-dimension">
				<xsl:sort select="namespace-uri()" order="descending"/>
				<xsl:with-param name="row" select="ancestor-or-self::row"/>
			</xsl:apply-templates>
		</tr>
	</xsl:template>

	<xsl:key name="commodity" match="model/commodity/row/@desc" use="../@id"/>
	<xsl:key name="variety" match="model/variedad/row/@desc" use="../@id"/>

	<xsl:template match="@total:upce">
		<xsl:param name="data" select="node-expected"/>
		<xsl:variable name="rows" select="$data/ancestor-or-self::*[1][@qtyr and @prd]"/>
		<xsl:value-of select="sum($rows/@prd) div sum($rows/@qtyr)"/>
	</xsl:template>

	<xsl:template match="@total:qtyr">
		<xsl:param name="data" select="node-expected"/>
		<xsl:variable name="rows" select="$data/ancestor-or-self::*[1][@qtyr and @prd]"/>
		<xsl:value-of select="sum($rows/@qtyr)"/>
	</xsl:template>

	<xsl:key name="section" match="ventas/@pdf" use="'po'"/>
	<xsl:key name="section" match="ventas/@rd" use="'po'"/>
	<xsl:key name="section" match="ventas/@po" use="'po'"/>
	<xsl:key name="section" match="ventas/@vnd" use="'po'"/>
	<xsl:key name="section" match="ventas/@ve" use="'po'"/>
	<xsl:key name="section" match="ventas/@vndn" use="'po'"/>
	<xsl:key name="section" match="ventas/@cmd" use="'product'"/>
	<xsl:key name="section" match="ventas/@var" use="'product'"/>
	<xsl:key name="section" match="ventas/@pck" use="'product'"/>
	<xsl:key name="section" match="ventas/@sz" use="'product'"/>
	<xsl:key name="section" match="ventas/@lbl" use="'product'"/>
	<xsl:key name="section" match="ventas/@qtyr" use="'product'"/>
	<xsl:key name="section" match="ventas/@upce" use="'product'"/>
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
			<xsl:apply-templates mode="datagrid:group-header-cell" select="@product_adjustments|@charges|@netp|@absorbed_expenses|@profit_loss"/>
			<!--<
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
			</th>-->
		</tr>
		<xsl:if test="$y-dimension">
			<tr style="text-align: center;">
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

	<!--<xsl:template mode="datagrid:widget" match="ventas[@filter:po]">
		<div xo-stylesheet="liquidation_report.xslt" xo-source="active">
		</div>
	</xsl:template>-->

	<xsl:key name="concepts" match="/model/concepto/row/@desc" use="../@id"/>
	<xsl:key name="classification" match="/model/ventas//row/@cls" use="concat(.,':',../@cnp)"/>
	<xsl:key name="classification" match="/model/clasificacion/row/@id" use="../@key"/>

	<xsl:template mode="datagrid:group-header-cell" match="@product_adjustments|@charges|@absorbed_expenses">
		<xsl:param name="row" select="ancestor-or-self::*[1]"/>
		<xsl:variable name="classification" select="key('classification', name())"/>
		<xsl:variable name="cell" select="$row/@*[name()=local-name(current())]"/>
		<xsl:variable name="fields" select="//concepto/row[key('classification',concat($classification,':',@id))]/@id"/>
		<th colspan="{count($fields)+1}" style="text-transform: uppercase;">
			<xsl:apply-templates select="."/>
		</th>
	</xsl:template>

	<xsl:template mode="datagrid:group-header-cell" match="@profit_loss">
		<th colspan="4" style="text-transform: uppercase;">
			<xsl:apply-templates select="."/>
		</th>
	</xsl:template>

	<xsl:template mode="datagrid:group-header-cell" match="@netp">
		<th colspan="2" style="text-transform: uppercase;"></th>
	</xsl:template>

	<xsl:template mode="datagrid:cell" match="@pdf">
		<xsl:param name="row" select=".."/>
		<th scope="row">
			<a href="#reporte_liquidacion?@view=reporte_liquidacion_pdf&amp;@purchase_order={$row/@po}">
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-file-earmark-pdf" viewBox="0 0 16 16">
					<path d="M14 14V4.5L9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2M9.5 3A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5z"/>
					<path d="M4.603 14.087a.8.8 0 0 1-.438-.42c-.195-.388-.13-.776.08-1.102.198-.307.526-.568.897-.787a7.7 7.7 0 0 1 1.482-.645 20 20 0 0 0 1.062-2.227 7.3 7.3 0 0 1-.43-1.295c-.086-.4-.119-.796-.046-1.136.075-.354.274-.672.65-.823.192-.077.4-.12.602-.077a.7.7 0 0 1 .477.365c.088.164.12.356.127.538.007.188-.012.396-.047.614-.084.51-.27 1.134-.52 1.794a11 11 0 0 0 .98 1.686 5.8 5.8 0 0 1 1.334.05c.364.066.734.195.96.465.12.144.193.32.2.518.007.192-.047.382-.138.563a1.04 1.04 0 0 1-.354.416.86.86 0 0 1-.51.138c-.331-.014-.654-.196-.933-.417a5.7 5.7 0 0 1-.911-.95 11.7 11.7 0 0 0-1.997.406 11.3 11.3 0 0 1-1.02 1.51c-.292.35-.609.656-.927.787a.8.8 0 0 1-.58.029m1.379-1.901q-.25.115-.459.238c-.328.194-.541.383-.647.547-.094.145-.096.25-.04.361q.016.032.026.044l.035-.012c.137-.056.355-.235.635-.572a8 8 0 0 0 .45-.606m1.64-1.33a13 13 0 0 1 1.01-.193 12 12 0 0 1-.51-.858 21 21 0 0 1-.5 1.05zm2.446.45q.226.245.435.41c.24.19.407.253.498.256a.1.1 0 0 0 .07-.015.3.3 0 0 0 .094-.125.44.44 0 0 0 .059-.2.1.1 0 0 0-.026-.063c-.052-.062-.2-.152-.518-.209a4 4 0 0 0-.612-.053zM8.078 7.8a7 7 0 0 0 .2-.828q.046-.282.038-.465a.6.6 0 0 0-.032-.198.5.5 0 0 0-.145.04c-.087.035-.158.106-.196.283-.04.192-.03.469.046.822q.036.167.09.346z"/>
				</svg>
			</a>
		</th>
	</xsl:template>

	<xsl:template mode="datagrid:header-cell" match="@product_adjustments|@charges|@absorbed_expenses">
		<xsl:variable name="classification" select="key('classification', name())"/>
		<xsl:variable name="fields" select="//concepto/row[key('classification',concat($classification,':',@id))]/@id"/>
		<xsl:for-each select="$fields">
			<th scope="col">
				<xsl:value-of select="../@desc"/>
			</th>
		</xsl:for-each>
		<!--<xsl:if test="$fields[2]">-->
		<th class="text-uppercase">
			Total <xsl:apply-templates mode="headerText" select="$classification"/>
		</th>
		<!--</xsl:if>-->
	</xsl:template>

	<xsl:template mode="datagrid:cell" match="@product_adjustments|@charges|@absorbed_expenses">
		<xsl:param name="row" select="ancestor-or-self::*[1]"/>
		<xsl:variable name="classification" select="key('classification', name())"/>
		<xsl:variable name="fields" select="//concepto/row[key('classification',concat($classification,':',@id))]/@id"/>
		<xsl:for-each select="$fields">
			<td xo-scope="inherit" xo-slot="{local-name()}" class="text-nowrap cell domain-{local-name()}">
				<xsl:apply-templates select="$row/row[@cls=$classification and @cnp=current()]/@amt"/>
			</td>
		</xsl:for-each>
		<!--<xsl:if test="$fields[2]">-->
		<td class="fw-bold">
			<xsl:call-template name="format">
				<xsl:with-param name="value">
					<xsl:value-of select="sum($row/row[@cls=$classification]/@amt)"/>
				</xsl:with-param>
			</xsl:call-template>
		</td>
		<!--</xsl:if>-->
	</xsl:template>

	<xsl:template mode="datagrid:footer-cell" match="@product_adjustments|@charges|@absorbed_expenses">
		<xsl:param name="rows" select="ancestor-or-self::*[1]"/>
		<xsl:variable name="classification" select="key('classification', name())"/>
		<xsl:variable name="fields" select="//concepto/row[key('classification',concat($classification,':',@id))]/@id"/>
		<xsl:for-each select="$fields">
			<td xo-scope="inherit" xo-slot="{local-name()}" class="text-nowrap text-center cell domain-{local-name()}">
				<xsl:call-template name="format">
					<xsl:with-param name="value" select="sum($rows//row[@cls=$classification][@cnp=current()]/@amt)"/>
				</xsl:call-template>
			</td>
		</xsl:for-each>
		<!--<xsl:if test="$fields[2]">-->
		<td class="text-center">
			<xsl:call-template name="format">
				<xsl:with-param name="value">
					<xsl:value-of select="sum($rows//row[@cls=$classification]/@amt)"/>
				</xsl:with-param>
			</xsl:call-template>
		</td>
		<!--</xsl:if>-->
	</xsl:template>

	<xsl:template mode="datagrid:cell-content" match="@po">
		<a href="#ventas_por_fecha_embarque?@purchase_order={current()}">
			<xsl:apply-templates select="."/>
		</a>
	</xsl:template>
</xsl:stylesheet>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:session="http://panax.io/session"
xmlns:state="http://panax.io/state"
xmlns:visible="http://panax.io/state/visible"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns:v="urn:schemas-microsoft-com:office:excel"
xmlns:xo="http://panax.io/xover"
>
	<xsl:import href="common.xslt"/>

	<xsl:key name="data" match="ventas/row//@*" use="name()"/>

	<xsl:key name="section" match="ventas/@rd" use="'po'"/>
	<!--<xsl:key name="section" match="ventas/@po" use="'po'"/>
	<xsl:key name="section" match="ventas/@vek" use="'po'"/>
	<xsl:key name="section" match="ventas/@ve" use="'po'"/>
	<xsl:key name="section" match="ventas/@nm" use="'po'"/>
	<xsl:key name="section" match="ventas/@cmd" use="'product'"/>
	<xsl:key name="section" match="ventas/@var" use="'product'"/>
	<xsl:key name="section" match="ventas/@sz" use="'product'"/>
	<xsl:key name="section" match="ventas/@lbl" use="'product'"/>
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
	<xsl:key name="section" match="ventas/@un_p" use="'profit_loss'"/>-->

	<xsl:key name="concepts" match="/model/concepto/row/@desc" use="../@id"/>
	<xsl:key name="classification" match="/model/ventas//row/@cls" use="concat(.,':',../@cnp)"/>
	<xsl:key name="classification" match="/model/ventas//row/@cls" use="concat(.,':*')"/>
	<xsl:key name="classification" match="/model/clasificacion/row/@id" use="../@key"/>

	<xsl:template match="/">
		<!--<style>
			.zoomable-onhover {
				transition: transform 0.5s ease 0s, opacity 1s ease 0s;
				transform-origin: top left;
			}
			.zoomable-onhover:hover {
			    transform: scale(1.5);
			}
		</style>-->
		<body xmlns="http://www.w3.org/1999/xhtml">
			<style id="PROPUESTA LIQ-1(1)_26760_Styles">
				&amp;lt;!--table
				{mso-displayed-decimal-separator:"\.";
				mso-displayed-thousand-separator:"\,";}
				.xl6426760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl6526760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				background:#262626;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl6626760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl6726760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:top;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl6826760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:"Short Date";
				text-align:left;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl6926760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:left;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl7026760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:left;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl7126760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\#\,\#\#0";
				text-align:left;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl7226760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				background:#EDEDED;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl7326760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\#\,\#\#0";
				text-align:left;
				vertical-align:bottom;
				background:#EDEDED;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl7426760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:right;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl7526760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:11.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl7626760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:Standard;
				text-align:right;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl7726760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:Standard;
				text-align:right;
				vertical-align:bottom;
				background:#EDEDED;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl7826760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:Standard;
				text-align:general;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl7926760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				background:#EDEDED;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl8026760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:8.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:center;
				vertical-align:top;
				background:#D0CECE;
				mso-pattern:black none;
				white-space:normal;}
				.xl8126760
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:center;
				vertical-align:middle;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				--&amp;gt;
			</style>
			<div id="PROPUESTA LIQ-1(1)_26760" align="center" x:publishsource="Excel" style="max-width: 90vw; margin: auto;">
				<table border="0" cellpadding="0" cellspacing="0" width="633" class="xl6426760 bg-white zoomable-onhover" style="border-collapse:collapse;">
					<colgroup>
						<col class="xl6426760" width="163" style="mso-width-source:userset;mso-width-alt:&#10; 5961;width:122pt" />
						<col class="xl6426760" width="61" style="mso-width-source:userset;mso-width-alt:&#10; 2230;width:76pt" />
					</colgroup>
					<tbody>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt; margin: .5rem 1rem 0;">
								<img width="150" src="assets/logo.png" alt="Forma&#10;&#10;Descripción generada automáticamente con confianza baja" v:shapes="Imagen_x0020_1" style="filter: brightness(0); margin: .7rem 1rem;"/>
							</td>
							<td class="xl6426760"></td>
							<td colspan="4" class="xl8126760">PURCHASE ORDER LIQUIDATION REPORT</td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="3" style="mso-height-source:userset;height:2.45pt">
							<td height="3" class="xl6526760" style="height:2.45pt"> </td>
							<td class="xl6526760"> </td>
							<td class="xl6526760"> </td>
							<td class="xl6526760"> </td>
							<td class="xl6526760"> </td>
							<td class="xl6526760"> </td>
							<td class="xl6526760"> </td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="31" style="mso-height-source:userset;height:23.45pt">
							<td height="31" class="xl6626760" style="height:23.45pt">
								<xsl:apply-templates select="key('data', 'cmp')[1]"/>
							</td>
							<td class="xl6426760"></td>
							<td class="xl6726760"></td>
							<td class="xl6726760"></td>
							<td class="xl6426760"></td>
							<td class="xl7426760">Purchase Order:</td>
							<td class="xl7526760" style="padding-left: .5rem;">
								<xsl:apply-templates select="key('data', 'po')[1]"/>
							</td>
						</tr>
						<tr height="19" style="mso-height-source:userset;height:14.45pt">
							<td height="19" class="xl6426760" colspan="2" style="height:14.45pt">
								<xsl:apply-templates select="key('data', 'add')[1]"/>
								<xsl:text> </xsl:text>
								<xsl:apply-templates select="key('data', 'cty')[1]"/>
							</td>
							<td class="xl6726760"></td>
							<td class="xl6726760"></td>
							<td class="xl6426760"></td>
							<td class="xl7426760">Rec. Date:</td>
							<td class="xl6826760" style="padding-left: .5rem;">
								<xsl:apply-templates select="key('data', 'rd')[1]"/>
							</td>
						</tr>
						<tr height="19" style="mso-height-source:userset;height:14.45pt">
							<td height="19" class="xl6426760" style="height:14.45pt">
								<xsl:apply-templates select="key('data', 'stn')[1]"/>, <xsl:apply-templates select="key('data', 'stc')[1]"/> 78503
							</td>
							<td class="xl6726760"></td>
							<td class="xl6726760"></td>
							<td class="xl6726760"></td>
							<td class="xl6426760"></td>
							<td class="xl6726760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt">
								Phone: (956) <xsl:apply-templates select="key('data', 'tpn')[1]"/>
							</td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt">
								Fax: (956) <xsl:apply-templates select="key('data', 'fax')[1]"/>
							</td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6626760" style="height:11.25pt">Vendor:</td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6626760">
								Requested By
							</td>
							<td class="xl6426760">
								<xsl:apply-templates select="key('data', 'rqt')[1]"/>
							</td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt">
								<xsl:apply-templates select="key('data', 'vndn')[1]"/>
							</td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td class="xl6426760" colspan="4" rowspan="2" style="vertical-align: top;">
								<xsl:apply-templates select="key('data', 'vndadd')[1]"/>
							</td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td colspan="7" height="15" class="xl8026760" dir="LTR" width="633" style="height:11.25pt;&#10;  width:475pt">PRODUCT</td>
						</tr>
						<tr height="5" style="mso-height-source:userset;height:4.15pt">
							<td height="5" class="xl6426760" style="height:4.15pt"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt; text-align: center;">
							<td height="15" class="xl6926760" style="height:11.25pt">Description</td>
							<td class="xl6926760">Pack Style</td>
							<td class="xl6926760">Size</td>
							<td class="xl6926760">Label</td>
							<td class="xl6926760" style="text-align:center">Qty Rec.</td>
							<td class="xl6926760" style="text-align:center">Unit Price</td>
							<td class="xl6926760" style="text-align:center">Amount</td>
						</tr>
						<xsl:for-each select="//ventas/row/row">
							<tr height="15" style="height:11.25pt">
								<td height="15" class="xl7026760" style="height:11.25pt">
									<xsl:apply-templates select="@cmd"/> - <xsl:apply-templates select="@var"/>
								</td>
								<td class="xl7026760">
									<xsl:apply-templates select="@pck"/>
								</td>
								<td class="xl7026760">
									<xsl:apply-templates select="@sz"/>
								</td>
								<td class="xl7026760">
									<xsl:apply-templates select="@lbl"/>
								</td>
								<td class="xl7126760" style="text-align:center">
									<xsl:apply-templates select="@qtyr"/>
								</td>
								<td class="xl7626760" style="text-align:center">
									<xsl:call-template name="format">
										<xsl:with-param name="value" select="@upce"/>
									</xsl:call-template>
								</td>
								<td class="xl7626760" style="text-align:center">
									<xsl:call-template name="format">
										<xsl:with-param name="value" select="@prd"/>
									</xsl:call-template>
								</td>
							</tr>
						</xsl:for-each>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl7026760" style="height:11.25pt"></td>
							<td class="xl7026760"></td>
							<td class="xl7026760"></td>
							<td class="xl7026760"></td>
							<td class="xl7126760"></td>
							<td class="xl7626760"></td>
							<td class="xl7626760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl7926760" style="height:11.25pt">SubTotal for Product:</td>
							<td class="xl7226760"> </td>
							<td class="xl7226760"> </td>
							<td class="xl7226760"> </td>
							<td class="xl7326760" style="text-align:center">
								<xsl:call-template name="format">
									<xsl:with-param name="value" select="sum(key('data','qtyr'))"/>
									<xsl:with-param name="mask">###,##0;-###,##0</xsl:with-param>
								</xsl:call-template>
							</td>
							<td class="xl7726760" style="text-align:center">
								<xsl:call-template name="format">
									<xsl:with-param name="value" select="sum(key('data','prd')) div sum(key('data','qtyr'))"/>
								</xsl:call-template>
							</td>
							<td class="xl7726760" style="text-align:center">
								<xsl:call-template name="format">
									<xsl:with-param name="value" select="sum(key('data','prd'))"/>
								</xsl:call-template>
							</td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<xsl:for-each select="//ventas">
							<xsl:variable name="current" select="current()"/>
							<!--<xsl:for-each select="@product_adjustments|@charges|@absorbed_expenses">
								<tr>
									<td colspan="10">
										<xsl:value-of select="name()"/>!!
									</td>
								</tr>
								<xsl:variable name="classification" select="key('classification', name())"/>
								<xsl:variable name="fields" select="//concepto/row[key('classification',concat($classification,':',@id))]/@id"/>
								<xsl:for-each select="$fields">
									<tr>
										<td>
											<xsl:value-of select="../@desc"/>
										</td>
										<td xo-scope="inherit" xo-slot="{local-name()}" class="text-nowrap cell domain-{local-name()}">

										</td>
									</tr>
								</xsl:for-each>
								-->
							<!--<xsl:if test="$fields[2]">-->
							<!--
								-->
							<!--<td class="fw-bold">
									<xsl:call-template name="format">
										<xsl:with-param name="value">
											<xsl:value-of select="sum($row/row[@cls=$classification]/@amt)"/>
										</xsl:with-param>
									</xsl:call-template>
								</td>-->
							<!--
							</xsl:for-each>-->
							<xsl:for-each select="@product_adjustments">
								<xsl:variable name="classification" select="key('classification', name())"/>
								<xsl:variable name="fields" select="//concepto/row[key('classification',concat($classification,':',@id))]/@id"/>
								<xsl:if test="$fields">
									<tr height="15" style="height:11.25pt">
										<td colspan="7" height="15" class="xl8026760" dir="LTR" width="633" style="height:11.25pt;&#10;  width:475pt">
											PRODUCT ADJUSTMENTS
										</td>
									</tr>
									<tr height="15" style="height:11.25pt">
										<td height="15" class="xl6426760" style="height:11.25pt"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
									</tr>
									<tr height="15" style="height:11.25pt">
										<td height="15" class="xl6926760" style="height:11.25pt">Concept</td>
										<td class="xl6926760">Vendor</td>
										<td class="xl6926760">Name</td>
										<td class="xl6426760"></td>
										<td class="xl6926760" style="text-align:center">Qty</td>
										<td class="xl6926760" style="text-align:center">Unit Price</td>
										<td class="xl6926760" style="text-align:center">Amount</td>
									</tr>
									<xsl:for-each select="$fields">
										<xsl:variable name="data" select="key('classification',concat($classification,':',.))/../@amt"/>
										<tr height="15" style="height:11.25pt">
											<td height="15" class="xl6426760" style="height:11.25pt">
												<xsl:apply-templates select="../@desc"/>
											</td>
											<td class="xl6426760">
												<xsl:apply-templates select="$data[1]/../@vnc"/>
											</td>
											<td class="xl6426760" colspan="2">
												<xsl:apply-templates select="$data[1]/../@vnc_nm"/>
											</td>
											<td class="xl7026760" style="text-align:center">
												<xsl:call-template name="format">
													<xsl:with-param name="value" select="sum($data/../@qtc)"/>
													<xsl:with-param name="mask">###,##0;-###,##0</xsl:with-param>
												</xsl:call-template>
											</td>
											<td class="xl7626760" style="text-align:center">
												<xsl:call-template name="format">
													<xsl:with-param name="value" select="sum($data) div sum($data/../@qtc)"/>
													<xsl:with-param name="mask">$###,##0.00;-$###,##0.00</xsl:with-param>
												</xsl:call-template>
											</td>
											<td class="xl7626760" style="text-align:center">
												<xsl:call-template name="format">
													<xsl:with-param name="value" select="sum($data)"/>
												</xsl:call-template>
											</td>
										</tr>
									</xsl:for-each>
									<tr height="15" style="height:11.25pt">
										<td height="15" class="xl6426760" style="height:11.25pt"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
									</tr>
									<xsl:variable name="data" select="key('classification',concat($classification,':*'))/../@amt"/>
									<tr height="15" style="height:11.25pt">
										<td height="15" class="xl7926760" colspan="2" style="height:11.25pt">
											SubTotal for Product Adjustments:
										</td>
										<td class="xl7226760"> </td>
										<td class="xl7226760"> </td>
										<td class="xl7326760" style="text-align:center">
											<xsl:call-template name="format">
												<xsl:with-param name="value" select="sum($data/../@qtc)"/>
												<xsl:with-param name="mask">###,##0;-###,##0</xsl:with-param>
											</xsl:call-template>
										</td>
										<td class="xl7726760" style="text-align:center">
											<xsl:call-template name="format">
												<xsl:with-param name="value" select="sum($data/../@amt) div sum($data/../@qtc)"/>
											</xsl:call-template>
										</td>
										<td class="xl7726760" style="text-align:center">
											<xsl:call-template name="format">
												<xsl:with-param name="value" select="sum($data)"/>
												<xsl:with-param name="mask">$###,##0.00;-$###,##0.00</xsl:with-param>
											</xsl:call-template>
										</td>
									</tr>
									<tr height="15" style="height:11.25pt">
										<td height="15" class="xl6426760" style="height:11.25pt"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
									</tr>
									<tr height="15" style="height:11.25pt">
										<td height="15" class="xl6426760" style="height:11.25pt"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
									</tr>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select="@charges">
								<xsl:variable name="classification" select="key('classification', name())"/>
								<xsl:variable name="fields" select="//concepto/row[key('classification',concat($classification,':',@id))]/@id"/>
								<xsl:if test="$fields">
									<tr height="15" style="height:11.25pt">
										<td colspan="7" height="15" class="xl8026760" dir="LTR" width="633" style="height:11.25pt;&#10;  width:475pt">CHARGES</td>
									</tr>
									<tr height="15" style="height:11.25pt">
										<td height="15" class="xl6426760" style="height:11.25pt"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
									</tr>
									<tr height="15" style="height:11.25pt">
										<td height="15" class="xl6926760" style="height:11.25pt">Concept</td>
										<td class="xl6926760">Vendor</td>
										<td class="xl6926760">Name</td>
										<td class="xl6426760"></td>
										<td class="xl6926760" style="text-align:center">Qty</td>
										<td class="xl6926760" style="text-align:center">Unit Price</td>
										<td class="xl6926760" style="text-align:center">Amount</td>
									</tr>
									<xsl:for-each select="$fields">
										<xsl:variable name="data" select="key('classification',concat($classification,':',.))/../@amt"/>
										<tr height="15" style="height:11.25pt">
											<td height="15" class="xl6426760" style="height:11.25pt">
												<xsl:value-of select="../@desc"/>
											</td>
											<td class="xl6426760">
												<xsl:apply-templates select="$data[1]/../@vnc"/>
											</td>
											<td class="xl6426760" colspan="2">
												<xsl:apply-templates select="$data[1]/../@vnc_nm"/>
											</td>
											<td class="xl7026760" style="text-align:center">
												<xsl:call-template name="format">
													<xsl:with-param name="value" select="sum($data/../@qtc)"/>
													<xsl:with-param name="mask">###,##0;-###,##0</xsl:with-param>
												</xsl:call-template>
											</td>
											<td class="xl7626760" style="text-align:center">
												<xsl:call-template name="format">
													<xsl:with-param name="value" select="sum($data) div sum($data/../@qtc)"/>
													<xsl:with-param name="mask">$###,##0.00;-$###,##0.00</xsl:with-param>
												</xsl:call-template>
											</td>
											<td class="xl7626760" style="text-align:center">
												<xsl:call-template name="format">
													<xsl:with-param name="value" select="sum($data)"/>
													<xsl:with-param name="mask">$###,##0.00;-$###,##0.00</xsl:with-param>
												</xsl:call-template>
											</td>
										</tr>
									</xsl:for-each>
									<tr height="15" style="height:11.25pt">
										<td height="15" class="xl6426760" style="height:11.25pt"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl7026760"></td>
										<td class="xl7826760"></td>
										<td class="xl7826760"></td>
									</tr>
									<xsl:variable name="data" select="key('classification',concat($classification,':*'))/../@amt"/>
									<tr height="15" style="height:11.25pt">
										<td height="15" class="xl7926760" style="height:11.25pt">SubTotal for Charges:</td>
										<td class="xl7226760"> </td>
										<td class="xl7226760"> </td>
										<td class="xl7226760"> </td>
										<td class="xl7326760"> </td>
										<td class="xl7726760"> </td>
										<td class="xl7726760" style="text-align:center">
											<xsl:call-template name="format">
												<xsl:with-param name="value" select="sum($data)"/>
												<xsl:with-param name="mask">$###,##0.00;-$###,##0.00</xsl:with-param>
											</xsl:call-template>
										</td>
									</tr>
									<tr height="15" style="height:11.25pt">
										<td height="15" class="xl6426760" style="height:11.25pt"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
										<td class="xl6426760"></td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:for-each>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl7926760" style="height:11.25pt">Totals:</td>
							<td class="xl7226760"> </td>
							<td class="xl7226760"> </td>
							<td class="xl7226760"> </td>
							<td class="xl7326760"> </td>
							<td class="xl7726760"> </td>
							<td class="xl7726760" style="text-align:center">
								<xsl:call-template name="format">
									<xsl:with-param name="value" select="sum(key('classification','2:*')/../@amt|key('classification','1:*')/../@amt|//ventas/row/row/@prd)"/>
								</xsl:call-template>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</body>
	</xsl:template>

</xsl:stylesheet>
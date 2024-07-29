<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:js="http://panax.io/xover/javascript"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:shell="http://panax.io/shell"
xmlns:state="http://panax.io/state"
xmlns:visible="http://panax.io/state/visible"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns:v="urn:schemas-microsoft-com:office:excel"
xmlns:xo="http://panax.io/xover"
exclude-result-prefixes="#default session sitemap shell"
>
	<xsl:import href="common.xslt"/>
	<xsl:key name="dates" match="fechas/row/@key" use="'active'"/>
	<xsl:key name="dates" match="weeks/row/@key" use="'active'"/>

	<xsl:template mode="week" match="fechas/row/@*">
		<xsl:value-of select="../@week"/>
	</xsl:template>

	<xsl:key name="accounts" match="account/@key" use="substring(.,1,1)"/>

	<xsl:key name="accounts" match="account/@key" use="concat(../../@key,'::',substring(.,1,1))"/>

	<xsl:key name="expenses" match="policies/row/@amt" use="concat(../@wk,'::',../@acc)"/>
	<xsl:key name="expenses" match="policies/row/@amt" use="concat(../@wk,'::c:',../@cl,'::',substring(../@acc,1,1))"/>

	<xsl:key name="purchase-orders-qty" match="purchase_orders/row/@qty" use="concat(../@wk,'::',../@type)"/>
	<xsl:key name="purchase-orders-amt" match="purchase_orders/row/@amt" use="concat(../@wk,'::',../@type)"/>
	<xsl:key name="purchase-orders-pfit" match="purchase_orders/row/@pfit" use="concat(../@wk,'::',../@type)"/>

	<xsl:key name="purchase-orders-qty" match="purchase_orders/row/@qty" use="../@wk"/>
	<xsl:key name="purchase-orders-amt" match="purchase_orders/row/@amt" use="../@wk"/>

	<xsl:key name="comision-qty" match="commissions/row/@qty" use="concat(../@wk,'::',../@gr)"/>
	<xsl:key name="comision-amt" match="commissions/row/@amt" use="concat(../@wk,'::',../@gr)"/>
	<xsl:key name="comision-pfit" match="commissions/row/@pfit" use="concat(../@wk,'::',../@gr)"/>
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
			.xl71722, .xl72722 {
				outline: 1.0pt solid black;
			}
			]]>
			</style>
			<style id="estado_resultados_semanal_722_Styles">
				&lt;!--table
				{mso-displayed-decimal-separator:"\.";
				mso-displayed-thousand-separator:"\,";}
				.font5722
				{color:#980000;
				font-size:10.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;}
				.xl15722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:11.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl65722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:13.0pt;
				font-weight:700;
				font-style:italic;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:middle;
				border-top:none;
				border-right:none;
				border-bottom:2.0pt double black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl66722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
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
				.xl67722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:700;
				font-style:italic;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:center;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl68722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:none;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl69722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:700;
				font-style:italic;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"Short Date";
				text-align:center;
				vertical-align:bottom;
				border-top:none;
				border-right:none;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl70722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:none;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl71722
				{padding:0px;
				mso-ignore:padding;
				color:white;
				font-size:11.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"dd\\-mmm";
				text-align:center;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:#FF9900;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl72722
				{padding:0px;
				mso-ignore:padding;
				color:white;
				font-size:11.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:center;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:#FF9900;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl73722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:none;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:white;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl74722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:white;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl75722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:11.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl76722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl77722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:11.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\#\,\#\#0";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl78722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:none;
				border-bottom:2.0pt double black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl79722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:middle;
				background:white;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl80722
				{padding:0px;
				mso-ignore:padding;
				color:#34A853;
				font-size:11.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:middle;
				border-top:none;
				border-right:none;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:white;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl81722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:11.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\0022$\0022\#\,\#\#0\.00\;\[Red\]\\-\0022$\0022\#\,\#\#0\.00";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl82722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\0022$\0022\#\,\#\#0\.00\;\[Red\]\\-\0022$\0022\#\,\#\#0\.00";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl83722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\#\,\#\#0";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl84722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\#\,\#\#0";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl85722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:11.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\0022$\0022\#\,\#\#0\.00\;\[Red\]\\-\0022$\0022\#\,\#\#0\.00";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:#B7E1CD;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl86722
				{padding:0px;
				mso-ignore:padding;
				color:#E06666;
				font-size:11.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:middle;
				border-top:none;
				border-right:none;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:white;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl87722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:11.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl88722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:11.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\0022$\0022\#\,\#\#0\.00\;\[Red\]\\-\0022$\0022\#\,\#\#0\.00";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:#F4C7C3;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl89722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:11.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:middle;
				border-top:none;
				border-right:none;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:white;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl90722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:9.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl91722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:13.0pt;
				font-weight:700;
				font-style:italic;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:none;
				border-bottom:2.0pt double black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl92722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:11.0pt;
				font-weight:400;
				font-style:italic;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl93722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:9.0pt;
				font-weight:400;
				font-style:italic;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:right;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl94722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:9.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\0022$\0022\#\,\#\#0\.00\;\[Red\]\\-\0022$\0022\#\,\#\#0\.00";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:none;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl95722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:9.0pt;
				font-weight:400;
				font-style:italic;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\#\,\#\#0";
				text-align:right;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl96722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:9.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\0022$\0022\#\,\#\#0\.00\;\[Red\]\\-\0022$\0022\#\,\#\#0\.00";
				text-align:right;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl97722
				{padding:0px;
				mso-ignore:padding;
				color:#38761D;
				font-size:10.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:#B7E1CD;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl98722
				{padding:0px;
				mso-ignore:padding;
				color:#38761D;
				font-size:10.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\0022$\0022\#\,\#\#0\.00\;\[Red\]\\-\0022$\0022\#\,\#\#0\.00";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:#B7E1CD;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl99722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl100722
				{padding:0px;
				mso-ignore:padding;
				color:#980000;
				font-size:10.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:#F4CCCC;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl101722
				{padding:0px;
				mso-ignore:padding;
				color:#980000;
				font-size:10.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\0022$\0022\#\,\#\#0\.00\;\[Red\]\\-\0022$\0022\#\,\#\#0\.00";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:#F4CCCC;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl102722
				{padding:0px;
				mso-ignore:padding;
				color:#38761D;
				font-size:10.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:white;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl103722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\0022$\0022\#\,\#\#0\.00\;\[Red\]\\-\0022$\0022\#\,\#\#0\.00";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:#B7E1CD;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl104722
				{padding:0px;
				mso-ignore:padding;
				color:#980000;
				font-size:10.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\0022$\0022\#\,\#\#0\.00\;\[Red\]\\-\0022$\0022\#\,\#\#0\.00";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:#F4C7C3;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl105722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\0022$\0022\#\,\#\#0\.00\;\[Red\]\\-\0022$\0022\#\,\#\#0\.00";
				text-align:right;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl106722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:none;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl107722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\0022$\0022\#\,\#\#0\.00\;\[Red\]\\-\0022$\0022\#\,\#\#0\.00";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				background:#D9EAD3;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl108722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl109722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:general;
				vertical-align:bottom;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl110722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:10.0pt;
				font-weight:400;
				font-style:normal;
				text-decoration:none;
				font-family:Arial, sans-serif;
				mso-font-charset:0;
				mso-number-format:"\0022$\0022\#\,\#\#0\.00\;\[Red\]\\-\0022$\0022\#\,\#\#0\.00";
				text-align:right;
				vertical-align:bottom;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:none;
				mso-background-source:auto;
				mso-pattern:auto;
				white-space:nowrap;}
				.xl111722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:11.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:center;
				vertical-align:middle;
				border-top:1.0pt solid black;
				border-right:1.0pt solid black;
				border-bottom:none;
				border-left:1.0pt solid black;
				background:#FFE699;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl112722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:11.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:center;
				vertical-align:middle;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:none;
				border-left:1.0pt solid black;
				background:#FFE699;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl113722
				{padding:0px;
				mso-ignore:padding;
				color:black;
				font-size:11.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:center;
				vertical-align:middle;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:1.0pt solid black;
				background:#FFE699;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl114722 {
				padding: 0px;
				mso-ignore: padding;
				color: white;
				font-size: 11.0pt;
				font-weight: 700;
				font-style: normal;
				text-decoration: none;
				font-family: Calibri, sans-serif;
				mso-font-charset: 0;
				mso-number-format: General;
				text-align: center;
				vertical-align: middle;
				border-top: 1.0pt solid black;
				border-right: 1.0pt solid black;
				border-bottom: none;
				/* border-left: 1.0pt solid black; */
				/* background: #FF9900; */
				mso-pattern: black none;
				white-space: nowrap;
				}
				.xl115722
				{padding:0px;
				mso-ignore:padding;
				color:white;
				font-size:11.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:center;
				vertical-align:middle;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:none;
				border-left:1.0pt solid black;
				background:#FF9900;
				mso-pattern:black none;
				white-space:nowrap;}
				.xl116722
				{padding:0px;
				mso-ignore:padding;
				color:white;
				font-size:11.0pt;
				font-weight:700;
				font-style:normal;
				text-decoration:none;
				font-family:Calibri, sans-serif;
				mso-font-charset:0;
				mso-number-format:General;
				text-align:center;
				vertical-align:middle;
				border-top:none;
				border-right:1.0pt solid black;
				border-bottom:1.0pt solid black;
				border-left:1.0pt solid black;
				background:#FF9900;
				mso-pattern:black none;
				white-space:nowrap;}
				--&gt;
			</style>
			<!--[if !excel]>  <![endif]-->
			<!--The following information was generated by Microsoft Excel's Publish as Web
Page wizard.-->
			<!--If the same item is republished from Excel, all information between the DIV
tags will be replaced.-->
			<!-- comment -->
			<!--START OF OUTPUT FROM EXCEL PUBLISH AS WEB PAGE WIZARD -->
			<!-- comment -->
			<xsl:variable name="dates" select="key('dates','active')"></xsl:variable>
			<div id="estado_resultados_semanal_722" align="center" x:publishsource="Excel" xo-silent="true">
				<table border="0" cellpadding="0" cellspacing="0" width="1508" style="border-collapse:&#10; collapse;table-layout:fixed;width:1132pt">
					<colgroup>
						<col width="130" style="mso-width-source:userset;mso-width-alt:4754;width:98pt" />
						<col width="258" style="mso-width-source:userset;mso-width-alt:9435;width:194pt" />
						<col width="80" span="{count($dates)}" style="width:60pt" />
						<col width="80" style="width:60pt" />
					</colgroup>
					<thead>
						<tr height="20" style="height:15.0pt; display:none">
							<td height="20" width="130" style="height:15.0pt;width:98pt" align="left" valign="top">
								<span style="mso-ignore:vglayout;&#10;  position:absolute;z-index:1;margin-left:42px;margin-top:15px;width:259px;&#10;  height:75px">
									<img width="259" height="75" src="assets/logo.png" v:shapes="Imagen_x0020_1" />
								</span>
								<span style="mso-ignore:vglayout2">
									<table cellpadding="0" cellspacing="0">
										<tbody>
											<tr>
												<td height="20" class="xl66722" width="130" style="height:15.0pt;width:98pt"></td>
											</tr>
										</tbody>
									</table>
								</span>
							</td>
							<td class="xl66722" width="258" style="width:194pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
							<td class="xl66722" width="80" style="width:60pt"></td>
						</tr>
					</thead>
					<thead class="freeze">
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl66722" style="height:15.75pt"></td>
							<td class="xl70722"> </td>
							<xsl:for-each select="$dates">
								<td class="xl71722">
									<xsl:apply-templates mode="headerText" select="."/>
								</td>
							</xsl:for-each>
							<td class="xl72722">Acumulado</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl66722" style="height:15.75pt"></td>
							<td class="xl70722" style="text-align: right; padding-inline: 10px">
								CORTE AL: <xsl:apply-templates mode="headerText" select="$dates[last()]"/>
							</td>
							<xsl:for-each select="$dates">
								<td class="xl71722">
									WK <xsl:apply-templates mode="week" select="."/>
								</td>
							</xsl:for-each>
							<td class="xl72722">Global</td>
						</tr>
					</thead>
					<tbody>
						<tr height="24" style="height:18.0pt" class="sticky">
							<td height="24" class="xl65722" colspan="2" style="height:18.0pt">PURCHASE ORDERS</td>
							<xsl:for-each select="$dates">
								<td class="xl78722"> </td>
							</xsl:for-each>
							<td class="xl78722"> </td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl79722" style="height:15.75pt"> </td>
							<td class="xl66722"></td>
							<xsl:for-each select="$dates">
								<td class="xl66722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl80722" style="height:15.75pt">SOLO POSITIVOS</td>
							<td class="xl68722"> </td>
							<xsl:for-each select="$dates">
								<td class="xl68722"> </td>
							</xsl:for-each>
							<td class="xl68722"> </td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td rowspan="3" height="63" class="xl114722" style="border-bottom:1.0pt solid black;&#10;  height:47.25pt;border-top:none"></td>
							<td class="xl75722">UTILIDAD EN POs</td>
							<xsl:for-each select="$dates">
								<td class="xl81722">
									<xsl:call-template name="format">
										<xsl:with-param name="value" select="sum(key('purchase-orders-amt', concat(.,'::','P')))"></xsl:with-param>
										<xsl:with-param name="mask">$###,##0;-$###,##0</xsl:with-param>
									</xsl:call-template>
								</td>
							</xsl:for-each>
							<td class="xl82722">$520,136.78</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl75722" style="height:15.75pt">CAJAS PO CON UTILIDAD</td>
							<xsl:for-each select="$dates">
								<td class="xl77722">
									<xsl:call-template name="format">
										<xsl:with-param name="value" select="sum(key('purchase-orders-qty', concat(.,'::','P')))"></xsl:with-param>
										<xsl:with-param name="mask">###,##0;-###,##0</xsl:with-param>
									</xsl:call-template>
								</td>
							</xsl:for-each>
							<td class="xl84722">156,689</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl75722" style="height:15.75pt">
								UTILIDAD /PÉRDIDA POR CAJA
								POs
							</td>
							<xsl:for-each select="$dates">
								<td class="xl85722">$3.00</td>
							</xsl:for-each>
							<td class="xl85722">--</td>
						</tr>
						<tr height="20" style="height:15.0pt">
							<td height="20" class="xl79722" style="height:15.0pt"> </td>
							<td class="xl66722"></td>
							<xsl:for-each select="$dates">
								<td class="xl66722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl86722" style="height:15.75pt">SOLO NEGATIVOS</td>
							<td class="xl68722"> </td>
							<xsl:for-each select="$dates">
								<td class="xl68722"> </td>
							</xsl:for-each>
							<td class="xl68722"> </td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td rowspan="3" height="63" class="xl114722" style="border-bottom:1.0pt solid black;&#10;  height:47.25pt;border-top:none"></td>
							<td class="xl75722">PÉRDIDA EN POs</td>
							<xsl:for-each select="$dates">
								<td class="xl81722">
									<font color="#FF0000" style="mso-ignore:color">
										<xsl:call-template name="format">
											<xsl:with-param name="value" select="sum(key('purchase-orders-amt', concat(.,'::','L')))"></xsl:with-param>
											<xsl:with-param name="mask">$###,##0;-$###,##0</xsl:with-param>
										</xsl:call-template>
									</font>
								</td>
							</xsl:for-each>
							<td class="xl82722">
								<font color="#FF0000" style="mso-ignore:color">-$43,204.73</font>
							</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl75722" style="height:15.75pt">CAJAS PO</td>
							<xsl:for-each select="$dates">
								<td class="xl77722">
									<xsl:call-template name="format">
										<xsl:with-param name="value" select="sum(key('purchase-orders-qty', concat(.,'::','L')))"></xsl:with-param>
										<xsl:with-param name="mask">###,##0;-###,##0</xsl:with-param>
									</xsl:call-template>
								</td>
							</xsl:for-each>
							<td class="xl77722">16,680</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl75722" style="height:15.75pt">
								UTILIDAD /PÉRDIDA POR CAJA
								POs
							</td>
							<xsl:for-each select="$dates">
								<td class="xl88722">
									<font color="#FF0000" style="mso-ignore:color">-$2.11</font>
								</td>
							</xsl:for-each>
							<td class="xl88722">
								<font color="#FF0000" style="mso-ignore:color">-$2.59</font>
							</td>
						</tr>
						<tr height="20" style="height:15.0pt">
							<td height="20" class="xl66722" style="height:15.0pt"></td>
							<td class="xl66722"></td>
							<xsl:for-each select="$dates">
								<td class="xl66722"></td>
							</xsl:for-each>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl89722" style="height:15.75pt">NETOS</td>
							<td class="xl68722"> </td>
							<xsl:for-each select="$dates">
								<td class="xl68722"> </td>
							</xsl:for-each>
							<td class="xl68722"> </td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td rowspan="3" height="63" class="xl114722" style="border-bottom:1.0pt solid black;&#10;  height:47.25pt;border-top:none"></td>
							<td class="xl75722">PÉRDIDA EN POs</td>
							<xsl:for-each select="$dates">
								<td class="xl81722">
									<xsl:call-template name="format">
										<xsl:with-param name="value" select="sum(key('purchase-orders-amt', .))"></xsl:with-param>
										<xsl:with-param name="mask">$###,##0;-$###,##0</xsl:with-param>
									</xsl:call-template>
								</td>
							</xsl:for-each>
							<td class="xl81722">$476,932.05</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl75722" style="height:15.75pt">CAJAS PO</td>
							<xsl:for-each select="$dates">
								<td class="xl77722">
									<xsl:call-template name="format">
										<xsl:with-param name="value" select="sum(key('purchase-orders-qty', .))"></xsl:with-param>
										<xsl:with-param name="mask">###,##0;-###,##0</xsl:with-param>
									</xsl:call-template>
								</td>
							</xsl:for-each>
							<td class="xl77722">162,236</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl75722" style="height:15.75pt">
								UTILIDAD /PÉRDIDA POR CAJA
								POs
							</td>
							<xsl:for-each select="$dates">
								<td class="xl85722">$2.57</td>
							</xsl:for-each>
							<td class="xl85722">$2.94</td>
						</tr>
						<tr height="20" style="height:15.0pt">
							<td height="20" class="xl66722" style="height:15.0pt"></td>
							<td class="xl90722">Cajas en Piso</td>
							<xsl:for-each select="$dates">
								<td class="xl66722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>
						<tr height="20" style="height:15.0pt">
							<td height="20" class="xl66722" style="height:15.0pt"></td>
							<td class="xl90722">Utilidad estimada</td>
							<xsl:for-each select="$dates">
								<td class="xl66722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>

						<tr height="20" style="height:15.0pt">
							<td height="20" class="xl66722" style="height:15.0pt"></td>
							<td class="xl66722"></td>
							<xsl:for-each select="$dates">
								<td class="xl66722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>
						<tr height="24" style="height:18.0pt" class="sticky">
							<td height="24" class="xl91722" style="height:18.0pt">CONSIGNACIÓN</td>
							<td class="xl78722"> </td>
							<xsl:for-each select="$dates">
								<td class="xl78722"> </td>
							</xsl:for-each>
							<td class="xl78722"> </td>
						</tr>
						<tr height="22" style="height:16.5pt">
							<td height="22" class="xl66722" style="height:16.5pt"></td>
							<td class="xl68722"> </td>
							<xsl:for-each select="$dates">
								<td class="xl68722"> </td>
							</xsl:for-each>
							<td class="xl68722"> </td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl70722" style="height:15.75pt"> </td>
							<td class="xl75722">COMISIÓN LOTES EXTERNOS</td>
							<xsl:for-each select="$dates">
								<td class="xl81722">
									<xsl:call-template name="format">
										<xsl:with-param name="value">
											<xsl:value-of select="key('comision-amt', concat(.,'::','other'))"/>
										</xsl:with-param>
									</xsl:call-template>
								</td>
							</xsl:for-each>
							<td class="xl82722">$30,764.26</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl70722" style="height:15.75pt"> </td>
							<td class="xl75722">CAJAS LOTE EXTERNOS</td>
							<xsl:for-each select="$dates">
								<td class="xl77722">
									<xsl:call-template name="format">
										<xsl:with-param name="value" select="key('comision-qty', concat(.,'::','other'))"></xsl:with-param>
										<xsl:with-param name="mask">###,##0;-###,##0</xsl:with-param>
									</xsl:call-template>
								</td>
							</xsl:for-each>
							<td class="xl77722">20,971</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl70722" style="height:15.75pt"> </td>
							<td class="xl75722">UTILIDAD /PÉRDIDA POR CAJA EXTERNOS</td>
							<xsl:for-each select="$dates">
								<td class="xl85722">
									<xsl:call-template name="format">
										<xsl:with-param name="value" select="key('comision-pfit', concat(.,'::','other')) div key('comision-qty', concat(.,'::','other'))"></xsl:with-param>
									</xsl:call-template>
								</td>
							</xsl:for-each>
							<td class="xl85722">$1.47</td>
						</tr>
						<tr height="20" style="height:15.0pt">
							<td height="20" class="xl66722" style="height:15.0pt"></td>
							<td class="xl92722"></td>
							<xsl:for-each select="$dates">
								<td class="xl93722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl66722" style="height:15.75pt"></td>
							<td class="xl68722"> </td>
							<xsl:for-each select="$dates">
								<td class="xl94722"> </td>
							</xsl:for-each>
							<td class="xl68722"> </td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl70722" style="height:15.75pt"> </td>
							<td class="xl75722">COMISIÓN LOTES INTEBAJ</td>
							<xsl:for-each select="$dates">
								<td class="xl81722">
									<xsl:call-template name="format">
										<xsl:with-param name="value">
											<xsl:value-of select="key('comision-amt', concat(.,'::','intebaj'))"/>
										</xsl:with-param>
									</xsl:call-template>
								</td>
							</xsl:for-each>
							<td class="xl82722">$199,703.80</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl70722" style="height:15.75pt"> </td>
							<td class="xl75722">CAJAS LOTE INTEBAJ</td>
							<xsl:for-each select="$dates">
								<td class="xl77722">
									<xsl:call-template name="format">
										<xsl:with-param name="value" select="key('comision-qty', concat(.,'::','intebaj'))"></xsl:with-param>
										<xsl:with-param name="mask">###,##0;-###,##0</xsl:with-param>
									</xsl:call-template>
								</td>
							</xsl:for-each>
							<td class="xl77722">147,868</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl70722" style="height:15.75pt"> </td>
							<td class="xl75722">UTILIDAD /PÉRDIDA POR CAJA INTEBAJ</td>
							<xsl:for-each select="$dates">
								<td class="xl85722">
									<xsl:call-template name="format">
										<xsl:with-param name="value" select="key('comision-pfit', concat(.,'::','intebaj')) div key('comision-qty', concat(.,'::','intebaj'))"></xsl:with-param>
									</xsl:call-template>
								</td>
							</xsl:for-each>
							<td class="xl85722">$1.35</td>
						</tr>
						<tr height="20" style="height:15.0pt">
							<td height="20" class="xl66722" style="height:15.0pt"></td>
							<td class="xl92722"></td>
							<xsl:for-each select="$dates">
								<td class="xl93722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>
						<tr height="20" style="height:15.0pt">
							<td height="20" class="xl66722" style="height:15.0pt"></td>
							<td class="xl66722"></td>
							<xsl:for-each select="$dates">
								<td class="xl96722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>
						<tr height="24" style="height:18.0pt" class="sticky">
							<td height="24" class="xl91722" style="height:18.0pt">TOTALES</td>
							<td class="xl78722"> </td>
							<xsl:for-each select="$dates">
								<td class="xl78722"> </td>
							</xsl:for-each>
							<td class="xl78722"> </td>
						</tr>
						<tr height="22" style="height:16.5pt">
							<td height="22" class="xl66722" style="height:16.5pt"></td>
							<td class="xl68722"> </td>
							<xsl:for-each select="$dates">
								<td class="xl68722"> </td>
							</xsl:for-each>
							<td class="xl68722"> </td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl70722" style="height:15.75pt"> </td>
							<td class="xl97722">TOTAL INGRESOS SEMANALES</td>
							<xsl:for-each select="$dates">
								<td class="xl98722">$64,142.55</td>
							</xsl:for-each>
							<td class="xl98722">$937,823.34</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl70722" style="height:15.75pt"> </td>
							<td class="xl99722">TOTAL CAJAS DE LA SEMANA</td>
							<xsl:for-each select="$dates">
								<td class="xl77722">32,130</td>
							</xsl:for-each>
							<td class="xl77722">417,473</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl70722" style="height:15.75pt"> </td>
							<td class="xl99722">MARGEN PROMEDIO POR CAJA</td>
							<xsl:for-each select="$dates">
								<td class="xl82722">$2.00</td>
							</xsl:for-each>
							<td class="xl82722">$2.25</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl66722" style="height:15.75pt"></td>
							<td class="xl68722"> </td>
							<xsl:for-each select="$dates">
								<td class="xl68722"> </td>
							</xsl:for-each>
							<td class="xl68722"> </td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl70722" style="height:15.75pt"> </td>
							<td class="xl100722">GASTOS OPERATIVOS SEMANALES</td>
							<xsl:for-each select="$dates">
								<td class="xl101722">$50,082.24</td>
							</xsl:for-each>
							<td class="xl101722">$651,069.12</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl66722" style="height:15.75pt"></td>
							<td class="xl68722"> </td>
							<xsl:for-each select="$dates">
								<td class="xl68722"> </td>
							</xsl:for-each>
							<td class="xl68722"> </td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl70722" style="height:15.75pt"> </td>
							<td class="xl102722">
								UTILIDAD / <font class="font5722">PÉRDIDA SEMANAL</font>
							</td>
							<xsl:for-each select="$dates">
								<td class="xl103722">$14,060.31</td>
							</xsl:for-each>
							<!--<td class="xl103722">$2,678.72</td>
							<td class="xl104722">
								<font color="#FF0000" style="mso-ignore:color">-$11,792.01</font>
							</td>-->
							<td class="xl103722">$286,754.22</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl70722" style="height:15.75pt"> </td>
							<td class="xl102722">
								UTILIDAD / <font class="font5722">PÉRDIDA ACUMULADA</font>
							</td>
							<xsl:for-each select="$dates">
								<td class="xl103722">$14,060.31</td>
							</xsl:for-each>
							<td class="xl82722"> </td>
						</tr>
						<tr height="20" style="height:15.0pt">
							<td height="20" class="xl66722" style="height:15.0pt"></td>
							<td class="xl66722"></td>
							<xsl:for-each select="$dates">
								<td class="xl66722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>
						<tr height="20" style="height:15.0pt">
							<td height="20" class="xl66722" style="height:15.0pt"></td>
							<td class="xl66722"></td>
							<xsl:for-each select="$dates">
								<td class="xl66722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>
						<tr height="24" style="height:18.0pt" class="sticky">
							<td height="24" class="xl65722" colspan="2" style="height:18.0pt">
								GASTOS
								ADICIONALES
							</td>
							<xsl:for-each select="$dates">
								<td class="xl66722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>
						<tr height="22" style="height:16.5pt">
							<td height="22" class="xl66722" style="height:16.5pt"></td>
							<td class="xl68722"> </td>
							<xsl:for-each select="$dates">
								<td class="xl68722"> </td>
							</xsl:for-each>
							<td class="xl68722"> </td>
						</tr>
						<xsl:for-each select="key('accounts','5')/ancestor::classification/@key">
							<xsl:variable name="cl" select="."/>
							<tr height="21" style="height:15.75pt">
								<td height="21" class="xl106722" style="height:15.75pt">
									&#160;
								</td>
								<td height="21" class="xl99722" style="height:15.75pt; background-color:#FF9900; color: white;">
									<xsl:apply-templates select="../@desc"/>
								</td>
								<xsl:for-each select="$dates">
									<td class="xl107722" style="background-color:#FF9900; color: white;">
										<xsl:call-template name="format">
											<xsl:with-param name="value" select="sum(key('expenses',concat(.,'::c:',$cl,'::','5')))"></xsl:with-param>
											<xsl:with-param name="mask">$###,##0;-$###,##0</xsl:with-param>
										</xsl:call-template>
									</td>
								</xsl:for-each>
								<td class="xl107722">$3,644.85</td>
							</tr>
							<xsl:for-each select="key('accounts',concat(.,'::','5'))">
								<xsl:variable name="acc" select="."/>
								<tr height="21" style="height:15.75pt">
									<td height="21" class="xl106722" style="height:15.75pt">
										<xsl:apply-templates select="."/>
									</td>
									<td class="xl99722">
										<xsl:apply-templates select="../@desc"/>
									</td>
									<xsl:for-each select="$dates">
										<td class="xl107722">
											<xsl:call-template name="format">
												<xsl:with-param name="value" select="sum(key('expenses',concat(.,'::',$acc)))"></xsl:with-param>
												<xsl:with-param name="mask">$###,##0;-$###,##0</xsl:with-param>
											</xsl:call-template>
										</td>
									</xsl:for-each>
									<td class="xl107722">$3,644.85</td>
								</tr>
							</xsl:for-each>
						</xsl:for-each>						
						<tr height="20" style="height:15.0pt">
							<td height="20" class="xl66722" style="height:15.0pt"></td>
							<xsl:for-each select="$dates">
								<td class="xl66722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>
						<tr height="20" style="height:15.0pt">
							<td height="20" class="xl66722" style="height:15.0pt"></td>
							<td class="xl66722"></td>
							<xsl:for-each select="$dates">
								<td class="xl66722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>
						<tr height="24" style="height:18.0pt" class="sticky">
							<td height="24" class="xl65722" colspan="2" style="height:18.0pt">
								INGRESOS
								ADICIONALES
							</td>
							<xsl:for-each select="$dates">
								<td class="xl66722"></td>
							</xsl:for-each>
							<td class="xl66722"></td>
						</tr>
						<tr height="22" style="height:16.5pt">
							<td height="22" class="xl66722" style="height:16.5pt"></td>
							<td class="xl68722"> </td>
							<xsl:for-each select="$dates">
								<td class="xl68722"> </td>
							</xsl:for-each>
							<td class="xl68722"> </td>
						</tr>
						<xsl:for-each select="key('accounts','4')/ancestor::classification/@key">
							<xsl:variable name="cl" select="."/>
							<tr height="21" style="height:15.75pt">
								<td height="21" class="xl106722" style="height:15.75pt">
									&#160;
								</td>
								<td height="21" class="xl99722" style="height:15.75pt; background-color:#FF9900; color: white;">
									<xsl:apply-templates select="../@desc"/>
								</td>
								<xsl:for-each select="$dates">
									<td class="xl107722" style="background-color:#FF9900; color: white;">
										<xsl:call-template name="format">
											<xsl:with-param name="value" select="sum(key('expenses',concat(.,'::c:',$cl,'::','4')))"></xsl:with-param>
											<xsl:with-param name="mask">$###,##0;-$###,##0</xsl:with-param>
										</xsl:call-template>
									</td>
								</xsl:for-each>
								<td class="xl107722">$3,644.85</td>
							</tr>
							<xsl:for-each select="key('accounts',concat(.,'::','4'))">
								<xsl:variable name="acc" select="."/>
								<tr height="21" style="height:15.75pt">
									<td height="21" class="xl106722" style="height:15.75pt">
										<xsl:apply-templates select="."/>
									</td>
									<td class="xl99722">
										<xsl:apply-templates select="../@desc"/>
									</td>
									<xsl:for-each select="$dates">
										<td class="xl107722">
											<xsl:call-template name="format">
												<xsl:with-param name="value" select="sum(key('expenses',concat(.,'::',$acc)))"></xsl:with-param>
												<xsl:with-param name="mask">$###,##0;-$###,##0</xsl:with-param>
											</xsl:call-template>
										</td>
									</xsl:for-each>
									<td class="xl107722">$3,644.85</td>
								</tr>
							</xsl:for-each>
						</xsl:for-each>
						<!--<tr height="21" style="height:15.75pt">
							<td height="21" class="xl106722" style="height:15.75pt">450-106</td>
							<td class="xl99722">Other Income / Fixed Freight NTP</td>
							<xsl:for-each select="$dates">
								<td class="xl82722">$6,781.79</td>
							</xsl:for-each>
							<td class="xl82722">$118,631.58</td>
						</tr>
						<tr height="21" style="height:15.75pt">
							<td height="21" class="xl106722" style="height:15.75pt">450-106</td>
							<td class="xl99722">In &amp; Out Income</td>
							<xsl:for-each select="$dates">
								<td class="xl82722">$6,781.79</td>
							</xsl:for-each>
							<td class="xl82722">$54,549.55</td>
						</tr>-->
						<!--[if supportMisalignedColumns]-->
						<tr height="0" style="display:none">
							<td width="130" style="width:98pt"></td>
							<td width="258" style="width:194pt"></td>
							<xsl:for-each select="$dates">
								<td width="80" style="width:60pt"></td>
							</xsl:for-each>
							<td width="80" style="width:60pt"></td>
						</tr>
						<!--[endif]-->
					</tbody>
				</table>
			</div>
			<!-- comment -->
			<!--END OF OUTPUT FROM EXCEL PUBLISH AS WEB PAGE WIZARD-->
			<!-- comment -->


		</main>
	</xsl:template>

</xsl:stylesheet>
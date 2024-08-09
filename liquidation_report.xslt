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
		<body xmlns="http://www.w3.org/1999/xhtml" xo-source="">
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
			<div id="PROPUESTA LIQ-1(1)_26760" align="center" x:publishsource="Excel">

				<table border="0" cellpadding="0" cellspacing="0" width="633" class="xl6426760" style="border-collapse:collapse;table-layout:fixed;width:475pt">
					<colgroup>
						<col class="xl6426760" width="163" style="mso-width-source:userset;mso-width-alt:&#10; 5961;width:122pt" />
						<col class="xl6426760" width="61" style="mso-width-source:userset;mso-width-alt:&#10; 2230;width:46pt" />
						<col class="xl6426760" width="83" style="mso-width-source:userset;mso-width-alt:&#10; 3035;width:62pt" />
						<col class="xl6426760" width="68" style="mso-width-source:userset;mso-width-alt:&#10; 2486;width:51pt" />
						<col class="xl6426760" width="55" style="mso-width-source:userset;mso-width-alt:&#10; 2011;width:41pt" />
						<col class="xl6426760" width="74" style="mso-width-source:userset;mso-width-alt:&#10; 2706;width:56pt" />
						<col class="xl6426760" width="129" style="mso-width-source:userset;mso-width-alt:&#10; 4717;width:97pt" />
					</colgroup>
					<tbody>
						<tr height="15" style="height:11.25pt">
							<td height="15" width="163" style="height:11.25pt;width:122pt" align="left" valign="top">
								<!--[if gte vml 1]><v:shapetype id="_x0000_t75" coordsize="21600,21600"
   o:spt="75" o:preferrelative="t" path="m@4@5l@4@11@9@11@9@5xe" filled="f"
   stroked="f">
   <v:stroke joinstyle="miter"/>
   <v:formulas>
    <v:f eqn="if lineDrawn pixelLineWidth 0"/>
    <v:f eqn="sum @0 1 0"/>
    <v:f eqn="sum 0 0 @1"/>
    <v:f eqn="prod @2 1 2"/>
    <v:f eqn="prod @3 21600 pixelWidth"/>
    <v:f eqn="prod @3 21600 pixelHeight"/>
    <v:f eqn="sum @0 0 1"/>
    <v:f eqn="prod @6 1 2"/>
    <v:f eqn="prod @7 21600 pixelWidth"/>
    <v:f eqn="sum @8 21600 0"/>
    <v:f eqn="prod @7 21600 pixelHeight"/>
    <v:f eqn="sum @10 21600 0"/>
   </v:formulas>
   <v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"/>
   <o:lock v:ext="edit" aspectratio="t"/>
  </v:shapetype><v:shape id="Imagen_x0020_1" o:spid="_x0000_s3073" type="#_x0000_t75"
   alt="Forma&#10;&#10;Descripción generada automáticamente con confianza baja"
   style='position:absolute;margin-left:3pt;margin-top:0;width:112.5pt;
   height:42pt;z-index:1;visibility:visible' o:gfxdata="UEsDBBQABgAIAAAAIQBamK3CDAEAABgCAAATAAAAW0NvbnRlbnRfVHlwZXNdLnhtbJSRwU7DMAyG
70i8Q5QralM4IITW7kDhCBMaDxAlbhvROFGcle3tSdZNgokh7Rjb3+8vyWK5tSObIJBxWPPbsuIM
UDltsK/5x/qleOCMokQtR4dQ8x0QXzbXV4v1zgOxRCPVfIjRPwpBagArqXQeMHU6F6yM6Rh64aX6
lD2Iu6q6F8phBIxFzBm8WbTQyc0Y2fM2lWcTjz1nT/NcXlVzYzOf6+JPIsBIJ4j0fjRKxnQ3MaE+
8SoOTmUi9zM0GE83SfzMhtz57fRzwYF7S48ZjAa2kiG+SpvMhQ4kvFFxEyBNlf/nZFFLhes6o6Bs
A61m8ih2boF2XxhgujS9Tdg7TMd0sf/X5hsAAP//AwBQSwMEFAAGAAgAAAAhAAjDGKTUAAAAkwEA
AAsAAABfcmVscy8ucmVsc6SQwWrDMAyG74O+g9F9cdrDGKNOb4NeSwu7GltJzGLLSG7avv1M2WAZ
ve2oX+j7xL/dXeOkZmQJlAysmxYUJkc+pMHA6fj+/ApKik3eTpTQwA0Fdt3qaXvAyZZ6JGPIoiol
iYGxlPymtbgRo5WGMqa66YmjLXXkQWfrPu2AetO2L5p/M6BbMNXeG+C934A63nI1/2HH4JiE+tI4
ipr6PrhHVO3pkg44V4rlAYsBz3IPGeemPgf6sXf9T28OrpwZP6phof7Oq/nHrhdVdl8AAAD//wMA
UEsDBBQABgAIAAAAIQD4yPehcQIAAEUGAAASAAAAZHJzL3BpY3R1cmV4bWwueG1srFRLbtswEN0X
6B0IFuiukWg7dqpaDowYKQKkrdEPuh5TlMWWIgWSsZXcpmfoEXKxDkUpgYMuirgLCdQM9d6bmUfO
z9takZ2wThqdU3aSUiI0N4XU25x++3r55owS50EXoIwWOb0Vjp4vXr6Yt4XNQPPKWIIQ2mUYyGnl
fZMlieOVqMGdmEZozJbG1uDx026TwsIewWuVjNJ0mrjGCihcJYRfxQxddNh+by6EUstIIQrply6n
qCFE+z2lNXXczY1apPMkiArLDgEXn8pyMRmfselDKkS6rDX74Y+wHGIh3wNhuNvdoT5SefMAP+x8
Sskm03E6YX8nHcfwU1LG2HTW/3LAPPA1kkdivVtLvra9io+7tSWyyOmIEg01juiqhq3QhFFSCMdx
KJeh/a9ftct33WsVorLh8v63JrhTWCiAwI039f0vLzmCaC8INzo8pQR9B2QDP4Amj5xRAWSo6trw
n643ATzDAjVIjdrNRQV6K5auEdyjFQNbHCiWGOm6z4PyN0o2l1IpYo3/Ln31pYIGW8DQIJCF5NG6
orn/ydqmLCUXK8NvQgejv61Q4PFsuUo2jhKbiXojcFr2qsABcTxaHvU2VmofCobMWf4ZG3C0bmzh
mL2dTijZhNVpOuvxvRWeV8fiD8MZBhCd4Ro042b/wRRYVHBUN4e2tPWxfKE12F/S5rQ70JTc5jSN
JYnWE44JNhmPTqd4g3HMnTI2G0UTQRYUBITGOv9emKPVkACEQ8RBdRXC7tr50JJHikCnTefNaKFn
H43OFkr/jw5GQVGo0v35CkPrlw93DFcSLbwCD8OgD+7jfnu8/xd/AAAA//8DAFBLAwQKAAAAAAAA
ACEAaG6tinkcAAB5HAAAFAAAAGRycy9tZWRpYS9pbWFnZTEucG5niVBORw0KGgoAAAANSUhEUgAA
AVYAAAFRCAMAAAAYdHUJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAALMw9IgAAAD/dFJOUwABAgMEBQYHCAkKCwwNDg8QERITFBUW
FxgZGhscHR4fICEiIyQlJicoKSorLC0uLzAxMjM0NTY3ODk6Ozw9Pj9AQUJDREVGR0hJSktMTU5P
UFFSU1RVVldYWVpbXF1eX2BhYmNkZWZnaGlqa2xtbm9wcXJzdHV2d3h5ent8fX5/gIGCg4SFhoeI
iYqLjI2Oj5CRkpOUlZaXmJmam5ydnp+goaKjpKWmp6ipqqusra6vsLGys7S1tre4ubq7vL2+v8DB
wsPExcbHyMnKy8zNzs/Q0dLT1NXW19jZ2tvc3d7f4OHi4+Tl5ufo6err7O3u7/Dx8vP09fb3+Pn6
+/z9/usI2TUAAAAJcEhZcwAAIdUAACHVAQSctJ0AABf3SURBVHhe7Z0JfBXV1cAnCQmJLALK4i7G
NYJLBEWlIqBUwAVFsaXFFkHl07qBfiqLC4pgC61rqZ8rrqDUrXEDK1htVURFAWVVQER2QiJrknd6
tpm585bkRRIIfuf/+5F3zrl37ty5b+Yu5555eIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZh
GIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZh
GIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGIZhGCnJrJeTG5KDSv3cPCI3S3MY
lfGrIbd8vnTZevhplC5buvSVmwcPaa2l/T/m3FFF84u1WWqHDd/Mn/bgqCuP1BP+jDmg19Xb9KJ3
EfMuH3DkAdland2fnMYj9cISiJUUb3hlxPBhh2jW1AwdMaKNiinoMWz4iOFvrNywobi4dLuWn5qR
V++ZoQfuNmT9fd2m0uISvYIoK357dutmDTVjbZLRpFnB6d26ndn5lGPzW7TKP7XHeXO0CnHE1v9d
D6mTFBQMqtCaRlkybVDLHM20y8nIyKh//u1z58yZt2CZ1i/kNs1Uh9Ca+Xx1h9rrOIM+du+FrWRq
3r7//ff1a9+e03c6GfWbdfxQavM8qvRZfHLbtm1bSPJuyDnwpOd9zFfk8+HO6K98rt6sZw3QhJ8B
HfWKAjbsoSm1SGP6o+cj1r3QYx9O+LmR02PiIr1GuWfWkPRBf5ZrkMyeS/gceJI9eAb6r3aa8rOm
Q4eWIvC1M1ue2VNMO8yPWiKyQk21Q2ZOfuHxg26/qrC+GojD+MTzgk4759ihpWyC2JxHuhcevXdO
dg6iqbVEi0s/k3MyatwxcrSwksduqtFJdJ+JC2TmHmM1j2WBDcxatSDr2dBUtXg40WfBwlt/o2LN
kj8eT7VdleqT+YZUdjApFeW1cC9I+YxaQtPBavA+UoPyOBtViYOTfNRGLPnylWG3NFV7jdGIis5V
JW24Qsg81X8y+1wR5wv4OOiZjlcL5KshPK2qmaLxzXEyi/eyHSDJyoNTfNSWHClkx+jMJR2hWtps
h62jedzfIe7nk8eTqaln4uNPuqrIgTCQDFtUBfgCtY2inEQpkhegJ8m/K8jL5V7p8iDFhwwpGeOk
b7mhsNr3nHArHa5yLfMsVxV+UBURA7dUi374OY2UPkHi/5GqGiHNeo4o2+EyN5lkUcohm5UInOLj
fxmZLQ7WZAdaAaoYsPK5B6v2+Owa6Nby2Uttfv3vF+07eJq0Q0UD4PFHFEaa9TSWM6A9KQWsIKRI
3q+kWVlmGm0P7nCB87pUfD22tddg8DSajZLTO8n3gsjBdQutmnKZWi8EuAfVi1UdD/tTqigzgEd/
URhp1uNYrqgYG0klRbR345sVE5eqIAAMU8n7Ht6jzPPC7pjNeD+r6sApu4acBkSCQzhDKhY7xjuu
nKU7NQFgKGpHq4YP8PWoSjfxOnBbsSxUDCKDTMEB+16Aq1gmilA7laU7IYuSWPb5i34KMEgF+g46
YN65opxC+xIsbYQ7qIyW2LN2LfWbnFNC5pFtaucGqtYOx38W8QXEogOqWlnutoXEM1jGBGrxw0VB
oFWQr1dCs5YOXoGGPBILEhKbtdPB7jYuMr4RXGbqJ7ICTsW816lG9eGPNVI8s23TrBmzSeCUEE4k
OqihpqE7LJFgeon3hNyiqg07MFTwE+WwWTevno76UyT+MqHlVr/4DBq4WaW7SDrz3j/huEoA6Ip5
B6iGyHGrnDIa9n56OSlxJV4k3x7yT7V4B3auSQ9dT2k0RC7zLIBHSOvLGgHdSK9QzSujKecSFiu4
/vL0EnsBrdrKWU5oni//8yQauFkBXkBxNJvjqVazllMn1Eo1RHr9HxLKKIfVKimwtTtlQRarBVua
eecnugUyshoelH9gPdUIKS8YelbAoA2oHqTqSzwB1U6ROJxUltZy/S9lmXGuJ+HSZjjN2pvWrWxN
gI8rU6UKYM1DycpJbFaP/K0uPE/hC5ObgBhDKsBXqqZN7tBv5UghGAn6wzY6Q/AwfRCpFpxDilPJ
zbSG4mreyxnvZisDp1NWXg4nXFrvGfehQZp1XzofWxPg48h7ngawhCbHqoRIJ3CNasyl/jpF+B+g
R+75ad/4TgtCu4VwxG4+8FyVUtLuczkoQjNNhNjDqL2tGuqLr0H9NVXkdKIQbwQNJuPSo2xlFj5K
PkaefCc0a+PPz0WDNCsvXdmaAB+XvH9IAK6i/kqVEBmy2qqWDJh0L8Dsk3gFoyYEYO2ysFE87xBM
xSdnvKqJjOAMRIy7jk44+aQ+Vac4EKNledisGU6btBdZl5lE4yAxnyenj7GV6QnUdJ+RCPX8XEqD
NUehQZo1LD4BThulShVAm1eTlbO+jM4dNk8ifBL86O8ejt/1uTghmq6q5x2LqUzo2YhHOsjwO5wJ
569GVdaSM/g0pSwzPzagvLyivhv2JFnGKGEI+dMPQ6EpFOCkyZnxZAAvKEmEPXxJyYIj0UDN2pJP
t03M8XCaPzG+y5mQJAEODuaqLmWLmiUzh3T1m5X2YdTmefVRjnROKDOqJgWTyWX9sqrecC5aDjnH
kZkW792J+hQS8WuntJvYLkzHJ0i6LmjzdeRG9sK1FZwc338GzdqaT1ci1ng4TWf4w+EoEVIA/O2r
EgJTqmhW6PAvgBfx82g3X2OU3fKuJQWpdAxrhDMhzPO+qp5XPOs81ItJrBffrE6FkzTrD1ejYShJ
cN0A/LbYKIQFwdvUzbJR4WaluaE06+dijUdK8Aknb8mAXMqjSgiMoXmXKsngc+CzCHiDhvkmokzl
naU6yUTlwXXAy8LvVUPCJvBgv0AUwjRt1v9ls7CNEieQBHf9Ojobco5b97ZKPtys1AlJs6YY7aUE
nzPVmhweTfnGiACdhqNdlSRMXkE1QYGHTrEhOE3i0VlnsiQyoqYC0zHPZtWQdw+nhShPq+Csl6LH
u83ahMS72CxwotytD9EwxEbBOe7HN6NJ0qwnoiDN+pBY45ESfKroBCjvJ6qE8GgZzP/96XgI4PKA
B2g4ADOKDUEZuzAccVg7BeBDAHL3spqSCwE7D2eahsvJ09AgbTCVnMdsFMLmuUe+wkgHSvOGG1gq
o/GMjYLTrLH4qTo3aycUqnG3Vh5xyXk/UiWEzf6FbsQ+NMq+nE7rIShEIdjDA5h6EFAjqQZ4AdTO
rKYkA/CBTdEGZbB3kqSuJOkEi4NtlDIKFKSZAA6c1LuxUQiLnAG4DHaTwmZtxblSjASc1k3kFZXO
kjSv2z0JUgmfSWoNKLmRfGkkAY5cwYYGHtT332gHmIYKDu8HzcLE0DGfCnjzfC1OkdOT9AmL6oEm
uAnkhMBbZu5xP9AEi6UYH8eiEBb5TvJm/T0KmZyrspmA79+OHJ8I5x2oSohUwudZtfrIpHwhiaWL
sTcIlvFYW/K8LKda43O82dvKrpyqfASwiTzEqhCrg8VOLp9qCFuJgTAheIzgAsrlHjc50MXXwqIQ
OqGnAG21sVHhZuWLrGSVlcclVhHxquzBeXupFtCIzQHxsSQvxyiZb5mpW7cDBBFDWCP62ptTzTAH
/ylKUU2HRXw6Z8WwLPQYc9IaFokYuUaPF/nd8tcpW+hqwcsBeJilwXwci4JcEUnXs4uZjQo3K+/3
wjF+rgR6cwkdVauc07iBmqgW0EQq4aPWANiPdpBYnFpeCuB7ss9AI3sE8FstY6cHwJ+xL9DklIzi
012iGsJuPDmMk4KZ0kiY4UxHIZ+yhfvfR/3JP8rry8eJzLA+i6QzgDxdbFR4V5AfAXhuU1ya118D
+EZyCYkPdjLuKo5MkHzGhJU6ZmZCurjQxcvaj8Z96paIxzAr58ZKyvEQP+IkJZsLnKgaws+ieFnh
wJXh4Infm1vcUlpUOTq5hb8QUe4tkRkukl2KHeKTPHgFDWwBoKBINgpP+CneeD5sJMtV8cxifGAj
p2Bkpq3KgPh0mP6bIPViatZFInsLYT4+hiiwX59Wg6g5y9KUgPdlpBpwIqoy6EKvB4IkvkZ3Igbk
0Qv7KFJUPI8bwf++abJHF6pDHSVdyKJAx4nj4XYgL0YRWwla7OgO7lw+LD0PFszujXlVCYEKerxU
8dwLIbh8gHIOOKJmXcVmqt41veQwTH4dP+5HzdkdTgkUXeecz1sMtBwQee1b1GGSxKEH0etST45q
NCnx+yNxJgT7Ft4sGBVkZF+LE7zfEFWAG0nMEPcNmwmceiO8AFxSnWbtE71NFLjyhmRm4b0K9qy5
aArAIZ+IorZ1+OFMa1OCk8+wFLxFaFPyA1GKtvPgHCJDkvI7Nr3LMq0pGrGEnMiNsEk1vDXIm6Pb
+kA+XOfqsLtG5MvnIRGCtwbZAcHTRVxFUImOZ9zzwuLjgB7YczlnUOA8bJ5EswA9vqNzufgptO5h
H09bMVXA7NdSluPwDVdZFZ4FBJq4yiBGuy3KBk0ijmDLOyiRu0ZsRGde2YYuPvglqieLXAYUUyky
IQFb0kH8HshbEz6fb1GSuGJL+6LoLkjvTHllsGf4uDnAPjiQpzios1xnBEnphkJ0tgZwPc5cVamE
S7hMmTexAy88aC9Okq1hqhQR7vIgdF8IJ6mFOMeNuKCv+dJQywbahfubalRLwld4+0diMYggCdbS
mjco0fOecpUIOdJEqgXkJ3h6HWALh3jxczKAJIQTvG/5OdFJJYMpQWplNOZ8dKF7a3BuuFHISfNF
3hfyOCzkY1GVffutXt1tf1WUXtFmJVlcWwRwhKsqkhYExBwCU0hVzSNHnjgKYVXiK4mckEiCl1gY
ktzM5EID6vlU05hpkXFGeROAE9N8NKYAfKlaZUDDxVyQ4joRIo7xHGgynzIEy+VU9AYai/3DngeK
WVWFvh1GFJHDBcejYhBfJjuMWZLwbPiIdhkzBlx+Oe2phSVG+VScQKoFbKqkWVdy2oOqYa1w2R9U
kB55J6JnCd51TmBSJcCJNFAr30cajZ1lQV007ERipF1aTXKnTF4fGEb5mrNCXnHtIQWOswJ4tR42
P+OWx9M45NHTKFLIv09YjIdTEtkCnZKloiXe/LV+evBXChJSBXlgJj5R/NXi1IQOY6uA2iXpzK8w
559pxCE2x7+VBK0ppEYVVGNJ74TyenhPq0z0lSntH0mWYKcgnJBgB3iIu8NAsywXsdETk4ikJZAi
FYCiZ9z7bqyfR9ZfzhEdYzhY8m4A2SNJaJkdvdiU8G2dPCe89Q4mBevrDGhFdy/vZoW0pcm+WwDl
Ibr/W4X4OF3n6YiMgEweB0chFSeIYbTqcUhiPJoI8W/+QLHz7n3ZR+/Ti3t+0nqqTxhR5zWF53gd
xT4KQu1IO4lEUq1Slsbf6CHw412Y5O94UqV5U0A1pYR9V46R1ZDhao7Q7akZa758WuJa06J+i4ND
N2u9U/rfo2IEumRFLYq+wz31ZG+/LhNE9rMckxBzmwUXi0FCTNyYjRK0o0G1SjmLc36oWgQop6VO
6KxuLnuo0b5CwwpfUTX6zK7ZW607h8zXN+rp/UU9Ebeo2brsVdrW0sYBIHdA5Klxm65l0Xc/Bs3Y
Eu24zEqrWfO5FHenNAAqaAPCKQVWXhE1IFfStBRgpaoTWQNYPrlZlXOGnYTWKB5Ou41dlfASK0qq
OzIIRFa9UrKdANQ4IAycELrzGePyksVdrNZBDrvNX86EcIX/ApD4qkU5RUMmuydyyfuJpNN5ZYin
X7UIABy36oSawIX0kIULIaYXZQpnn3WbvQrv/mwdjaorPO/qoMPSRGH182hJ6dgp+OP6pI0VD0yg
uN79VHNogT0mnzQsZpIE5qvmc9+qSKzBbsPooFn/oBamLeACKX6OsoSeaZXTArb8Ao+Ii/Uk+IRM
6P9IuuM0ErvXR1TezcjsyB6dqAMWuiRc4zBx/6qWDgD8ZplqIVyOEixpn8bFnBOFLVSsrd4XWdfh
BbDKCtCOUCQauioA2tARqgWw2wOZOfgAtTBifFM15sjBaFG5GuQVFrYfMW7cuG+kyCooGTtu3JXt
Cwt3wq8oeBtpdnCLKoJUAmarmgb66mO4SyKM2jb3xmSv0nDxzlsEXi4sBShUpVL2KDh7Au0j1Bgl
UyY8ckFBQYuqvfXV4oKltH5QRZDzQT9V00CPSPd+k73B0KHdx9+TTM2ABdv9FW3tEqso216yYN74
iBPiJwAUc62ysI+cQLU04B6AOVstVXCVZt/64OmdpsoUOemk9WZq7lgw2CZl0+x3mScGdu3SpfP+
WZXedhlZDQ45oQvStd8kPCbiz0xCBZ36h7Qeo3hKaFf/CVUE3lp7RpWqkREOCV32VaJHBIQvCox9
vaho4lQ1R1k9edLQHjX6mlMSTugxfLI6AKL849mioqIwQqcKmvCemyoKlaJiGtwwc+Z9qcPgU9DG
rbr/fraqSmzVTOYY9/dCdibtZn676DOsQOTn5CjkMx0q6B0x57USzzupr7zqXcs0lHtySuh3YZ34
W2YNDyE7TGZeA6xS1kJ+AXkVdg4VJf2dF+ISEb+vKgz91IGKtUCna1VIpNkpR+8Wv2HLL+gKs9wX
/CLwW8XOIoFiqFSsYfIu4438NCP36jCZv/ok8Lygyi9S3epsHDCc6rdrLwo16qJKjYJzU6XaPXEd
J/jpzGVqEGQKc2OWV38AlOcD/ELtNcbYcfiHT0KkfG52W+r7vykd9QwsUKtQaVdcfeZSmXnUrLXv
6M8InJyN3p6nb2dkZ/PjWdsu8cYt9AeAaCK+XMTs8PcUJoulppCC0wuBTId96c8dw0eOWVoh0Vv6
GNCON4dYyCYDwNLZGifcVoaKJf77jJydvfmw8VXPu7ZNTXf19Osu61TGNc0do0ekF1hbLQYOqMY+
XlL2yj/9r49x0/ix7hDbBIsW+gNrKQk0UX8BhTfYKn7icskBMILevYM/seaN964Er+MclF6m/qjE
zyRF1wjTd/SSa49bZm7cul3ijIJLjuFf2h1v4B3qvOnBzUpQszbgaC7Zathbglv5YBw/XiCFoHzU
JzxO8ZAb5Ggoz64fvjREQXdl7ms4uzVtOr+2sJxjVRGAnm/IrxNwm9ICIbyfMhyPVzEs3MD+21GY
vIWy1IPnSPf4daJhcDB8ej60hqlsQ+ZoMe/Qj5wUiyIvgAfAwKZnc4KccttbT5y0MxyKNczTUnuA
aa896b9rQCb/vWMvm1/6fgpvIh33/MBM5Dso+gePEX1o/5FNQM84ftCOxTCgXf4yL3SdayZsVoZl
gNLJ4Qxon2BuLb/rdC2Ff1JQUuP/PF/Xp4c5R1HAaXPe9JEXNy4KY37pQtt8J5dMgYgSY5ezzA+L
h+78QdDNxzFaB4A3UmKfpK3e5L/r8C/pic36T/r0O+AZLzq/N3Y4TNCRTJ6XhygT983+se2+aNe8
ruy3h5wnc2USedQUsRUcelBPEgjOwL8qsAgTg1b03/YIX2r4RK+U3vHRgoZQ7P4fZDymZh2DE+fE
Zl1An36zXs8fytlQrpnE3T5Bj0DdD2eg2kWnqXWAttdT4DnD9ZeL4KA1Eoj3UbqJtbn0l2Jg38d/
IIF6weUFYzmt4x73MiFG01QKNNExyi8xLDliqRAFzucP5Tk08jtRRwH/QDuVpvn8QFuaomm/XKfw
L05XKCy7gZ9d0XQdv7vwABxx+QLqJXgSzIkPb9sS/EJs62r+GFKjQwv45y+y5mxuRS8YkMy//aYV
Ql7yxTbyFiUl/ZaEDJqsEbn81rP/yw91CP8qltOnKvz6mw5KnaFYAze2QKx4ndydP/HnpNLi1GCq
ENTNGy0RsoHeHHS7sxX/FGtgrztM1Co9SZ/+7BGGrwNdBAJMvyPhFcmdRWP1nWtUCTVfbwp8PMN/
H+cijg6tS83aWn5z90YNse5FVbsN6FeTyfe7+Iq65sL2vJ7sBiTpU8DVM8U8PEXqubQ3tZVMdQAc
mOijQB2Ej9FMfP6TN7NS1/mI3iGlgFvAxjyOL2R53VqN/bouPUHVZU/+f3OSBp/uYpy3LAzDMAzD
MAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzD
MAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzDMAzD
MAzDMAzDMHY9nvdfXy6jni7gvJ0AAAAASUVORK5CYIJQSwMEFAAGAAgAAAAhACqQg6QSAQAAhAEA
AA8AAABkcnMvZG93bnJldi54bWxskF9PwjAUxd9N/A7NNfFN2sEGiHSEmCzxRSNoor41692fsLbY
Fph+espw4cWn5tzb3+k5nS9a1ZA9WlcbzSEaMCCocyNrXXJ4f8vupkCcF1qKxmjk8IMOFun11VzM
pDnoFe7XviTBRLuZ4FB5v51R6vIKlXADs0UddoWxSvggbUmlFYdgrho6ZGxMlah1eKESW3ysMN+s
d4oDfWafX1mSbSbx9+ZD3u+0fY0157c37fIBiMfWXy7/0U+SwxBOVUINSEO+tlnqvDKWFCt09W8I
f54X1ihizYFDKJubpjuDfikKh76f9mo0jRgDejL05oyN/sUiFk8mSbfq2Sgej6dJR9NLnnQexOXz
0iMAAAD//wMAUEsDBBQABgAIAAAAIQCqJg6+vAAAACEBAAAdAAAAZHJzL19yZWxzL3BpY3R1cmV4
bWwueG1sLnJlbHOEj0FqwzAQRfeF3EHMPpadRSjFsjeh4G1IDjBIY1nEGglJLfXtI8gmgUCX8z//
PaYf//wqfillF1hB17QgiHUwjq2C6+V7/wkiF2SDa2BSsFGGcdh99GdasdRRXlzMolI4K1hKiV9S
Zr2Qx9yESFybOSSPpZ7Jyoj6hpbkoW2PMj0zYHhhiskoSJPpQFy2WM3/s8M8O02noH88cXmjkM5X
dwVislQUeDIOH2HXRLYgh16+PDbcAQAA//8DAFBLAQItABQABgAIAAAAIQBamK3CDAEAABgCAAAT
AAAAAAAAAAAAAAAAAAAAAABbQ29udGVudF9UeXBlc10ueG1sUEsBAi0AFAAGAAgAAAAhAAjDGKTU
AAAAkwEAAAsAAAAAAAAAAAAAAAAAPQEAAF9yZWxzLy5yZWxzUEsBAi0AFAAGAAgAAAAhAPjI96Fx
AgAARQYAABIAAAAAAAAAAAAAAAAAOgIAAGRycy9waWN0dXJleG1sLnhtbFBLAQItAAoAAAAAAAAA
IQBobq2KeRwAAHkcAAAUAAAAAAAAAAAAAAAAANsEAABkcnMvbWVkaWEvaW1hZ2UxLnBuZ1BLAQIt
ABQABgAIAAAAIQAqkIOkEgEAAIQBAAAPAAAAAAAAAAAAAAAAAIYhAABkcnMvZG93bnJldi54bWxQ
SwECLQAUAAYACAAAACEAqiYOvrwAAAAhAQAAHQAAAAAAAAAAAAAAAADFIgAAZHJzL19yZWxzL3Bp
Y3R1cmV4bWwueG1sLnJlbHNQSwUGAAAAAAYABgCEAQAAvCMAAAAA
">
   <v:imagedata src="formato_liquidacion_files/PROPUESTA%20LIQ-1(1)_26760_image001.png"
    o:title=""/>
   <x:ClientData ObjectType="Pict">
    <x:SizeWithCells/>
    <x:CF>Bitmap</x:CF>
    <x:AutoPict/>
   </x:ClientData>
  </v:shape><![endif]-->
								<!--[if !vml]-->
								<span style="mso-ignore:vglayout;&#10;  position:absolute;z-index:1;margin-left:4px;margin-top:0px;width:150px;&#10;  height:56px">
									<img width="150" height="56" src="./templates/formato_liquidacion_files/PROPUESTA%20LIQ-1(1)_26760_image002.png" alt="Forma&#10;&#10;Descripción generada automáticamente con confianza baja" v:shapes="Imagen_x0020_1" />
								</span>
								<!--[endif]-->
								<span style="mso-ignore:vglayout2">
									<table cellpadding="0" cellspacing="0">
										<tbody>
											<tr>
												<td height="15" class="xl6426760" width="163" style="height:11.25pt;width:122pt"></td>
											</tr>
										</tbody>
									</table>
								</span>
							</td>
							<td class="xl6426760" width="61" style="width:46pt"></td>
							<td class="xl6426760" width="83" style="width:62pt"></td>
							<td class="xl6426760" width="68" style="width:51pt"></td>
							<td class="xl6426760" width="55" style="width:41pt"></td>
							<td class="xl6426760" width="74" style="width:56pt"></td>
							<td class="xl6426760" width="129" style="width:97pt"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt"></td>
							<td class="xl6426760"></td>
							<td colspan="4" rowspan="2" class="xl8126760">PURCHASE ORDER LIQUIDATION REPORT</td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt"></td>
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
							<td height="31" class="xl6626760" style="height:23.45pt">Produce Team, LLC</td>
							<td class="xl6426760"></td>
							<td class="xl6726760"></td>
							<td class="xl6726760"></td>
							<td class="xl6426760"></td>
							<td class="xl7426760">Purchase Order:</td>
							<td class="xl7526760">0002232</td>
						</tr>
						<tr height="19" style="mso-height-source:userset;height:14.45pt">
							<td height="19" class="xl6426760" colspan="2" style="height:14.45pt">
								5300 George
								McVay Dr. #130 McAllen
							</td>
							<td class="xl6726760"></td>
							<td class="xl6726760"></td>
							<td class="xl6426760"></td>
							<td class="xl7426760">Rec. Date:</td>
							<td class="xl6826760">21/05/2024</td>
						</tr>
						<tr height="19" style="mso-height-source:userset;height:14.45pt">
							<td height="19" class="xl6426760" style="height:14.45pt">Texas, TX 78503</td>
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
							<td height="15" class="xl6426760" style="height:11.25pt">Phone: (956) 606 4476</td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt">Fax: (956) 253 7457</td>
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
								Requested B<span style="display:none">y:</span>
							</td>
							<td class="xl6426760">DS - Diego Sierra - PT</td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt">GRUPO AGRICOLA ENCON</td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" colspan="4" style="height:11.25pt">
								GUATEMALA, SAN
								BARTOLO TEONTEPEC SAN BARTOLO TEONTEPEC
							</td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt">Puebla, PUE 75809</td>
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
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6926760" style="height:11.25pt">Description</td>
							<td class="xl6926760">Pack Style</td>
							<td class="xl6926760">Size</td>
							<td class="xl6926760">Label</td>
							<td class="xl6926760">Qty Rec.</td>
							<td class="xl6926760">Unit Price</td>
							<td class="xl6926760">Amount</td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl7026760" style="height:11.25pt">Tomato - Roma</td>
							<td class="xl7026760">25 Lbs</td>
							<td class="xl7026760">XL</td>
							<td class="xl7026760">75</td>
							<td class="xl7126760">240</td>
							<td class="xl7626760">12.70</td>
							<td class="xl7626760">3,048.00</td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl7026760" style="height:11.25pt">Tomato - Roma</td>
							<td class="xl7026760">25 Lbs</td>
							<td class="xl7026760">L</td>
							<td class="xl7026760">75</td>
							<td class="xl7126760">385</td>
							<td class="xl7626760">12.40</td>
							<td class="xl7626760">4,774.00</td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl7026760" style="height:11.25pt">Tomato - Roma</td>
							<td class="xl7026760">25 Lbs</td>
							<td class="xl7026760">M</td>
							<td class="xl7026760">75</td>
							<td class="xl7126760">975</td>
							<td class="xl7626760">12.00</td>
							<td class="xl7626760">11,700.00</td>
						</tr>
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
							<td class="xl7326760">1,600</td>
							<td class="xl7726760">12.20</td>
							<td class="xl7726760">19,522.00</td>
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
							<td colspan="7" height="15" class="xl8026760" dir="LTR" width="633" style="height:11.25pt;&#10;  width:475pt">PRODUCT ADJUSTMENTS</td>
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
							<td class="xl6926760">Qty</td>
							<td class="xl6926760">Unit Price</td>
							<td class="xl6926760">Amount</td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt">Dumped Cases</td>
							<td class="xl6426760">ENCON</td>
							<td class="xl6426760" colspan="2">GRUPO AGRICOLA ENCON</td>
							<td class="xl7026760">100</td>
							<td class="xl7626760">-12.70</td>
							<td class="xl7626760">-1,270.00</td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt">Troubles</td>
							<td class="xl6426760">ENCON</td>
							<td class="xl6426760" colspan="2">GRUPO AGRICOLA ENCON</td>
							<td class="xl7026760">50</td>
							<td class="xl7626760">-5.00</td>
							<td class="xl7626760">-250.00</td>
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
							<td height="15" class="xl7926760" colspan="2" style="height:11.25pt">
								SubTotal for
								Product Adjustments:
							</td>
							<td class="xl7226760"> </td>
							<td class="xl7226760"> </td>
							<td class="xl7326760">150</td>
							<td class="xl7726760">-10.13</td>
							<td class="xl7726760">-1,520.00</td>
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
							<td class="xl6926760">Qty</td>
							<td class="xl6926760">Unit Price</td>
							<td class="xl6926760">Amount</td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt">Freight</td>
							<td class="xl6426760">AMB LOG</td>
							<td class="xl6426760" colspan="2">AMB LOGISTICS</td>
							<td class="xl7026760">1</td>
							<td class="xl7626760">-3,150.00</td>
							<td class="xl7626760">-3,150.00</td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt">American Crossing</td>
							<td class="xl6426760">JOE</td>
							<td class="xl6426760" colspan="2">
								JOE AREVALO &amp; ASSOCIATE<span style="display:none">S, LTD.</span>
							</td>
							<td class="xl7026760">1</td>
							<td class="xl7626760">-52.38</td>
							<td class="xl7626760">-52.38</td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt">Mexican Crossing</td>
							<td class="xl6426760">Inter</td>
							<td class="xl6426760">Inter Enlace LLC</td>
							<td class="xl6426760"></td>
							<td class="xl7026760">1</td>
							<td class="xl7626760">-290.48</td>
							<td class="xl7626760">-290.48</td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt">Inspection</td>
							<td class="xl6426760">TCIP</td>
							<td class="xl6426760" colspan="2">
								TEXAS COOPERATIVE INSPEC<span style="display:&#10;  none">TION PROGRAM</span>
							</td>
							<td class="xl7026760">1</td>
							<td class="xl7626760">-396.19</td>
							<td class="xl7626760">-396.19</td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl6426760" style="height:11.25pt"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl6426760"></td>
							<td class="xl7026760"></td>
							<td class="xl7826760"></td>
							<td class="xl7826760"></td>
						</tr>
						<tr height="15" style="height:11.25pt">
							<td height="15" class="xl7926760" style="height:11.25pt">SubTotal for Charges:</td>
							<td class="xl7226760"> </td>
							<td class="xl7226760"> </td>
							<td class="xl7226760"> </td>
							<td class="xl7326760"> </td>
							<td class="xl7726760"> </td>
							<td class="xl7726760">-3,889.05</td>
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
							<td height="15" class="xl7926760" style="height:11.25pt">Totals:</td>
							<td class="xl7226760"> </td>
							<td class="xl7226760"> </td>
							<td class="xl7226760"> </td>
							<td class="xl7326760"> </td>
							<td class="xl7726760"> </td>
							<td class="xl7726760">14,112.95</td>
						</tr>
					</tbody>
				</table>
			</div>
		</body>
	</xsl:template>

</xsl:stylesheet>
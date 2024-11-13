<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:xo="http://panax.io/xover"
	xmlns:state="http://panax.io/state"
	xmlns:searchParams="http://panax.io/site/searchParams"
	xmlns:selected="http://panax.io/state/selected"
	xmlns:wizard="http://widgets.panax.io/wizard"
	xmlns:fixed="http://panax.io/state/fixed"
	xmlns:container="http://panax.io/containers"
>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="wizard.xslt"/>

	<xsl:template name="format">
		<xsl:param name="value">0</xsl:param>
		<xsl:param name="mask">$#,##0.00;-$#,##0.00</xsl:param>
		<xsl:param name="value_for_invalid"></xsl:param>
		<xsl:choose>
			<xsl:when test="number($value)=$value">
				<xsl:value-of select="format-number($value,$mask)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value_for_invalid"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:key name="wizard-section" match="model/freights/row/@*[namespace-uri()='']" use="1"/>
	<xsl:key name="wizard-section" match="model/freights/row/*/*/@*[namespace-uri()='']" use="2"/>
	<xsl:key name="hidden" match="model/freights/row/@id" use="generate-id()"/>
	<xsl:key name="readonly" match="model/freights/row/@id" use="generate-id()"/>

	<xsl:key name="wizard-section" match="/*/cotizaciones[@tipo_cotizacion!='']/@*[namespace-uri()=''][not(name()='tipo_cotizacion')]" use="2"/>

	<xsl:key name="wizard-section" match="/*/cotizaciones/cotizacion[@type=../@tipo_cotizacion]/@*[namespace-uri()='']" use="3"/>
	<xsl:key name="wizard-section" match="/*/cotizaciones/cotizacion[@type=../@tipo_cotizacion]/detalle/@cantidad" use="3"/>

	<xsl:key name="wizard-section" match="/*/cotizaciones/cotizacion[@type=../@tipo_cotizacion][@type='vida']/detalle[@fixed:tipo_persona=../@tipo_persona]/@*[namespace-uri()='']" use="3"/>

	<xsl:key name="wizard-section" match="/*/cotizaciones/cotizacion[@type=../@tipo_cotizacion]/detalle/@especie" use="4"/>
	<xsl:key name="wizard-section" match="/*/cotizaciones/cotizacion[@type=../@tipo_cotizacion]/detalle/@nombre_maquinaria" use="4"/>
	<xsl:key name="wizard-section" match="/*/cotizaciones/cotizacion[@type=../@tipo_cotizacion]/detalle/@nombre_bienes" use="4"/>
	<xsl:key name="wizard-section" match="/*/cotizaciones/cotizacion[@type=../@tipo_cotizacion]/detalle/detalle[@fixed:tipo_cotizacion_vida]/@especie" use="4"/>

	<xsl:key name="wizard-section" match="/*/cotizaciones/cotizacion[@type=../@tipo_cotizacion]/detalle/@*[namespace-uri()=''][not(name()='especie')]" use="4.1"/>


	<xsl:key name="wizard-section" match="/*/cotizaciones/cotizacion[@type=../@tipo_cotizacion][@type='vida'][detalle/@fixed:tipo_persona=@tipo_persona]/@tarjeta_bolsillo" use="4"/>

	<xsl:key name="wizard-section.fieldset" match="@parentesco" use="4"/>

	<xsl:key name="wizard-section" match="cotizaciones/@numero_cotizacion" use="5"/>

	<xsl:key name="type" use="'money'" match="@base_freight"/>
	<xsl:key name="type" use="'money'" match="@suma"/>
	<xsl:key name="type" use="'money'" match="@monto_asegurado"/>
	<xsl:key name="type" use="'money'" match="@cuota_total"/>
	<xsl:key name="type" use="'money'" match="@suma_asegurada_cabeza"/>
	<xsl:key name="type" use="'percent'" match="deducible/row/@desc"/>

	<!--<xsl:key name="wizard-section" match="/*/cotizaciones/cotizacion[not(@type='ganadero')][@type=../@tipo_cotizacion]/detalle/@*" use="4"/>-->

	<xsl:key name="invalid" match="/*/cotizaciones/@*[namespace-uri()=''][.='']" use="generate-id()"/>
	<xsl:key name="invalid" match="/*/cotizaciones/cotizacion[@type=../@tipo_cotizacion]/@*[namespace-uri()=''][.='']" use="generate-id()"/>
	<xsl:key name="invalid" match="/*/cotizaciones/cotizacion[@type=../@tipo_cotizacion]/detalle/@*[namespace-uri()=''][.='']" use="generate-id()"/>

	<xsl:key name="control" match="model/*[row][count(row)&gt;=6]" use="'select'"/>
	<xsl:key name="control" match="model/*[row][count(row)&lt;6]" use="'radio'"/>

	<xsl:key name="container:fieldset" match="@nombre|@primer_apellido|@segundo_apellido|@curp|@fecha_nacimiento|cotizacion[@type='vida']/detalle/@edad" use="3"/>

	<xsl:key name="wizard-state" match="@type" use="generate-id()"/>

	<xsl:key name="dim" match="/*/*" use="name()"/>

	<xsl:param name="searchParams:tipo"/>
	<xsl:param name="state:edit">${xo.site.searchParams.has("tipo")?2:1}</xsl:param>
	<xsl:param name="state:active">${xo.site.searchParams.has("tipo")?2:1}</xsl:param>

	<xsl:template match="/*">
		<main>
			<xsl:apply-templates mode="wizard" select=".">
				<xsl:with-param name="active" select="$state:active"/>
			</xsl:apply-templates>
		</main>
	</xsl:template>

	<xsl:template mode="wizard:styles" match="*|@*">
		<style>
			<![CDATA[
.custom-file-label {
    height: 100%;
    padding-top: 8px;
}

.custom-file, .custom-file-input {
    height: unset;
}

.custom-file-input:lang(en) ~ .custom-file-label:after {
    content: "Explorar";
    height: unset;
    padding-top: 8px;
}

.outer-container {
    font-family: "Trebuchet MS";
    font-size: 1.2rem;
}

.outer-container {
    padding: 0px 60px;
}

.step-content {
    padding: 10px 0;
    height: 100%;
}

.nav-justified > li > a {
    margin-bottom: 5px;
    text-align: center;
}

#wizard .nav-pills > li.active > a, #wizard .nav-pills > li.active > a:focus, #wizard .nav-pills > li.active > a:hover {
    color: #fff;
    background-color: var(--wizard-step-active, gray);
}

.nav > li > a:focus, .nav > li > a:hover {
    text-decoration: none;
    background-color: #EFF3F7;
}

@media (min-width: 768px) .nav-justified>li>a {
    margin-bottom: 0;
}

.nav-justified > li > a {
    margin-bottom: 5px;
    text-align: center;
}

.nav-pills > li > a {
    border-radius: 4px;
}

.nav > li > a {
    position: relative;
    display: block;
    padding: 10px 15px;
}

a:active, a:hover {
    outline-width: 0;
}

a:focus, a:hover {
    /*color: #23527c;*/
}

a:active, a:hover {
    outline: 0;
}

.nav-pills > li + li {
    margin-left: 2px;
}

@media (min-width: 768px) .nav-justified>li {
    display: table-cell;
    width: 1%;
}

.nav-justified > li {
    float: none;
}

.nav-pills > li {
    float: left;
}

.wizard .nav-pills > li {
    padding: 0px 20px !important;
}

.nav > li {
    position: relative;
    display: block;
}

#wizard h1 {
    /*margin: .67em 0;*/
    color: rgb(126,128,131);
    font-weight: 650;
}
/*#wizard .completed h1, #wizard .completed a {
      color: white;
      }*/
.active > a > h1 {
    color: white !important;
}

#wizard li > a {
    color: rgb(126,128,131);
    white-space: nowrap;
    min-width: 200px;
}

#wizard li.completed > a, #wizard li.completed > a > h1 {
    color: white;
    background-color: var(--wizard-step-completed, #51b15f);
}

li span.wizard-icon-step-completed {
    position: absolute;
    top: -12px;
    right: -8px;
    font-size: 2.5em;
    color: mediumspringgreen;
}

* {
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
}

#wizard .btn {
    <!-- font-size: 1.2em !important; -->
}

.step-content p {
    font-weight: 700;
}

.nav li a {
    min-width: 120px;
    text-decoration: none;
}

.wizard-steps-wrapper.row {
    align-items: start !important;
}

.wizard .nav {
    flex-wrap: nowrap;
}

.wizard table > thead.freeze > tr:nth-child(1) > td, .wizard table > thead.freeze > tr:nth-child(1) > th {
    top: 120px !important;
}]]>
		</style>
	</xsl:template>

	<xsl:template mode="wizard:step-title-legend" match="key('wizard-section','2')">
		<xsl:text/>Registro de factura<xsl:text/>
	</xsl:template>

	<xsl:template mode="wizard:step-title-legend" match="key('wizard-section','1')">
		<xsl:text/>Registro de viajes<xsl:text/>
	</xsl:template>

	<xsl:template mode="join" match="@*|*">
		<xsl:if test="position()!=1">,</xsl:if>
		<xsl:value-of select="generate-id()"/>
	</xsl:template>

	<xsl:template name="wizard:step-panel-content" mode="wizard:step-panel-content" match="key('wizard-section','2')|key('wizard-section','3')|key('wizard-section','1')">
		<xsl:param name="step-number" select="0"/>
		<xsl:param name="items" select="key('wizard-section',$step-number)[not(key('hidden', generate-id()))]"/>
		<div class="body">
			<xsl:for-each select="$items">
				<xsl:variable name="container-items" select="key('container:fieldset',$step-number)[../@xo:id=current()/../@xo:id]"/>
				<xsl:variable name="containers">
					<xsl:apply-templates mode="join" select="$container-items"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="contains(substring-before($containers,','),generate-id())">
						<xsl:apply-templates mode="form-body-container" select="current()">
							<xsl:with-param name="step-number" select="$step-number"/>
							<xsl:with-param name="items" select="$container-items"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="contains($containers,generate-id())"></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="form-body-field" select="current()[not(key('hidden', $step-number)[name()=name(current())])]">
							<xsl:with-param name="step-number" select="$step-number"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template mode="wizard:step-panel-content" match="detalle/@especie|detalle/@nombre_maquinaria|detalle/@nombre_bienes">
		<xsl:param name="step-number" select="0"/>
		<div class="accordion" id="accordion_{../@xo:id}">
			<xsl:for-each select="key('wizard-section',$step-number)[not(key('hidden',generate-id()))]">
				<xsl:variable name="collapsed">
					<xsl:if test="../@state:collapsed">collapsed</xsl:if>
				</xsl:variable>
				<div class="accordion-item" xo-scope="{../@xo:id}" xo-slot="state:collapsed">
					<h4 class="accordion-header sticky-top">
						<button class="accordion-button {$collapsed}" type="button" data-bs-toggle="collapse" data-bs-target="#collapse_{position()}" aria-expanded="true" aria-controls="collapse_{position()}" onclick="scope.toggle(true)">
							<xsl:if test="$collapsed='collapsed'">
								<xsl:attribute name="aria-expanded">false</xsl:attribute>
							</xsl:if>
							<xsl:apply-templates mode="desc" select="."/>
						</button>
					</h4>
					<xsl:variable name="show">
						<xsl:if test="$collapsed!='collapsed'">show</xsl:if>
					</xsl:variable>
					<div id="collapse_{position()}" class="accordion-collapse collapse {$show}" data-bs-parent="#accordion_{../@xo:id}">
						<div class="accordion-body">
							<xsl:call-template name="wizard:step-panel-content">
								<xsl:with-param name="step-number" select="$step-number"/>
								<xsl:with-param name="items" select="key('wizard-section',number($step-number)+.1)[../@xo:id=current()/../@xo:id]"/>
							</xsl:call-template>
						</div>
					</div>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('dim',name())]">
		<xsl:param name="context" select="."/>
		<xsl:apply-templates mode="widget" select="key('dim',name())">
			<xsl:with-param name="context" select="."/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="container:headerText" match="@*">
	</xsl:template>

	<xsl:template mode="container:headerText" match="@*[1]">
		<xsl:text>Datos de Asegurado</xsl:text>
	</xsl:template>

	<xsl:template mode="form-body-container" match="@*">
		<xsl:param name="step-number"></xsl:param>
		<xsl:param name="items" select="expect-items"></xsl:param>
		<fieldset>
			<legend>
				<xsl:apply-templates mode="container:headerText" select="$items"/>
			</legend>
			<xsl:apply-templates mode="form-body-field" select="$items[not(key('hidden', $step-number)[name()=name(current())])]">
				<xsl:with-param name="step-number" select="$step-number"/>
			</xsl:apply-templates>
		</fieldset>
	</xsl:template>

	<xsl:template mode="form-body-field" match="@*">
		<xsl:param name="step-number"></xsl:param>
		<xsl:variable name="headerText">
			<xsl:apply-templates mode="headerText" select="."></xsl:apply-templates>
		</xsl:variable>
		<div class="form-group">
			<div class="mb-3 row" style="max-width: 992px;" xo-slot="{name()}">
				<label class="col-sm-4 col-form-label text-capitalize">
					<xsl:value-of select="$headerText"/>:
				</label>
				<div class="col-sm-8">
					<xsl:apply-templates mode="widget" select=".">
						<xsl:with-param name="step-number" select="$step-number"/>
						<xsl:with-param name="headerText" select="$headerText"/>
					</xsl:apply-templates>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-start">
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-back">
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-next">
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-finish">
	</xsl:template>

	<xsl:key name="desc" match="especie/row/@desc" use="concat(name(../..),'::',../@id)"/>
	<xsl:key name="selected" match="@selected:especie" use="concat(generate-id(..), '::', local-name())"/>

	<xsl:key name="selected" match="cotizaciones/cotizacion/detalle/@especie" use="concat(generate-id(../..), '::', .)"/>

	<xsl:template mode="widget" match="@*">
		<xsl:param name="headerText"/>
		<div class="form-group" style="min-width: calc(6ch + 6rem);">
			<input id="input_{@xo:id}" name="{name()}" class="form-control" type="text" placeholder="">
				<xsl:attribute name="type">
					<xsl:apply-templates mode="control_type" select="."/>
				</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:apply-templates select="."/>
				</xsl:attribute>
			</input>
			<!--<label for="input_{@xo:id}" class="text-capitalize">
				<xsl:value-of select="$headerText"/>
			</label>-->
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="*[key('dim',name())]/row">
		<xsl:param name="context" select="."/>
		<xsl:variable name="value" select="self::*/@id|current()[not(self::*)]"/>
		<xsl:variable name="desc" select="self::*/@desc|current()[not(self::*)]"/>
		<option value="{$value}">
			<xsl:if test="$value=$context">
				<xsl:attribute name="selected"/>
			</xsl:if>
			<xsl:apply-templates select="$desc"/>
		</option>
	</xsl:template>

	<xsl:template mode="wizard:step.panel" match="@numero_cotizacion">
		<button class="" onclick="cotizacion.verFormato()">Imprimir formato</button>
	</xsl:template>

	<xsl:template mode="widget" match="@tarjeta_bolsillo">
		<div id="tarjeta_bosillo" xo-stylesheet="tarjeta_bolsillo.xslt" xo-source="active"></div>
		<button class="btn btn-success" onclick="document.querySelector('#tarjeta_bosillo').dispatch('print')">Imprimir</button>
	</xsl:template>

	<xsl:template mode="widget" match="key('control','select')" priority="-1">
		<xsl:param name="context" select="."/>
		<xsl:variable name="tipo_cotizacion" select="$context/ancestor::*[@fixed:tipo_cotizacion]/@fixed:tipo_cotizacion"/>
		<select class="form-select" xo-scope="{$context/../@xo:id}" xo-slot="{name($context)}" onchange="scope.set(this.value)">
			<option></option>
			<xsl:apply-templates mode="widget" select="row[not(@tipo_cotizacion)]|row[@tipo_cotizacion=$tipo_cotizacion]">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</select>
	</xsl:template>

	<xsl:key name="tarifas" match="tarifas/row/@suma" use="'suma_asegurada'"/>
	<xsl:key name="tarifas" match="tarifas/row/@suma" use="concat('suma_asegurada::',../../@tipo,'::',../@tipo)"/>
	<xsl:key name="tarifas" match="tarifas/row/@suma" use="concat('suma_asegurada::',../../@tipo,'::',../@edad)"/>
	<xsl:key name="tarifas" match="tarifas/row/@cuota" use="concat('monto_deposito::',../../@tipo,'::',../@tipo,'::',../@suma)"/>
	<xsl:key name="tarifas" match="tarifas/row/@cuota" use="concat('monto_deposito::',../../@tipo,'::',../@edad,'::',../@suma)"/>
	<xsl:key name="tarifas" match="tarifas/row/@cuota" use="concat('tarifa::',../../@tipo_cotizacion,'::',../@tipo_transporte_ganado,'::',../@deducible,'::',../@vigencia,'::',../@riesgo_solicitado)"/>
	<xsl:key name="detalle_vida" match="cotizacion[@type='vida']/detalle[@fixed:tipo_persona=../@tipo_persona]" use="generate-id(..)"/>

	<xsl:template mode="widget" match="cotizacion[@type='vida']/@suma_asegurada" priority="1">
		<xsl:param name="context" select="."/>
		<xsl:param name="person" select="key('detalle_vida',generate-id(..))"/>
		<xsl:variable name="tipo_cliente">
			<xsl:choose>
				<xsl:when test="$person/../@tipo_seguro_vida=2">
					<xsl:value-of select="$person/@edad"/>
				</xsl:when>
				<xsl:when test="$person/../../@upp!=''">upp</xsl:when>
				<xsl:otherwise>atrc</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<select class="form-select" xo-scope="{$context/../@xo:id}" xo-slot="{name($context)}" onchange="scope.set(this.value)">
			<option></option>
			<xsl:apply-templates mode="widget" select="key('tarifas',concat('suma_asegurada::',$context/../@tipo_seguro_vida,'::',$tipo_cliente))">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</select>
		<!--<xsl:value-of select="concat('suma_asegurada::',$context/../@tipo_seguro_vida,'::',$tipo_cliente)"/>: <xsl:value-of select="count($person)"/>-->
	</xsl:template>

	<xsl:template mode="widget" match="@monto_deposito" priority="1">
		<xsl:param name="context" select="."/>
		<xsl:param name="person" select="key('detalle_vida',generate-id(../..))"/>
		<xsl:variable name="tipo_cliente">
			<xsl:choose>
				<xsl:when test="$person/../@tipo_seguro_vida=2">
					<xsl:value-of select="$person/@edad"/>
				</xsl:when>
				<xsl:when test="$person/../../@upp!=''">upp</xsl:when>
				<xsl:otherwise>atrc</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--<xsl:value-of select="concat('monto_deposito::',$person/../@tipo_seguro_vida,'::',$tipo_cliente,'::',$person/../@suma_asegurada)"/>!!!-->
		<!--<xsl:value-of select="name()"/>:-->
		<xsl:variable name="tarifas" select="key('tarifas',concat('monto_deposito::',$person/../@tipo_seguro_vida,'::',$tipo_cliente,'::',$person/../@suma_asegurada))"/>
		<xsl:if test="not($tarifas[2])">
			<xsl:apply-templates select="$tarifas"/>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="widget" match="@tarifa" priority="1">
		<xsl:param name="context" select="."/>
		<xsl:variable name="tipo_cotizacion" select="ancestor::*[@tipo_cotizacion]/@tipo_cotizacion"/>
		<xsl:variable name="tipo_transporte_ganado" select="../@tipo_transporte_ganado"/>
		<xsl:variable name="deducible" select="../@deducible"/>
		<xsl:variable name="vigencia" select="../@vigencia"/>
		<xsl:variable name="riesgo_solicitado" select="../@riesgo_solicitado"/>
		<!--<xsl:value-of select="concat('monto_deposito::',$person/../@tipo_seguro_vida,'::',$tipo_cliente,'::',$person/../@suma_asegurada)"/>!!!-->
		<!--<xsl:value-of select="name()"/>:-->
		<xsl:value-of select="key('tarifas',concat('tarifa::',$tipo_cotizacion,'::',$tipo_transporte_ganado,'::',$deducible,'::',$vigencia,'::',$riesgo_solicitado))"/>
		<!--: <xsl:value-of select="concat('tarifa::',$tipo_cotizacion,'::',$tipo_transporte_ganado,'::',$deducible,'::',$vigencia,'::',$riesgo_solicitado)"/><br/><xsl:value-of select="name(../@deducible)"/>-->
	</xsl:template>

	<xsl:template mode="get-state" match="@*" priority="1">
		<xsl:value-of select="ancestor::*/@estado[1]"/>
	</xsl:template>

	<xsl:template mode="get-state" match="@municipio_origen" priority="1">
		<xsl:value-of select="../@estado_origen"/>
	</xsl:template>

	<xsl:template mode="get-state" match="@municipio_destino" priority="1">
		<xsl:value-of select="../@estado_destino"/>
	</xsl:template>

	<xsl:template mode="value" match="*[@desc]">
		<xsl:value-of select="@desc"/>
	</xsl:template>

	<xsl:template mode="value" match="*[@key]">
		<xsl:value-of select="@key"/>
	</xsl:template>

	<xsl:template mode="value" match="*[@id]">
		<xsl:value-of select="@id"/>
	</xsl:template>

	<xsl:template mode="control-radio" match="*">
		<xsl:param name="context" select="."/>
		<xsl:variable name="value">
			<xsl:apply-templates mode="value" select="current()"/>
		</xsl:variable>
		<input type="radio" class="btn-check" name="{$context/../@xo:id}_{name($context)}" id="{$context/../@xo:id}_{name($context)}_{position()}" xo-scope="{$context/../@xo:id}" xo-slot="{name($context)}" onclick="scope.set(this.value)" autocomplete="off" value="{$value}">
			<xsl:if test="$value=$context">
				<xsl:attribute name="onclick">scope.set('')</xsl:attribute>
				<xsl:attribute name="checked"/>
			</xsl:if>
		</input>
		<label class="btn btn-outline-primary" for="{$context/../@xo:id}_{name($context)}_{position()}" xo-scope="{$context/../@xo:id}" xo-slot="{name($context)}">
			<xsl:apply-templates select="@desc"/>
		</label>
	</xsl:template>

	<xsl:template mode="widget" match="key('control','radio')" priority="1">
		<xsl:param name="context" select="."/>
		<xsl:variable name="tipo_cotizacion" select="$context/ancestor::*[@fixed:tipo_cotizacion]/@fixed:tipo_cotizacion"/>
		<div class="btn-group" role="group" xo-scope="{$context/../@xo:id}" xo-slot="{name($context)}">
			<xsl:apply-templates mode="control-radio" select="row[not(@tipo_cotizacion)]|row[@tipo_cotizacion=$tipo_cotizacion]">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</div>
		<xsl:if test="row[@id=$context]/@txt">
			<br/>
			<em>
				<xsl:value-of select="row[@id=$context]/@txt"/>
			</em>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="widget" match="riesgo_solicitado" priority="1">
		<xsl:param name="context" select="."/>
		<xsl:variable name="tipo_cotizacion" select="$context/ancestor::*[@fixed:tipo_cotizacion]/@fixed:tipo_cotizacion"/>
		<div class="btn-group" role="group" xo-scope="{$context/../@xo:id}" xo-slot="{name($context)}">
			<xsl:apply-templates mode="control-radio" select="row[not(@tipo_cotizacion)]|row[@tipo_cotizacion=$tipo_cotizacion][not(@tipo_transporte_ganado) or @tipo_transporte_ganado=$context/../@tipo_transporte_ganado]">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</div>
		<br/>
		<em>
			<xsl:value-of select="row[@id=$context]/@txt"/>
		</em>
	</xsl:template>

	<xsl:template match="@type">
		<xsl:value-of select="translate(.,'_',' ')"/>
	</xsl:template>

	<xsl:template match="@suma_asegurada_total">
	</xsl:template>

	<xsl:template mode="widget" match="especie|enfermedades_zona" priority="1">
		<xsl:param name="context" select="."/>
		<xsl:variable name="selected_items" select="concat(';',$context,';')"/>
		<xsl:variable name="tipo_cotizacion" select="$context/ancestor::*[@fixed:tipo_cotizacion]/@fixed:tipo_cotizacion"/>
		<script>
			<![CDATA[
		function pushAndReturnArray(arr, ...elements) {
			arr.push(...elements);
			return arr;
		}]]>
		</script>
		<ul class="list-group">
			<xsl:for-each select="row[not(@tipo_cotizacion)]|row[@tipo_cotizacion=$tipo_cotizacion]">
				<xsl:variable name="active">
					<xsl:choose>
						<xsl:when test="key('selected',concat(generate-id($context/..),'::',@id))">active</xsl:when>
						<xsl:when test="contains($selected_items,concat(';',@id,';'))">active</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<li class="list-group-item list-group-item-action m-0 p-0 {$active}">
					<div class="d-flex justify-content-between align-items-start p-1 py-2" xo-scope="{$context/../@xo:id}" xo-slot="{name($context)}">
						<xsl:attribute name="onclick">
							<xsl:choose>
								<xsl:when test="$active='active'">
									<xsl:text/>scope.set(scope.value.split(/;/g).filter(item => item != '<xsl:value-of select="@id"/>').join(';'));<xsl:text/>
									<xsl:text/>scope.dispatch('eliminarDetalle', {srcElement: this, selection: closest('li').scope});<xsl:text/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text/>scope.set(pushAndReturnArray(scope.value?scope.value.split(';'):[], ('<xsl:value-of select="@id"/>')).join(';'));<xsl:text/>
									<xsl:text/>scope.dispatch('agregarDetalle', {srcElement: this, selection: closest('li').scope});<xsl:text/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<div class="ms-2 me-auto">
							<div class="fw-bold">
								<xsl:value-of select="@desc"/>
							</div>
						</div>
						<!--<span class="badge text-bg-primary rounded-pill ms-2">
							<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-gender-male" viewBox="0 0 16 16">
								<path fill-rule="evenodd" d="M9.5 2a.5.5 0 0 1 0-1h5a.5.5 0 0 1 .5.5v5a.5.5 0 0 1-1 0V2.707L9.871 6.836a5 5 0 1 1-.707-.707L13.293 2zM6 6a4 4 0 1 0 0 8 4 4 0 0 0 0-8"/>
							</svg>
						</span>
						<span class="badge text-bg-primary rounded-pill ms-2">
							<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-gender-female" viewBox="0 0 16 16">
								<path fill-rule="evenodd" d="M8 1a4 4 0 1 0 0 8 4 4 0 0 0 0-8M3 5a5 5 0 1 1 5.5 4.975V12h2a.5.5 0 0 1 0 1h-2v2.5a.5.5 0 0 1-1 0V13h-2a.5.5 0 0 1 0-1h2V9.975A5 5 0 0 1 3 5"/>
							</svg>
						</span>-->
					</div>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template mode="widget" match="key('control','switch')" priority="2">
		<div class="form-check form-switch">
			<input class="form-check-input" type="checkbox" role="switch" id="control_{../@xo:id}" value="1">
				<xsl:choose>
					<xsl:when test=".=1">
						<xsl:attribute name="onclick">scope.set('')</xsl:attribute>
						<xsl:attribute name="checked"/>
					</xsl:when>
				</xsl:choose>
			</input>
			<label class="form-check-label" for="control_{../@xo:id}">
				<xsl:choose>
					<xsl:when test=".=1">Sí</xsl:when>
					<xsl:otherwise>No</xsl:otherwise>
				</xsl:choose>
			</label>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('readonly',generate-id())]" priority="2">
		<input type="text" readonly="" tabindex="-1">
			<xsl:attribute name="type">
				<xsl:apply-templates mode="control_type" select="."/>
			</xsl:attribute>
			<xsl:attribute name="class">
				<xsl:text/>form-control-plaintext <xsl:apply-templates mode="input-attributes-class" select="."/>
			</xsl:attribute>
			<xsl:attribute name="value">
				<xsl:apply-templates select="."/>
			</xsl:attribute>
		</input>
	</xsl:template>

	<xsl:template mode="input-attributes-class" match="@tipo_cotizacion">
		<xsl:text>text-capitalize </xsl:text>
	</xsl:template>

	<xsl:template mode="form-body-field"  match="@*[key('hidden',generate-id())]" priority="2">
	</xsl:template>

	<xsl:template mode="control_type" match="@correo_electronico">email</xsl:template>
	<xsl:template mode="control_type" match="@fecha_siembra|@fecha_arraigo|@fecha|@fecha_inicio|@fecha_fin">date</xsl:template>
	<xsl:template mode="control_type" match="@machosporasegurar|@hembrasporasegurar|@edad|@numero_cabezas|@suma_asegurada">number</xsl:template>
	<xsl:template mode="control_type" match="@valor_maquinaria|@valor_bienes">number</xsl:template>

	<xsl:template mode="control_type" match="@*">text</xsl:template>
	<xsl:template mode="control_type" match="@*[contains(name(),'_date')]" priority="1">date</xsl:template>

	<xsl:template mode="headerText" match="cotizacion[@type='vida']/detalle/@edad">Edad (años)</xsl:template>
	<xsl:template mode="headerText" match="@*[starts-with(name(),'tipo_')]" priority="0">
		<xsl:text/>Tipo de <xsl:value-of select="substring(name(),6)"/>
	</xsl:template>

	<xsl:template match="@tipo_cotizacion">
		<xsl:value-of select="translate(.,'_',' ')"/>
	</xsl:template>
	<xsl:template match="@tipo_cotizacion[.='transporte_ganado']">Transporte de Ganado</xsl:template>
	<xsl:template match="@tipo_cotizacion[.='transporte_bienes']">Transporte de Bienes</xsl:template>
	<xsl:template match="@tipo_cotizacion[.='acuicola']">Acuícola</xsl:template>
	<xsl:template match="@tipo_cotizacion[.='agricola']">Agrícola</xsl:template>
	<xsl:template match="@tipo_cotizacion[.='vida']">Protección Integral FanVida</xsl:template>

	<xsl:template mode="desc" match="@*|*">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template mode="desc" match="@*[key('desc',concat(name(),'::',.))]">
		<xsl:value-of select="key('desc',concat(name(),'::',.))"/>
	</xsl:template>

	<xsl:template match="key('type','money')" priority="0">
		<xsl:call-template name="format">
			<xsl:with-param name="value" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="key('type','percent')" priority="0">
		<xsl:call-template name="format">
			<xsl:with-param name="value" select="."/>
			<xsl:with-param name="mask">##0.##;-##0.##</xsl:with-param>
		</xsl:call-template>%
	</xsl:template>

	<xsl:template match="@cuota">
		<xsl:call-template name="format">
			<xsl:with-param name="value" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="row[@tipo_transporte_ganado]/@cuota">
		<xsl:variable name="tipo_cotizacion" select="ancestor::*[@tipo_cotizacion]/@tipo_cotizacion"/>
		<xsl:variable name="tipo_transporte_ganado" select="../@tipo_transporte_ganado"/>
		<xsl:variable name="deducible" select="../@deducible"/>
		<xsl:variable name="vigencia" select="../@vigencia"/>
		<xsl:variable name="riesgo_solicitado" select="../@riesgo_solicitado"/>
		<xsl:variable name="cuota" select="key('tarifas',concat('tarifa::',$tipo_cotizacion,'::',$tipo_transporte_ganado,'::',$deducible,'::',$vigencia,'::',$riesgo_solicitado))"/>
		<xsl:call-template name="format">
			<xsl:with-param name="value" select="($cuota * ../@monto_asegurado div 100)"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="@cuota_total">
		<xsl:variable name="tipo_cotizacion" select="ancestor::*[@tipo_cotizacion]/@tipo_cotizacion"/>
		<xsl:variable name="tipo_transporte_ganado" select="../@tipo_transporte_ganado"/>
		<xsl:variable name="deducible" select="../@deducible"/>
		<xsl:variable name="vigencia" select="../@vigencia"/>
		<xsl:variable name="riesgo_solicitado" select="../@riesgo_solicitado"/>
		<xsl:variable name="cuota" select="key('tarifas',concat('tarifa::',$tipo_cotizacion,'::',$tipo_transporte_ganado,'::',$deducible,'::',$vigencia,'::',$riesgo_solicitado))"/>
		<xsl:call-template name="format">
			<xsl:with-param name="value" select="($cuota * ../@monto_asegurado div 100) + ../@gastos_expedicion"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
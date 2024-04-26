<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:xo="http://panax.io/xover"
xmlns:px="http://panax.io/entity"
xmlns:data="http://panax.io/source"
xmlns:meta="http://panax.io/metadata"
xmlns:site="http://panax.io/site"
xmlns:state="http://panax.io/state"
xmlns:initial="http://panax.io/state/initial"
xmlns:search="http://panax.io/state/search"
xmlns:env="http://panax.io/state/environment"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:widget="http://panax.io/widget"
exclude-result-prefixes="#default xsl px xsi xo data site widget state"
>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="common.xslt"/>
	<xsl:import href="widgets/page_navbar.xslt"/>

	<xsl:template mode="widget" match="@*"/>

	<xsl:key name="changed" match="@initial:*" use="concat(../@xo:id,'::',local-name())"/>
	<xsl:template match="/">
		<span class="page-menu">
			<style>
				<![CDATA[
.page-menu nav {
    padding-right: 80px !important;
}

.page-menu {
    transition: 0.5s;
    height: var(--sections-filter-height, 0px;)
}
			
.navbar form {
    display: flex;
    flex-direction: row;
    padding-left: 0;
    margin-bottom: 0;
    list-style: none;
    margin-left: 23px;
}
			]]>
			</style>
			<style>
				:root { --sections-filter-height: 16px; }
			</style>
			<nav class="navbar navbar-expand-md">
				<form action="javascript:void(0);">
					<xsl:apply-templates mode="widget" select="model/@xo:id"/>
				</form>
				<ul id="shell_buttons" class="nav col-md justify-content-end list-unstyled d-flex">
					<xsl:apply-templates mode="buttons"/>
				</ul>
			</nav>
		</span>
	</xsl:template>

	<xsl:key name="year" match="fechas/fecha/@mes" use="substring(.,1,4)"/>
	<xsl:template mode="buttons"  match="*"/>

	<xsl:template mode="widget"  match="model[@env:store='#estado_resultados_tracto' or @env:store='#estado_resultados' or @env:store='#estado_resultados_alt']/@*">
		<xsl:variable name="default_date">
			<xsl:choose>
				<xsl:when test="../fechas/@state:current_date_er">
					<xsl:value-of select="../fechas/@state:current_date_er"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="../polizas/poliza/@fecha">
						<xsl:sort order="descending" select="."/>
						<xsl:if test="position()=1">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="curr_month" select="../fechas/fecha[@mes=$default_date]/@mes"/>
		<style>
			:root { --sections-filter-height: 54px; }
		</style>
		<select class="form-select" xo-scope="{../fechas/@xo:id}" xo-slot="state:current_date_er">
			<option value=""></option>
			<xsl:for-each select="../fechas/fecha/@mes">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:variable name="value" select="concat(substring(.,1,4),'-',substring(.,5))"/>
				<option value="{.}">
					<xsl:if test=".=$curr_month">
						<xsl:attribute name="selected"/>
					</xsl:if>
					<xsl:value-of select="$value"/>
				</option>
			</xsl:for-each>
		</select>
	</xsl:template>

	<xsl:template mode="widget"  match="model[@env:store='#ventas_por_fecha_embarque']/@*">
		<style>
			:root { --sections-filter-height: 86px; }
		</style>
		<fieldset class="fecha_embarque">
			<legend>Fecha de embarque</legend>
			<div class="input-group">
				<input class="form-control" name="fecha_embarque_inicio" type="date" pattern="yyyy-mm-dd" xo-slot="state:fecha_embarque_inicio" value="{../@state:fecha_embarque_inicio}"/>
				<input class="form-control" name="fecha_embarque_fin" min="{../@state:fecha_embarque_inicio}" type="date" pattern="yyyy-mm-dd" xo-slot="state:fecha_embarque_fin" value="{../@state:fecha_embarque_fin}"/>
			</div>
		</fieldset>
		<xsl:apply-templates mode="widget" select="../agricultor|../commodity|../cliente"/>
	</xsl:template>

	<xsl:template mode="headerText"  match="model/*">
		<xsl:value-of select="name()"/>
	</xsl:template>

	<xsl:key name="state:selected" match="model/*/row/@desc[.=../../@state:selected]" use="generate-id()"/>
	<xsl:key name="state:selected" match="model/commodity/row/@desc[.=../../../@state:commodity]" use="generate-id()"/>
	<xsl:key name="state:selected" match="model/cliente/row/@desc[.=../../../@state:cliente]|model/agricultor/row/@desc[.=../../../@state:agricultor]" use="generate-id()"/>

	<xsl:template mode="widget"  match="model/*">
		<fieldset>
			<legend style="text-transform:capitalize">
				<xsl:apply-templates mode="headerText" select="."/>
			</legend>
			<select name="{name()}" class="form-select" xo-scope="{@xo:id}" xo-slot="state:selected">
				<option value=""></option>
				<xsl:for-each select="row/@desc">
					<xsl:variable name="value" select="."/>
					<xsl:variable name="desc" select="translate(.,'*','')"/>
					<xsl:variable name="state:selected" select="key('state:selected',generate-id())"/>
					<option value="{$value}">
						<xsl:if test="$state:selected">
							<xsl:attribute name="selected"/>
						</xsl:if>
						<xsl:value-of select="$desc"/>
					</option>
				</xsl:for-each>
			</select>
		</fieldset>
	</xsl:template>

	<xsl:template mode="widget"  match="model[@env:store='#estado_resultados_semanal']/@*">
		<xsl:variable name="default_date">
			<xsl:choose>
				<xsl:when test="../fechas/@state:current_date_er">
					<xsl:value-of select="../fechas/@state:current_date_er"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="../fechas/@key">
						<xsl:sort order="descending" select="."/>
						<xsl:if test="position()=1">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="curr_month" select="../fechas/row[@mes=$default_date]/@mes"/>
		<xsl:variable name="start-week" select="../fechas/@state:start-week"/>
		<xsl:variable name="end-week" select="../fechas/@state:end-week"/>

		<style>
			:root { --sections-filter-height: 54px; }
		</style>
		<select class="form-select" xo-scope="{../fechas/@xo:id}" xo-slot="state:start-week">
			<option value=""></option>
			<xsl:variable name="inactive-dates" select="../fechas/row[@desc=../@state:end-week]/following-sibling::*/@desc"/>
			<xsl:for-each select="../fechas/row/@desc[count($inactive-dates|.)!=count($inactive-dates)]">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:variable name="value" select="."/>
				<option value="{.}">
					<xsl:if test=".=$start-week">
						<xsl:attribute name="selected"/>
					</xsl:if>
					<xsl:value-of select="$value"/>
				</option>
			</xsl:for-each>
		</select>
		<select class="form-select" xo-scope="{../fechas/@xo:id}" xo-slot="state:end-week">
			<option value=""></option>
			<xsl:variable name="inactive-dates" select="../fechas/row[@desc=../@state:start-week]/preceding-sibling::*/@desc"/>
			<xsl:for-each select="../fechas/row/@desc[count($inactive-dates|.)!=count($inactive-dates)]">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:variable name="value" select="."/>
				<option value="{.}">
					<xsl:if test=".=$end-week">
						<xsl:attribute name="selected"/>
					</xsl:if>
					<xsl:value-of select="$value"/>
					<!--- <xsl:for-each select="$inactive-dates"><xsl:value-of select="."/>
				</xsl:for-each>-->
				</option>
			</xsl:for-each>
		</select>
	</xsl:template>

	<xsl:key name="active_tracto" match="model/tractos/@state:selected" use="."/>
	<xsl:template mode="widget"  match="model[@env:store='#productividad_individual']/@*">
		<xsl:variable name="default_date">
			<xsl:choose>
				<xsl:when test="../fechas/@state:current_date_er">
					<xsl:value-of select="../fechas/@state:current_date_er"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="../polizas/poliza/@fecha">
						<xsl:sort order="descending" select="."/>
						<xsl:if test="position()=1">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="curr_month" select="../fechas/fecha[@mes=$default_date]/@mes"/>
		<style>
			:root { --sections-filter-height: 54px; }
		</style>
		<xsl:for-each select="..">
			<select name='tractor' style='width: 200px; background-color: transparent; height: 40px; position: relative; font: inherit;' xo-scope='{tractos/@xo:id}' xo-slot='state:selected' onchange='scope.set(this.value || null)'>
				<option></option>
				<xsl:for-each select="tractos/tracto/@id">
					<xsl:sort select="../@nom"/>
					<option value="{.}">
						<xsl:if test="ancestor::tractos[@state:selected!=''] and key('active_tracto',.)">
							<xsl:attribute name="selected"/>
						</xsl:if>
						<xsl:value-of select="../@nom"/>
					</option>
				</xsl:for-each>
			</select>
			<button onclick="productividad.upload()" class="btn btn-success">Subir cambios</button>
		</xsl:for-each>
	</xsl:template>

	<xsl:template mode="widget" match="model[@env:store='#presupuestos_litros']/@*">
		<style>
			:root { --sections-filter-height: 54px; }
		</style>
		<div class="btn-group btn-group-sm" role="group" aria-label="Pivotear" style="margin-left:1rem;">
			<svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 24 24" width="24" onclick="xo.site.searchParams.toggle('orientation','vertical')" title="Pivotear tabla">
				<path d="M0 0h24v24H0z" fill="none"/>
				<path d="M10 8h11V5c0-1.1-.9-2-2-2h-9v5zM3 8h5V3H5c-1.1 0-2 .9-2 2v3zm2 13h3V10H3v9c0 1.1.9 2 2 2zm8 1l-4-4 4-4zm1-9l4-4 4 4z"/>
				<path d="M14.58 19H13v-2h1.58c1.33 0 2.42-1.08 2.42-2.42V13h2v1.58c0 2.44-1.98 4.42-4.42 4.42z"/>
			</svg>
		</div>
		<div class="btn-group btn-group-sm" role="group" aria-label="Año" style="margin-left:1rem;">
			<fieldset>
				<xsl:apply-templates mode="button" select="../fechas/fecha/@mes[string-length(.)=4]"/>
			</fieldset>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="model[@env:store='#flujo_efectivo' or @env:store='#capital_trabajo']/@*">
		<xsl:variable name="default_date">
			<xsl:choose>
				<xsl:when test="../fechas/@state:current_year">
					<xsl:value-of select="../fechas/@state:current_year"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="../fechas/fecha/@mes">
						<xsl:sort select="." data-type="number" order="descending"/>
						<xsl:if test="position()=1">
							<xsl:value-of select="substring(.,1,4)"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="curr_month" select="../fechas/fecha[starts-with(@mes,$default_date)][1]/@mes"/>
		<xsl:variable name="curr_year" select="substring($curr_month,1,4)"/>
		<style>
			:root { --sections-filter-height: 54px; }
		</style>
		<select class="form-select" xo-scope="{../fechas/@xo:id}" xo-slot="state:current_year">
			<xsl:for-each select="../fechas/fecha[@nom='ENERO']/@mes">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:variable name="value" select="substring(.,1,4)"/>
				<option value="{$value}">
					<xsl:if test="$value=$curr_year">
						<xsl:attribute name="selected"/>
					</xsl:if>
					<xsl:value-of select="$value"/>
				</option>
			</xsl:for-each>
		</select>
	</xsl:template>

	<xsl:template mode="widget" match="model[@env:store='#estado_resultados_mensual' or @env:store='#concentrado_er_balance' or @env:store='#estado_resultados_mensual_alt' or @env:store='#estado_resultados_unidad']/@*">
		<div class="btn-group btn-group-sm" role="group" aria-label="Año" style="margin-left:1rem;">
			<style>
				:root { --sections-filter-height: 54px; }
			</style>
			<fieldset>
				<xsl:for-each select="../fechas/fecha/@mes[count(key('year',substring(.,1,4))[1]|.)=1]">
					<xsl:variable name="active">
						<xsl:choose>
							<xsl:when test="../@state:checked='true'">active</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<button type="button" class="btn btn-outline-secondary {$active}" xo-scope="{../@xo:id}" xo-slot="state:checked" onclick="scope.set('true');">
						<xsl:choose>
							<xsl:when test="$active='active'">
								<xsl:attribute name="onclick">scope.remove()</xsl:attribute>
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x-square" viewBox="0 0 16 16" style="margin-right: 5pt" onclick="scope.remove(); event.stopPropagation(); return false">
									<path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/>
									<path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
								</svg>
							</xsl:when>
							<xsl:otherwise>
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-square" viewBox="0 0 16 16" style="margin-right: 5pt" onclick="scope.set('true'); event.stopPropagation(); return false;">
									<path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/>
								</svg>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="substring(.,1,4)"/>
					</button>
				</xsl:for-each>
			</fieldset>
		</div>
	</xsl:template>

	<xsl:template match="model" mode="buttons">
		<xsl:if test="1=0 and $site:seed='#estado_resultados_mensual'">
			<button class="btn btn-primary" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRight" aria-controls="offcanvasRight" style="margin: 0 15px;">Ver gráfica</button>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
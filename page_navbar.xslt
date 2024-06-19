<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:xo="http://panax.io/xover"
xmlns:px="http://panax.io/entity"
xmlns:meta="http://panax.io/metadata"
xmlns:state="http://panax.io/state"
xmlns:initial="http://panax.io/state/initial"
xmlns:search="http://panax.io/state/search"
xmlns:env="http://panax.io/state/environment"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:widget="http://panax.io/widget"
xmlns:combobox="http://panax.io/widget/combobox"
>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="common.xslt"/>
	<xsl:import href="widgets/page_navbar.xslt"/>
	<xsl:import href="widgets/combobox.xslt"/>

	<xsl:template mode="widget" match="@*"/>

	<xsl:param name="state:filterBy"></xsl:param>

	<xsl:key name="data" match="model/movimientos" use="'*'"/>
	<xsl:key name="data" match="model/ventas" use="'*'"/>
	<xsl:key name="data" match="model/trouble" use="'*'"/>

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
				<form action="javascript:void(0);" onsubmit="section.source.fetch()">
					<xsl:apply-templates mode="widget" select="model/@xo:id"/>
					<xsl:apply-templates mode="button" select="key('data','*')[not(*)]/@state:record_count[.&gt;0]"/>
				</form>
				<ul id="shell_buttons" class="nav col-md justify-content-end list-unstyled d-flex">
					<xsl:apply-templates mode="buttons"/>
				</ul>
			</nav>
		</span>
	</xsl:template>

	<xsl:key name="year" match="fechas/fecha/@mes" use="substring(.,1,4)"/>
	<xsl:template mode="buttons" match="*"/>

	<xsl:template mode="widget" match="model[@env:store='#ventas_por_fecha_embarque']/@*">
		<style>
			:root { --sections-filter-height: 86px; }
			filter_by option {
			font-size: 16pt;
			}
		</style>
		<fieldset class="filter_by">
			<legend>
				<select style="font-weight: bold; padding: 1px 5px;" class="form-select" onchange="xo.state.filterBy=this.value">
					<option value="ship_date">
						<xsl:if test="$state:filterBy='' or $state:filterBy='ship_date'">
							<xsl:attribute name="selected"/>
						</xsl:if> Fecha de embarque
					</option>
					<option value="order">
						<xsl:if test="$state:filterBy='order'">
							<xsl:attribute name="selected"/>
						</xsl:if>Sales Order
					</option>
					<option value="purchase_order">
						<xsl:if test="$state:filterBy='purchase_order'">
							<xsl:attribute name="selected"/>
						</xsl:if>Purchase Order
					</option>
					<option value="grower_lot">
						<xsl:if test="$state:filterBy='grower_lot'">
							<xsl:attribute name="selected"/>
						</xsl:if>Grower Lot
					</option>
				</select>
			</legend>
			<xsl:choose>
				<xsl:when test="$state:filterBy='' or $state:filterBy='ship_date'">
					<div class="input-group">
						<input class="form-control" name="fecha_embarque_inicio" type="date" pattern="yyyy-mm-dd" xo-slot="state:fecha_embarque_inicio" value="{../@state:fecha_embarque_inicio}"/>
						<input class="form-control" name="fecha_embarque_fin" type="date" pattern="yyyy-mm-dd" xo-slot="state:fecha_embarque_fin" value="{../@state:fecha_embarque_fin}"/>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<input type="text" name="{$state:filterBy}" class="form-control" value="{../@state:*[local-name()=$state:filterBy]}" xo-slot="state:{$state:filterBy}"/>
				</xsl:otherwise>
			</xsl:choose>
		</fieldset>
		<xsl:apply-templates mode="widget" select="../agricultor|../commodity|../cliente"/>
	</xsl:template>

	<xsl:key name="state:selected" match="model/*/row[@id=../@state:selected]/@desc" use="generate-id()"/>
	<xsl:key name="state:selected" match="model/*/row[@key=../@state:selected]/@desc" use="generate-id()"/>
	<xsl:key name="state:selected" match="model/commodity/row[@id=../../@state:commodity]/@desc" use="generate-id()"/>
	<xsl:key name="state:selected" match="model/cliente/row[@id=../../@state:cliente]/@desc|model/agricultor/row[@id=../../@state:agricultor]/@desc" use="generate-id()"/>

	<xsl:template mode="widget" match="model/*">
		<style>
			:root { --sections-filter-height: 86px; }
			filter_by option {
			font-size: 16pt;
			}
		</style>
		<fieldset>
			<legend style="text-transform:capitalize">
				<xsl:apply-templates mode="headerText" select="."/>
			</legend>
			<xsl:variable name="state:selected" select="@state:selected"/>
			<xsl:apply-templates mode="combobox:widget" select=".">
				<xsl:with-param name="dataset" select="row/@desc"/>
				<xsl:with-param name="xo-slot">state:selected</xsl:with-param>
				<xsl:with-param name="selected-value" select="$state:selected"/>
			</xsl:apply-templates>
			<!--<select name="{name()}" class="form-select" xo-scope="{@xo:id}" xo-slot="state:selected">
				<option value=""></option>
				<xsl:for-each select="row/@desc">
					<xsl:variable name="value" select="../@id|../@key"/>
					<xsl:variable name="desc" select="translate(.,'*','')"/>
					<xsl:variable name="state:selected" select="key('state:selected',generate-id())"/>
					<option value="{$value}">
						<xsl:if test="$state:selected">
							<xsl:attribute name="selected"/>
						</xsl:if>
						<xsl:value-of select="$desc"/>
					</option>
				</xsl:for-each>
			</select>-->
		</fieldset>
	</xsl:template>

	<xsl:template mode="headerText" match="model[@env:store='#ventas_por_fecha_embarque']/fechas">
		<select style="font-weight: bold; padding: 1px 5px;" class="form-select" onchange="xo.state.filterBy=this.value">
			<option value="ship_date">
				<xsl:if test="$state:filterBy='' or $state:filterBy='ship_date'">
					<xsl:attribute name="selected"/>
				</xsl:if> Fecha de embarque
			</option>
			<option value="order">
				<xsl:if test="$state:filterBy='order'">
					<xsl:attribute name="selected"/>
				</xsl:if>Sales Order
			</option>
			<option value="purchase_order">
				<xsl:if test="$state:filterBy='purchase_order'">
					<xsl:attribute name="selected"/>
				</xsl:if>Purchase Order
			</option>
			<option value="grower_lot">
				<xsl:if test="$state:filterBy='grower_lot'">
					<xsl:attribute name="selected"/>
				</xsl:if>Grower Lot
			</option>
		</select>
	</xsl:template>

	<xsl:template mode="headerText" match="model[@env:store='#detalle_gastos_operativos' or @env:store='#detalle_ingresos_operativos' or @env:store='#ingresos_operativos' or @env:store='#gastos_operativos' or @env:store='#balance_operativo' or @env:store='#detalle_problemas']/*[self::semanas|self::fechas]">
		<select class="form-select" onchange="xo.state.filterBy=this.value">
			<option value="weeks">
				<xsl:if test="$state:filterBy='weeks'">
					<xsl:attribute name="selected"/>
				</xsl:if> Weeks
			</option>
			<option value="dates">
				<xsl:if test="$state:filterBy='dates'">
					<xsl:attribute name="selected"/>
				</xsl:if>Dates
			</option>
		</select>
	</xsl:template>

	<xsl:template mode="headerText" match="model[@env:store='#detalle_problemas']/*[self::semanas|self::fechas]|model[@env:store='#detalle_problemas']/@state:*">
		<select class="form-select" onchange="xo.state.filterBy=this.value">
			<option value="weeks">
				<xsl:if test="$state:filterBy='weeks'">
					<xsl:attribute name="selected"/>
				</xsl:if> Weeks
			</option>
			<option value="dates">
				<xsl:if test="$state:filterBy='dates'">
					<xsl:attribute name="selected"/>
				</xsl:if>Dates
			</option>
			<option value="trouble">
				<xsl:if test="$state:filterBy='trouble'">
					<xsl:attribute name="selected"/>
				</xsl:if>Trouble
			</option>
			<option value="purchase_order">
				<xsl:if test="$state:filterBy='purchase_order'">
					<xsl:attribute name="selected"/>
				</xsl:if>Purchase Order
			</option>
			<option value="order">
				<xsl:if test="$state:filterBy='order'">
					<xsl:attribute name="selected"/>
				</xsl:if>Sales Order
			</option>
		</select>
	</xsl:template>

	<xsl:template mode="widget" match="model/fechas">
		<style>
			:root { --sections-filter-height: 86px; }
			filter_by option {
			font-size: 16pt;
			}
		</style>
		<fieldset>
			<legend style="text-transform:capitalize">
				<xsl:apply-templates mode="headerText" select="."/>
			</legend>
			<select name="{name()}" class="form-select" xo-scope="{@xo:id}" xo-slot="state:selected">
				<option value=""></option>
				<xsl:for-each select="row/@desc">
					<xsl:variable name="value" select="../@id"/>
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

	<xsl:template mode="widget" match="model[@env:store='#estado_resultados_semanal']/@*">
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
		<xsl:variable name="start_week" select="../fechas/@state:start_week"/>
		<xsl:variable name="end_week" select="../fechas/@state:end_week"/>

		<style>
			:root { --sections-filter-height: 54px; }
		</style>
		<div class="input-group">
			<select class="form-select" xo-scope="{../fechas/@xo:id}" xo-slot="state:start_week">
				<option value=""></option>
				<xsl:variable name="inactive-dates" select="../fechas/row[@desc=../@state:end_week]/following-sibling::*/@desc"/>
				<xsl:for-each select="../fechas/row/@desc[count($inactive-dates|.)!=count($inactive-dates)]">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:variable name="value" select="."/>
					<option value="{.}">
						<xsl:if test=".=$start_week">
							<xsl:attribute name="selected"/>
						</xsl:if>
						<xsl:value-of select="$value"/>
					</option>
				</xsl:for-each>
			</select>
			<select class="form-select" xo-scope="{../fechas/@xo:id}" xo-slot="state:end_week">
				<option value=""></option>
				<xsl:variable name="inactive-dates" select="../fechas/row[@desc=../@state:start_week]/preceding-sibling::*/@desc"/>
				<xsl:for-each select="../fechas/row/@desc[count($inactive-dates|.)!=count($inactive-dates)]">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:variable name="value" select="."/>
					<option value="{.}">
						<xsl:if test=".=$end_week">
							<xsl:attribute name="selected"/>
						</xsl:if>
						<xsl:value-of select="$value"/>
						<!--- <xsl:for-each select="$inactive-dates"><xsl:value-of select="."/>
				</xsl:for-each>-->
					</option>
				</xsl:for-each>
			</select>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="model/fechas">
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
		<xsl:variable name="start_week" select="../fechas/@state:start_week"/>
		<xsl:variable name="end_week" select="../fechas/@state:end_week"/>

		<style>
			:root { --sections-filter-height: 86px; }
		</style>

		<fieldset>
			<legend style="text-transform:capitalize">
				<xsl:apply-templates mode="headerText" select="."/>
			</legend>
			<div class="input-group">
				<input class="form-control" name="fecha_inicio" type="date" pattern="yyyy-mm-dd" xo-slot="state:fecha_inicio" value="{@state:fecha_inicio}"/>
				<input class="form-control" name="fecha_fin" type="date" pattern="yyyy-mm-dd" xo-slot="state:fecha_fin" value="{@state:fecha_fin}"/>
			</div>
		</fieldset>
	</xsl:template>

	<xsl:template mode="widget" match="model/semanas">
		<xsl:variable name="default_date">
			<xsl:choose>
				<xsl:when test="@state:current_date_er">
					<xsl:value-of select="@state:current_date_er"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="@key">
						<xsl:sort order="descending" select="."/>
						<xsl:if test="position()=1">
							<xsl:value-of select="."/>
						</xsl:if>/
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="curr_month" select="row[@mes=$default_date]/@mes"/>
		<xsl:variable name="start_week" select="@state:start_week"/>
		<xsl:variable name="end_week" select="@state:end_week"/>

		<style>
			:root { --sections-filter-height: 86px; }
		</style>

		<fieldset>
			<legend style="text-transform:capitalize">
				<xsl:apply-templates mode="headerText" select="."/>
			</legend>
			<div class="input-group">
				<select class="form-select" xo-scope="{@xo:id}" xo-slot="state:start_week">
					<option value=""></option>
					<xsl:variable name="inactive-dates" select="row[@desc=../@state:end_week]/following-sibling::*/@desc"/>
					<xsl:for-each select="row/@desc[count($inactive-dates|.)!=count($inactive-dates)]">
						<xsl:sort select="." data-type="number" order="descending"/>
						<xsl:variable name="value" select="."/>
						<option value="{.}">
							<xsl:if test=".=$start_week">
								<xsl:attribute name="selected"/>
							</xsl:if>
							<xsl:value-of select="$value"/>
						</option>
					</xsl:for-each>
				</select>
				<select class="form-select" xo-scope="{@xo:id}" xo-slot="state:end_week">
					<option value=""></option>
					<xsl:variable name="inactive-dates" select="row[@desc=../@state:start_week]/preceding-sibling::*/@desc"/>
					<xsl:for-each select="row/@desc[count($inactive-dates|.)!=count($inactive-dates)]">
						<xsl:sort select="." data-type="number" order="descending"/>
						<xsl:variable name="value" select="."/>
						<option value="{.}">
							<xsl:if test=".=$end_week">
								<xsl:attribute name="selected"/>
							</xsl:if>
							<xsl:value-of select="$value"/>
							<!--- <xsl:for-each select="$inactive-dates"><xsl:value-of select="."/>
				</xsl:for-each>-->
						</option>
					</xsl:for-each>
				</select>
			</div>
		</fieldset>
	</xsl:template>

	<xsl:template mode="widget" match="model[@env:store='#detalle_gastos_operativos' or @env:store='#detalle_ingresos_operativos']/@*">
		<xsl:apply-templates mode="widget" select="../account|../semanas[not($state:filterBy='dates')]|../fechas[$state:filterBy='dates']"/>
	</xsl:template>

	<xsl:template mode="widget" match="model[@env:store='#ingresos_operativos' or @env:store='#gastos_operativos' or @env:store='#balance_operativo' or @env:store='#auxiliar_cuentas']/@*">
		<xsl:apply-templates mode="widget" select="../semanas[not($state:filterBy='dates')]|../fechas[$state:filterBy='dates']"/>
	</xsl:template>

	<xsl:template mode="widget" match="model[@env:store='#detalle_problemas']/@*">
		<xsl:apply-templates mode="widget" select="../semanas[$state:filterBy='weeks' or string($state:filterBy)='']|../fechas[$state:filterBy='dates']|../@state:trouble[$state:filterBy='trouble']|../@state:purchase_order[$state:filterBy='purchase_order']|../@state:order[$state:filterBy='order']|../commodity|../cliente"/>
	</xsl:template>

	<xsl:template mode="widget" match="model/@state:*">
		<style>
			:root { --sections-filter-height: 86px; }
			filter_by option {
			font-size: 16pt;
			}
		</style>
		<fieldset>
			<legend style="text-transform:capitalize">
				<xsl:apply-templates mode="headerText" select="."/>
			</legend>
			<input type="text" name="{local-name()}" class="form-control" value="{.}" xo-slot="state:{local-name()}"/>
		</fieldset>
	</xsl:template>

	<xsl:template mode="button" match="*/@state:record_count">
		<button class="btn btn-success text-nowrap" onclick="mostrarRegistros.call(this)" style="max-height: 38px; align-self: end;">
			Mostrar los <xsl:value-of select="."/> resultados
		</button>
	</xsl:template>
</xsl:stylesheet>
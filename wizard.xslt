<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:source="http://panax.io/xdom/binding/source"
  xmlns:wizard="http://widgets.panax.io/wizard"
  exclude-result-prefixes="xo source"
  xmlns="http://www.w3.org/1999/xhtml"
>
	<xsl:key name="wizard-section" match="xo:dummy" use="1"/>
	<xsl:key name="optional" match="xo:dummy" use="generate-id()"/>
	<xsl:key name="invalid" match="xo:dummy" use="generate-id()"/>
	<xsl:key name="hidden" match="xo:dummy" use="generate-id()"/>
	<xsl:key name="hidden" match="xo:dummy" use="'*'"/>
	
	<xsl:template match="*" mode="wizard:styles" priority="-10"/>

	<!--<xsl:template match="*" mode="wizard:step-title-legend" priority="-10">
    <xsl:value-of select="@shortTitle|self::*[not(@shortTitle)]/@title"/>
  </xsl:template>-->

	<xsl:template match="*|@*" mode="wizard:step-title-legend" priority="-10"/>

	<xsl:template match="*|@*" mode="wizard:step.panel.legend" priority="-10">
		<xsl:param name="step-number" select="count(preceding-sibling::*|self::*)"/>
		<xsl:apply-templates mode="wizard:step-title-legend" select=".">
			<xsl:with-param name="step-number" select="$step-number"/>
		</xsl:apply-templates>
	</xsl:template>

	<!--<xsl:template match="*" mode="wizard:step-title-legend" priority="-10">
    <xsl:param name="step-number" select="count(preceding-sibling::*|self::*)"/>
    <xsl:text/>Paso <xsl:value-of select="$step-number"/><xsl:text/>
  </xsl:template>-->

	<xsl:template match="*|@*" mode="wizard:step-title" priority="-1">
		<xsl:param name="active">1</xsl:param>
		<xsl:param name="step-number">1</xsl:param>
		<li data-position="{$step-number}" class="inactive" style="padding: 0px 43px;" xo-scope="inherit" xo-slot="state:active" onclick="xo.state.active = {$step-number}">
			<xsl:variable name="completed" select="not(key('wizard-section',number($step-number))[key('invalid',generate-id())][not(key('optional',generate-id()) or key('hidden',generate-id()))])"/>
			<xsl:choose>
				<xsl:when test="$active=$step-number">
					<xsl:attribute name="class">active</xsl:attribute>
				</xsl:when>
				<xsl:when test="$completed and $active&gt;$step-number">
					<xsl:attribute name="class">completed</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<a href="#">
				<h1>
					<xsl:value-of select="concat($step-number,'.')"/>
				</h1>
				<xsl:apply-templates mode="wizard:step-title-legend" select=".">
					<xsl:with-param name="step-number" select="$step-number"/>
				</xsl:apply-templates>
				<xsl:if test="$completed">
					<span class="fas fa-check-circle aiia-wizard-icon-step-completed"></span>
				</xsl:if>
			</a>
		</li>
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-back.attributes" priority="-1">
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-back.attributes.onclick" priority="-1">
		<xsl:param name="step-number" select="count(preceding-sibling::*|self::*)"/>
		<xsl:text/>scope.set('<xsl:value-of select="number($step-number)-1"/>');
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-back-label" priority="-1">
		<xsl:text>Atrás</xsl:text>
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-start-label" priority="-1">
		<xsl:text>Inicio</xsl:text>
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-start" name="wizard:buttons-start" priority="-1">
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-back" name="wizard:buttons-back" priority="-1">
		<xsl:param name="step-number" select="count(preceding-sibling::*|self::*)"/>
		<xsl:if test="key('wizard-section',number($step-number)-1)">
			<button class="btn btn-primary pull-left aiia-wizard-button-previous" xo-slot="state:active">
				<xsl:attribute name="onclick">
					<xsl:apply-templates mode="wizard:buttons-back.attributes.onclick" select=".">
						<xsl:with-param name="step-number" select="$step-number"/>
					</xsl:apply-templates>
				</xsl:attribute>
				<xsl:apply-templates mode="wizard:buttons-back.attributes" select="."/>
				<span>
					<xsl:apply-templates mode="wizard:buttons-back-label" select="."/>
				</span>
			</button>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-next.attributes" priority="-1">
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-finish.attributes" priority="-1">
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-next.attributes.onclick" priority="-1">
		<xsl:param name="step-number" select="count(preceding-sibling::*|self::*)"/>
		<xsl:text/>scope.set('<xsl:value-of select="number($step-number)-(-1)"/>');
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-finish-attributes-onclick" priority="-1">
		<xsl:param name="step-number" select="count(preceding-sibling::*|self::*)"/>
		<xsl:text/>alert('Terminado')
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-next-label" priority="-1">
		<xsl:text>Siguiente</xsl:text>
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-finish-label" priority="-1">
		<xsl:text>Guardar</xsl:text>
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-next" name="wizard:buttons-next" priority="-1">
		<xsl:param name="step-number" select="count(preceding-sibling::*|self::*)"/>
		<xsl:param name="label">Siguiente</xsl:param>
		<button class="btn btn-primary pull-right aiia-wizard-button-next" xo-slot="state:active">
			<xsl:attribute name="onclick">
				<xsl:apply-templates mode="wizard:buttons-next.attributes.onclick" select=".">
					<xsl:with-param name="step-number" select="$step-number"/>
				</xsl:apply-templates>
			</xsl:attribute>
			<xsl:apply-templates mode="wizard:buttons-next.attributes" select="."/>
			<span>
				<xsl:apply-templates mode="wizard:buttons-next-label" select="."/>
			</span>
		</button>
	</xsl:template>

	<xsl:template match="*" mode="wizard:buttons-finish" name="wizard:buttons-finish" priority="-1">
		<xsl:param name="step-number" select="count(preceding-sibling::*|self::*)"/>
		<xsl:param name="label">Siguiente</xsl:param>
		<button class="btn btn-success pull-right aiia-wizard-button-finish" xo-slot="state:active">
			<xsl:attribute name="onclick">
				<xsl:apply-templates mode="wizard:buttons-finish-attributes-onclick" select=".">
					<xsl:with-param name="step-number" select="$step-number"/>
				</xsl:apply-templates>
			</xsl:attribute>
			<xsl:apply-templates mode="wizard:buttons-finish.attributes" select="."/>
			<span>
				<xsl:apply-templates mode="wizard:buttons-finish-label" select="."/>
			</span>
		</button>
	</xsl:template>

	<xsl:template match="*" mode="wizard:step-panel-content" priority="-1">
		<p>No hay nada que hacer aún en este paso.</p>
	</xsl:template>

	<xsl:template match="*|@*" mode="wizard:step.panel" priority="-1">
		<xsl:param name="step-number">1</xsl:param>
		<xsl:variable name="step-class">aiia-wizard-step</xsl:variable>
		<div id="container_{@xo:id}" class="{$step-class}" data-position="{count(preceding-sibling::*|self::*)}" style="min-height: 400px; width: 100%; margin-left: 0px; padding-bottom: 5rem;" xo-scope="inherit">
			<xsl:choose>
				<xsl:when test="$step-number=1">
					<xsl:attribute name="class">
						<xsl:value-of select="$step-class"/><xsl:text/> active<xsl:text/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="$step-number&gt;1">
					<xsl:attribute name="class">
						<xsl:value-of select="$step-class"/><xsl:text/> completed<xsl:text/>
					</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<div class="row aiia-wizard-step-title">
				<div class="col-md-12">
					<h2 class="aiia-wizard-step-title-text">
						<xsl:apply-templates mode="wizard:step.panel.legend" select=".">
							<xsl:with-param name="step-number" select="$step-number"/>
						</xsl:apply-templates>
					</h2>
				</div>
			</div>
			<div class="step-content">
				<xsl:apply-templates mode="wizard:step-panel-content" select=".">
					<xsl:with-param name="step-number" select="$step-number"/>
				</xsl:apply-templates>
			</div>
			<div class="aiia-wizard-buttons-wrapper row" style="display: block;">
				<div class="col-md-12">
					<xsl:choose>
						<xsl:when test="key('wizard-section',number($step-number)-1)">
							<xsl:apply-templates select="." mode="wizard:buttons-back">
								<xsl:with-param name="step-number" select="$step-number"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="wizard:buttons-start">
								<xsl:with-param name="step-number" select="$step-number"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="key('wizard-section',number($step-number)+1)">
							<xsl:apply-templates select="." mode="wizard:buttons-next">
								<xsl:with-param name="step-number" select="$step-number"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="wizard:buttons-finish">
								<xsl:with-param name="step-number" select="$step-number"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="*" mode="wizard" priority="-1">
		<xsl:param name="active" select="1"/>
		<xsl:param name="steps" select="(//@*)[position()&lt;20]"/>
		<xsl:variable name="current" select="current()"/>
			<xsl:apply-templates mode="wizard:styles" select="."/>
			<div id="wizard" class="aiia-wizard outer-container" style="display: flex; flex-direction: column;">
				<div class="wizard-header sticky-top bg-white">
					<hr style="border-width: 4px; border-color: silver;"/>
					<div class="aiia-wizard-progress-buttons-wrapper row">
						<div class="col-md-12">
							<ul class="nav nav-pills nav-justified aiia-wizard-progress-buttons-placeholder">
								<xsl:for-each select="$steps">
									<xsl:variable name="current-step" select="position()"/>
									<xsl:variable name="items" select="key('wizard-section',$current-step)[not(key('hidden',generate-id()))]"/>
									<xsl:apply-templates mode="wizard:step-title" select="$items[1]">
										<xsl:with-param name="active" select="$active"/>
										<xsl:with-param name="step-number" select="position()"/>
										<xsl:with-param name="ref" select="current()"/>
									</xsl:apply-templates>
								</xsl:for-each>
							</ul>
						</div>
					</div>
					<hr style="border-width: 4px; border-color: silver;"/>
				</div>
				<div class="aiia-wizard-steps-wrapper container" style="position: relative; width: 100%; min-height: 500px; height: 500px; overflow-x: hidden; max-height: 100%; flex: 1;">
					<xsl:apply-templates mode="wizard:step.panel" select="key('wizard-section',$active)[not(key('hidden',generate-id()))][1]">
						<xsl:with-param name="active" select="$active"/>
						<xsl:with-param name="step-number" select="$active"/>
					</xsl:apply-templates>
				</div>
		</div>
	</xsl:template>

	<xsl:template match="/*" priority="-1">
		<main>
			<xsl:apply-templates mode="wizard" select="."/>
		</main>
	</xsl:template>

	<xsl:template mode="form.body.field"  match="key('hidden','*')" priority="2"/>
	<xsl:template mode="form.body.field"  match="key('hidden','1')" priority="2"/>
	<xsl:template mode="form.body.field"  match="key('hidden','2')" priority="2"/>
	<xsl:template mode="form.body.field"  match="key('hidden','3')" priority="2"/>
	<xsl:template mode="form.body.field"  match="key('hidden','4')" priority="2"/>
	<xsl:template mode="form.body.field"  match="key('hidden','5')" priority="2"/>
	<xsl:template mode="form.body.field"  match="key('hidden','6')" priority="2"/>
	<xsl:template mode="form.body.field"  match="key('hidden','7')" priority="2"/>
	<xsl:template mode="form.body.field"  match="key('hidden','8')" priority="2"/>

</xsl:stylesheet>
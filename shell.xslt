<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
xmlns:x="http://panax.io/xover"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:shell="http://panax.io/shell"
xmlns:state="http://panax.io/state"
xmlns:source="http://panax.io/xover/binding/source"
xmlns:xlink="http://www.w3.org/1999/xlink"
exclude-result-prefixes="#default x session sitemap shell state source"
>
	<xsl:include href="templates/shell.xslt"/>

	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>
</xsl:stylesheet>

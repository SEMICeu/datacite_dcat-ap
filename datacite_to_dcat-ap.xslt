<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
 	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:dcat="http://www.w3.org/ns/dcat#"
	xmlns:dct="http://purl.org/dc/terms/" 
	xmlns:foaf="http://xmlns.com/foaf/0.1/"  
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"  
	xpath-default-namespace="http://datacite.org/schema/kernel-4">

	<xsl:output encoding="UTF-8" indent="yes" media-type="text/xml" method="xml" omit-xml-declaration="no" />

	<!-- Global parameters -->
	<xsl:param name="basenamespace">http://example.com</xsl:param>

<!-- Main Function -->
	<xsl:template match="/*">
		<xsl:variable name="PublisherName" select="translate(publisher,' ','')"/>
		<xsl:variable name="PublisherURI" select="concat($basenamespace,'/publisher/',$PublisherName)"/>
		<xsl:variable name="CatalogName" select="substring-before(identifier, '/')"/>
		<xsl:variable name="CatalogURI" select="concat($basenamespace,'/catalog/',$CatalogName)"/>
		<xsl:variable name="DatasetURI" select="concat($basenamespace,'/dataset/',identifier)"/>
		<xsl:variable name="DistributionURI" select="concat($basenamespace,'/distribution/',identifier)"/>
		
		<rdf:RDF>
			<xsl:apply-templates select="publisher">
			 	<xsl:with-param name="publisher_URI" select="$PublisherURI"/>
			 </xsl:apply-templates>

			<xsl:call-template name="catalog">
				<xsl:with-param name="catalog_URI" select="$CatalogURI"/>
				<xsl:with-param name="publisher_URI" select="$PublisherURI"/>
				<xsl:with-param name="dataset_URI" select="$DatasetURI"/>
			</xsl:call-template>
						 
			<xsl:call-template name="dataset">
			    <xsl:with-param name="dataset_URI" select="$DatasetURI"/>
			 	<xsl:with-param name="publisher_URI" select="$PublisherURI"/>
			 	<xsl:with-param name="distribution_URI" select="$DistributionURI"/>
			 </xsl:call-template>
			 
			<xsl:call-template name="distribution">
				<xsl:with-param name="distribution_URI" select="$DistributionURI"/>
			</xsl:call-template>			
		</rdf:RDF>
	</xsl:template>	
	
   <xsl:template match="publisher">
   		<xsl:param name="publisher_URI" />
 		<rdf:Description rdf:about="{$publisher_URI}">
			<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization" />
	    </rdf:Description>	
   	</xsl:template>

   	<xsl:template name="catalog">
   		<xsl:param name="catalog_URI" />
   		<xsl:param name="publisher_URI" />
   	   	<xsl:param name="dataset_URI" />
   	    <rdf:Description rdf:about="{$catalog_URI}">
				<rdf:type rdf:resource="http://www.w3.org/ns/dcat#Catalog" />
				<dct:title>Data Science catalog</dct:title>
				<dct:description>List of Data Science publication</dct:description>
				<dct:publisher rdf:resource="{$publisher_URI}"/>
				<dcat:dataset rdf:resource="{$dataset_URI}"/>
		</rdf:Description>
   	</xsl:template>	
  	
   	<xsl:template name="dataset">
   	   	<xsl:param name="dataset_URI" />
   	   	<xsl:param name="publisher_URI" />
   	   	<xsl:param name="distribution_URI" />
 		<rdf:Description rdf:about="{$dataset_URI}">
			<rdf:type rdf:resource="http://www.w3.org/ns/dcat#Dataset" />
			<dct:title xml:lang="{titles/title[not(@titleType)]/@xml:lang}">
					<xsl:value-of select="titles/title[not(@titleType)]" />
			 </dct:title>
			 <xsl:if test="descriptions/description">
			 <dct:description>
					<xsl:value-of select="normalize-space(descriptions/description)" />
			 </dct:description>
			 </xsl:if>
			<xsl:for-each select="subjects/*">
				<dcat:keyword><xsl:value-of select="."/></dcat:keyword>
			</xsl:for-each>
			<xsl:for-each select="subjects/@valueURI">
				<dcat:theme rdf:resource="{.}"/>
			</xsl:for-each>
			 <dct:publisher rdf:resource="{$publisher_URI}"/>
			 <dcat:distribution rdf:resource="{$distribution_URI}"/>
		</rdf:Description>			
   	</xsl:template>
   	
   	<xsl:template name="distribution">
   		<xsl:param name="distribution_URI" />
   	    <rdf:Description rdf:about="{$distribution_URI}">
				<rdf:type rdf:resource="http://www.w3.org/ns/dcat#Distribution" />
				 <xsl:if test="descriptions/description">
				 <dct:description>
 					<xsl:value-of select="normalize-space(descriptions/description)" />
				 </dct:description>
				 </xsl:if>
				<dcat:accessURL rdf:resource="https://doi.org/{identifier}" />
				<xsl:if test="formats/format">
				<dct:format rdf:resource="{formats/format}"/>
				</xsl:if>
				<xsl:if test="rightsList/rights/@rightsURI">
				<dct:license rdf:resource="{rightsList/rights/@rightsURI}"/>
				</xsl:if>
		</rdf:Description>
   	</xsl:template>	

</xsl:stylesheet>
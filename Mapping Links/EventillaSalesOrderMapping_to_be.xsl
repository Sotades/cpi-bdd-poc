<?xml version='1.0' encoding='utf-8' ?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:a="urn:alma.fi:Global" exclude-result-prefixes="a">
	<xsl:import href="AlmaGlobalTemplates.xsl"/>
	<xsl:output indent="yes" media-type="xml"/>
	<xsl:decimal-format name="decimal" decimal-separator="."/>
	<xsl:param name="receiverName"/>
	<xsl:param name="receiverType"/>
	<xsl:param name="receiverPort"/>
	<xsl:param name="senderType"/>
	<xsl:param name="senderPort"/>
	<xsl:template match="/">
		<ZALMA_SALESORDERCREATEFROMD201>
			<IDOC BEGIN="1">
				<EDI_DC40 SEGMENT="1">
					<TABNAM>EDI_DC40</TABNAM>
					<DIRECT>2</DIRECT>
					<IDOCTYP>ZALMA_SALESORDERCREATEFROMD201</IDOCTYP>
					<MESTYP>ZALMA_SALESORDERCREATEFROMD2</MESTYP>
					<xsl:if test="normalize-space(Header/InvoiceNumber) != ''">
						<REFMES>
							<xsl:value-of select="Header/InvoiceNumber"/>
						</REFMES>
					</xsl:if>
					<SNDPOR>
						<xsl:value-of select="$senderPort"/>
					</SNDPOR>
					<SNDPRT>
						<xsl:value-of select="$senderType"/>
					</SNDPRT>
					<SNDPRN>
						<xsl:value-of select="Header/SenderSystem"/>
					</SNDPRN>
					<RCVPOR>
						<xsl:value-of select="$receiverPort"/>
					</RCVPOR>
					<RCVPRT>
						<xsl:value-of select="$receiverType"/>
					</RCVPRT>
					<RCVPRN>
						<xsl:value-of select="$receiverName"/>
					</RCVPRN>
				</EDI_DC40>
				<Z1ZALMA_SALESORDERCREATEFRO SEGMENT="1">
					<E1BPSDHD1 SEGMENT="1">
						<DOC_TYPE>
							<xsl:value-of select="SalesOrder/Header/SalesOrderType"/>
						</DOC_TYPE>
						<REF_1>
							<xsl:value-of select="SalesOrder/Header/InvoiceNumber"/>
						</REF_1>
						<PMNTTRMS>
							<xsl:value-of select="SalesOrder/Header/PaymentTerms"/>
						</PMNTTRMS>
						<PURCH_NO_C>
							<xsl:value-of select="SalesOrder/Header/YourReference"/>
						</PURCH_NO_C>
						<PURCH_NO_S>
							<xsl:value-of select="SalesOrder/Header/OurReference"/>
						</PURCH_NO_S>
						<CURR_ISO>
							<xsl:value-of select="SalesOrder/Header/Currency"/>
						</CURR_ISO>
					</E1BPSDHD1>
					<xsl:for-each select="SalesOrder/Item">
						<E1BPSDITM>
							<ITM_NUMBER>
								<xsl:value-of select="ItemNumber"/>
							</ITM_NUMBER>
							<xsl:if test="Type = 'Internal'">
								<MATERIAL>
									<xsl:value-of select="MaterialNumber"/>
								</MATERIAL>
							</xsl:if>
							<TARGET_QU>
								<xsl:value-of select="OrderQuantity"/>
							</TARGET_QU>
							<ITEM_CATEG>
								<xsl:value-of select="ItemCategory"/>
							</ITEM_CATEG>
							<PRC_GROUP1>
								<xsl:value-of select="Prc_Group1"/>
							</PRC_GROUP1>
							<PRC_GROUP3>
								<xsl:value-of select="Prc_Group3"/>
							</PRC_GROUP3>
							<E1BPSDITM1>
								<ORDERID><xsl:value-of select="ProjectNumber"/></ORDERID>
							</E1BPSDITM1>
						</E1BPSDITM>
					</xsl:for-each>
					
					<E1BPPARNR SEGMENT="1">
						<PARTN_ROLE><xsl:value-of select="SalesOrder/Header/PartnerCustomer/Role"/></PARTN_ROLE>
						<PARTN_NUMB><xsl:value-of select="SalesOrder/Header/PartnerCustomer/Number"/></PARTN_NUMB>
						<NAME><xsl:value-of select="SalesOrder/Header/PartnerCustomer/Name"/></NAME>
						<NAME_2><xsl:value-of select="SalesOrder/Header/PartnerCustomer/Name_2"/></NAME_2>
						<NAME_3><xsl:value-of select="SalesOrder/Header/PartnerCustomer/Name_3"/></NAME_3>
						<NAME_4><xsl:value-of select="SalesOrder/Header/PartnerCustomer/Name_4"/></NAME_4>
						<STREET><xsl:value-of select="SalesOrder/Header/PartnerCustomer/Street"/></STREET>
						<COUNTRY><xsl:value-of select="SalesOrder/Header/PartnerCustomer/Country"/></COUNTRY>
						<POSTL_CODE><xsl:value-of select="SalesOrder/Header/PartnerCustomer/Postal_Code"/></POSTL_CODE>
						<CITY><xsl:value-of select="SalesOrder/Header/PartnerCustomer/City"/></CITY>
					</E1BPPARNR>

					<E1BPPARNR SEGMENT="1">
						<PARTN_ROLE><xsl:value-of select="SalesOrder/Header/PartnerInterface/Role"/></PARTN_ROLE>
						<PARTN_NUMB><xsl:value-of select="SalesOrder/Header/PartnerInterface/Number"/></PARTN_NUMB>
					</E1BPPARNR>

					<E1BPPARNR SEGMENT="1">
						<PARTN_ROLE><xsl:value-of select="SalesOrder/Header/PartnerSalesPerson/Role"/></PARTN_ROLE>
						<PARTN_NUMB><xsl:value-of select="SalesOrder/Header/PartnerSalesPerson/Number"/></PARTN_NUMB>
					</E1BPPARNR>

					<!--Schedule lines-->
					<xsl:for-each select="SalesOrder/Item">
					<E1BPSCHDL SEGMENT="1">
						<ITM_NUMBER><xsl:value-of select="ItemNumber"/></ITM_NUMBER>
						<REQ_QTY><xsl:value-of select="OrderQuantity"/></REQ_QTY>
					</E1BPSCHDL>

					</xsl:for-each>

					<E1BPSDTEXT SEGMENT="1">
						<ITM_NUMBER>000000</ITM_NUMBER>
						<TEXT_ID>
							<xsl:value-of select="SalesOrder/Header/ContractNumber/TextID"/>
						</TEXT_ID>
						<FORMAT_COL>*</FORMAT_COL>
						<TEXT_LINE>
							<xsl:value-of select="SalesOrder/Header/ContractNumber/TextRow"/>
						</TEXT_LINE>
					</E1BPSDTEXT>
				</Z1ZALMA_SALESORDERCREATEFRO>
			</IDOC>
		</ZALMA_SALESORDERCREATEFROMD201>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="SalesOrderExample1" userelativepaths="yes" externalpreview="no" url="..\XML\SalesOrderExample1.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth="" profilelength=""
		          urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"
		          customvalidator="">
			<advancedProp name="bSchemaAware" value="true"/>
			<advancedProp name="xsltVersion" value="2.0"/>
			<advancedProp name="schemaCache" value="||"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="bGenerateByteCode" value="true"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="sInitialMode" value=""/>
		</scenario>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="..\..\..\CPI Migration\Sales Order\Global, ATT, Adbase &amp; Vuokranappi Sales Order\XSD\ZALMA_SALESORDERCREATEFROMD2.ZALMA_SALESORDERCREATEFROMD201.xsd"
		            destSchemaRoot="ZALMA_SALESORDERCREATEFROMD201" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no">
			<SourceSchema srcSchemaPath="..\XSD\SalesOrder.xsd" srcSchemaRoot="SalesOrder" AssociatedInstance="" loaderFunction="document" loaderFunctionUsesURI="no"/>
		</MapperInfo>
		<MapperBlockPosition>
			<template match="/">
				<block path="ZALMA_SALESORDERCREATEFROMD201/IDOC/EDI_DC40/xsl:if/!=[0]" x="195" y="175"/>
				<block path="ZALMA_SALESORDERCREATEFROMD201/IDOC/EDI_DC40/xsl:if/!=[0]/normalize-space[0]" x="149" y="169"/>
				<block path="ZALMA_SALESORDERCREATEFROMD201/IDOC/EDI_DC40/xsl:if" x="241" y="177"/>
				<block path="ZALMA_SALESORDERCREATEFROMD201/IDOC/EDI_DC40/xsl:if/REFMES/xsl:value-of" x="281" y="177"/>
				<block path="ZALMA_SALESORDERCREATEFROMD201/IDOC/EDI_DC40/SNDPOR/xsl:value-of" x="481" y="177"/>
				<block path="ZALMA_SALESORDERCREATEFROMD201/IDOC/EDI_DC40/SNDPRT/xsl:value-of" x="521" y="177"/>
				<block path="ZALMA_SALESORDERCREATEFROMD201/IDOC/EDI_DC40/SNDPRN/xsl:value-of" x="441" y="177"/>
				<block path="ZALMA_SALESORDERCREATEFROMD201/IDOC/EDI_DC40/RCVPOR/xsl:value-of" x="401" y="177"/>
				<block path="ZALMA_SALESORDERCREATEFROMD201/IDOC/EDI_DC40/RCVPRT/xsl:value-of" x="361" y="177"/>
				<block path="ZALMA_SALESORDERCREATEFROMD201/IDOC/EDI_DC40/RCVPRN/xsl:value-of" x="321" y="177"/>
				<block path="ZALMA_SALESORDERCREATEFROMD201/IDOC/Z1ZALMA_SALESORDERCREATEFRO/xsl:for-each" x="201" y="177"/>
				<block path="ZALMA_SALESORDERCREATEFROMD201/IDOC/Z1ZALMA_SALESORDERCREATEFRO/xsl:for-each/E1BPSDITM/xsl:if/=[0]" x="115" y="175"/>
				<block path="ZALMA_SALESORDERCREATEFROMD201/IDOC/Z1ZALMA_SALESORDERCREATEFRO/xsl:for-each/E1BPSDITM/xsl:if" x="161" y="177"/>
			</template>
		</MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->
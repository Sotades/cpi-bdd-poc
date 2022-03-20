<?xml version="1.0"?>
<!-- 03.09.2015 	v02	MKa		8_346 Added <EndCustomer> Idocin E1BPPAREX -> structure = ’LOPPUASIAKAS’ -->
<!-- 14.12.2015 	v03	MKa		8_395 Added <InvoiceOVT> Idocin E1BPPAREX -> structure = ’ZZOVT’  -->
<!-- 24.03.2016		v04	MKa		8_422 Poikkeava laskutusosoite ja nimi, toteutus haluttu kuten Adbasessa, ilman 'RE' rajausta  -->
<!-- 19.4.2016		v05	KJo		8_431 ProjectNumber tietoon ei etunollia, mikäli arvo ei ole numeerinen -->
<!-- 27.4.2016		V06 KJo		8_431 ZED3 ja ZED4 tilauslajien käsittely lisätty -->
<!-- 12.5.2016		V07 KJo		8_431 Asiakkaan FI51 Talentum tilauslajille ZED4 korttisegmentin lisäys -->
<!-- 16.11.2016 	V08	MKa		8_523 Added <Prc_Group3> to idoc E1BPSDITM-PRC_GROUP3-->
<!-- 20.09.2019     V09 AKu     CHG00040118 Added ZED5 and ZED6-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:a="urn:alma.fi:Global" exclude-result-prefixes="a">
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
			<xsl:for-each select="a:GMT_Alma_Global_SalesOrder/SalesOrder">
				<xsl:variable name="InvoicType">
					<xsl:choose>
						<xsl:when test="normalize-space(Header/SalesOrderType) = ''">
							<xsl:variable name="sum">
								<xsl:call-template name="calculator">
									<xsl:with-param name="currSum">0</xsl:with-param>
									<xsl:with-param name="count">
										<xsl:value-of select="count(Item)"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$sum &lt; 0">
									<xsl:value-of select="'ZECR'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'ZED'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="Header/SalesOrderType"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
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
						<SNDPOR><xsl:value-of select="$senderPort"/></SNDPOR>
						<SNDPRT><xsl:value-of select="$senderType"/></SNDPRT>
						<SNDPRN><xsl:value-of select="Header/SenderSystem"/></SNDPRN>
						<RCVPOR><xsl:value-of select="$receiverPort"/></RCVPOR>
						<RCVPRT><xsl:value-of select="$receiverType"/></RCVPRT>
						<RCVPRN><xsl:value-of select="$receiverName"/></RCVPRN>
					</EDI_DC40>
					<Z1ZALMA_SALESORDERCREATEFRO SEGMENT="1">
						<E1BPSDHD1 SEGMENT="1">
							<DOC_TYPE>
								<xsl:value-of select="$InvoicType"/>
							</DOC_TYPE>
							<SALES_ORG>
								<xsl:value-of select="Header/SalesOrganization"/>
							</SALES_ORG>
							<DISTR_CHAN>
								<xsl:value-of select="Header/DistributionChannel"/>
							</DISTR_CHAN>
							<DIVISION>
								<xsl:value-of select="Header/Division"/>
							</DIVISION>
							<xsl:if test="normalize-space(Header/RequestedDeliveryDate) != ''">
								<REQ_DATE_H>
									<xsl:value-of select="concat(substring(Header/RequestedDeliveryDate,5,4),substring(Header/RequestedDeliveryDate,3,2),substring(Header/RequestedDeliveryDate,1,2))"/>
								</REQ_DATE_H>
							</xsl:if>
							<xsl:if test="normalize-space(Header/InvoiceNumber) != ''">
								<REF_1>
									<xsl:value-of select="Header/InvoiceNumber"/>
								</REF_1>
							</xsl:if>
							<xsl:if test="normalize-space(Header/CustomerRefNumber) != ''">
								<NAME>
									<xsl:value-of select="Header/CustomerRefNumber"/>
								</NAME>
							</xsl:if>
							<PMNTTRMS>
								<xsl:value-of select="Header/PaymentTerm"/>
							</PMNTTRMS>
							<xsl:if test="normalize-space(Header/YourReference) != ''">
								<PURCH_NO_C>
									<xsl:value-of select="Header/YourReference"/>
								</PURCH_NO_C>
							</xsl:if>
							<xsl:if test="normalize-space(Header/OurReference) != ''">
								<PURCH_NO_S>
									<xsl:value-of select="Header/OurReference"/>
								</PURCH_NO_S>
							</xsl:if>
							<!-- Vuodenvaihteen kp paivayssotku, pultataan DOC_DATE liittymassa tilapaisesti-->
							<!-- Vuodenvaihteen kp paivayssotku, poistetaan pulttaus-->
							<!--<DOC_DATE>20131231</DOC_DATE>-->
							<xsl:if test="normalize-space(Header/DueDate) != ''">
								<FIX_VAL_DY>
									<xsl:value-of select="concat(substring(Header/DueDate,5,4),substring(Header/DueDate,3,2),substring(Header/DueDate,1,2))"/>
								</FIX_VAL_DY>
							</xsl:if>
							<!-- Vuodenvaihteen kp paivayssotku, pultataan myos BILL_DATE liittymassa tilapaisesti-->
							<!-- Vuodenvaihteen kp paivayssotku, poistetaan pulttaus-->
							<!--<BILL_DATE>20131231</BILL_DATE>-->
							<xsl:if test="normalize-space(Header/DocumentDate) != ''">
								<BILL_DATE>
									<xsl:value-of select="concat(substring(Header/DocumentDate,5,4),substring(Header/DocumentDate,3,2),substring(Header/DocumentDate,1,2))"/>
								</BILL_DATE>
							</xsl:if>
							<xsl:if test="normalize-space(Item/Price/@Currency) != ''">
								<CURR_ISO>
									<xsl:value-of select="Item/Price/@Currency"/>
								</CURR_ISO>
							</xsl:if>
						</E1BPSDHD1>
						<xsl:for-each select="Item">
							<E1BPSDITM SEGMENT="1">
								<ITM_NUMBER>
									<xsl:value-of select="ItemNumber"/>
								</ITM_NUMBER>
								<xsl:if test="MaterialNumber[@type = 'Internal']">
									<MATERIAL>
										<xsl:value-of select="MaterialNumber"/>
									</MATERIAL>
								</xsl:if>
								<xsl:if test="($InvoicType = 'ZECR'  or $InvoicType = 'ZED5' or $InvoicType = 'ZED6') and RowType = '0' and number(OrderQuantity) &gt; 0">
									<TARGET_QTY>
										<xsl:value-of select="translate(OrderQuantity,',','.')"/>
									</TARGET_QTY>
								</xsl:if>
								<ITEM_CATEG>
									<xsl:choose>
										<xsl:when test="normalize-space(ItemCategory) = ''">
											<xsl:variable name="price" select="number(Price)"/>
											<xsl:choose>
												<xsl:when test="RowType = '3' and PrintType = '1'">
													<xsl:value-of select="'TATX'"/>
												</xsl:when>
												<!-- 27.4.16/kj ZED3 ja ZED4 käsittely lisätty -->
												<!-- <xsl:when test="RowType = '3' and (PrintType = '0' or normalize-space(PrintType = '') and $InvoicType = 'ZED')">
													<xsl:value-of select="'ZTXT'"/>
												</xsl:when> -->
												<xsl:when test="RowType = '3' and (PrintType = '0' or normalize-space(PrintType = '') and ($InvoicType = 'ZED' or $InvoicType = 'ZED3' or $InvoicType = 'ZED4'))">
													<xsl:value-of select="'ZTXT'"/>
												</xsl:when>
												<xsl:when test="RowType = '3' and (PrintType = '0' or normalize-space(PrintType = '') and ($InvoicType = 'ZECR'  or $InvoicType = 'ZED5' or $InvoicType = 'ZED6'))">
													<xsl:value-of select="'G2TX'"/>
												</xsl:when>
												<!-- 27.4.16/kj ZED3 ja ZED4 käsittely lisätty -->
												<!-- <xsl:when test="RowType = '0' and $InvoicType = 'ZED'"> -->
												<xsl:when test="RowType = '0' and ($InvoicType = 'ZED' or $InvoicType = 'ZED3' or $InvoicType = 'ZED4')">
													<xsl:choose>
														<!-- Normaali lasku, nollahinta -->
														<xsl:when test="$price = 0 or $price = 'NaN'">
															<xsl:value-of select="'ZTNN'"/>
														</xsl:when>
														<!-- Normaali lasku, hyvitysrivi -->
														<xsl:when test="Price/@Sign = '-'">
															<xsl:value-of select="'ZG2W'"/>
														</xsl:when>
														<!-- Normaali lasku, normaali rivi -->
														<xsl:otherwise>
															<xsl:value-of select="'ZTDC'"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:when test="RowType = '0' and ($InvoicType = 'ZECR' or $InvoicType = 'ZED5' or $InvoicType = 'ZED6')">
													<xsl:choose>
														<!-- Hyvityslasku, nollahinta -->
														<xsl:when test="$price = 0 or $price = 'NaN'">
															<xsl:value-of select="'ZG2T'"/>
														</xsl:when>
														<!-- Hyvityslasku, normaali rivi -->
														<xsl:when test="Price/@Sign = '-'">
															<xsl:value-of select="'G2W'"/>
														</xsl:when>
														<!-- Hyvityslasku, veloitusrivi -->
														<xsl:otherwise>
															<xsl:value-of select="'ZTAD'"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="ItemCategory"/>
										</xsl:otherwise>
									</xsl:choose>
								</ITEM_CATEG>
								<xsl:if test="normalize-space(Description) != ''">
									<SHORT_TEXT>
										<xsl:value-of select="Description"/>
									</SHORT_TEXT>
								</xsl:if>
								<!-- 3.12.2020 Added Prc_Group1 -->
								<xsl:if test="normalize-space(Prc_Group1) != ''">
									<PRC_GROUP1>
										<xsl:value-of select="Prc_Group1"/>
									</PRC_GROUP1>
								</xsl:if>
								<!-- 16.11.2016 Added Prc_Group3 -->
								<xsl:if test="normalize-space(Prc_Group3) != ''">
									<PRC_GROUP3>
										<xsl:value-of select="Prc_Group3"/>
									</PRC_GROUP3>
								</xsl:if>
								<xsl:if test="normalize-space(YourReference) != ''">
									<PURCH_NO_C>
										<xsl:value-of select="YourReference"/>
									</PURCH_NO_C>
								</xsl:if>
								<xsl:if test="normalize-space(OurReference) != ''">
									<PURCH_NO_S>
										<xsl:value-of select="OurReference"/>
									</PURCH_NO_S>
								</xsl:if>
								<SD_TAXCODE>
									<xsl:value-of select="VATCode"/>
								</SD_TAXCODE>
								<E1BPSDITM1 SEGMENT="1">
									<xsl:if test="normalize-space(ProjectNumber) != ''">
										<!-- <ORDERID>
											<xsl:value-of select="format-number(ProjectNumber, '000000000000')"/>
										</ORDERID> -->
										<!-- v05 8_431 numeerinen arvo kenttään etunollilla, aakkosnumeerinen ilman etunollia -->
										<xsl:choose>
											<xsl:when test="string(number (ProjectNumber )) != 'NaN'">
												<ORDERID>
													<xsl:value-of select="format-number(ProjectNumber, '000000000000')"/>
												</ORDERID>
											</xsl:when>
											<xsl:when test="string(number (ProjectNumber )) = 'NaN'">
												<ORDERID>
													<xsl:value-of select="ProjectNumber"/>
												</ORDERID>
											</xsl:when>
										</xsl:choose>
									</xsl:if>
								</E1BPSDITM1>
							</E1BPSDITM>
						</xsl:for-each>
						<xsl:for-each select="Header/Partner">
							<E1BPPARNR SEGMENT="1">
								<PARTN_ROLE>
									<xsl:value-of select="Role"/>
								</PARTN_ROLE>
								<PARTN_NUMB>
									<xsl:call-template name="addLeadingZeros">
										<xsl:with-param name="value" select="Number"/>
										<xsl:with-param name="length" select="8"/>
									</xsl:call-template>
								</PARTN_NUMB>
								<!-- 8_422 Partner RE roolin Poikkeava laskutusosoite ja nimi 22.03.2016 /MKa -->
								<!-- 8_422 24.3.2016 Asiakas halusi toteutuksen ilman 'RE' rajausta kuten tehty Adbasen SD liittymään /MKa -->
								<NAME>
									<xsl:value-of select="Name1"/>
								</NAME>
								<NAME_2>
									<xsl:value-of select="Name2"/>
								</NAME_2>
								<NAME_3>
									<xsl:value-of select="Name3"/>
								</NAME_3>
								<NAME_4>
									<xsl:value-of select="Name4"/>
								</NAME_4>
								<STREET>
									<xsl:value-of select="Street"/>
								</STREET>
								<COUNTRY>
									<xsl:value-of select="Country"/>
								</COUNTRY>
								<POSTL_CODE>
									<xsl:value-of select="PostalCode"/>
								</POSTL_CODE>
								<CITY>
									<xsl:value-of select="City"/>
								</CITY>
							</E1BPPARNR>
						</xsl:for-each>
						<xsl:for-each select="Item">
							<xsl:choose>
								<!-- 27.4.16/kj Lisätty ZED3 ja ZED4 käsittely -->
								<!-- <xsl:when test="$InvoicType = 'ZED' and RowType = '0' and number(OrderQuantity) &gt; 0"> -->
								<xsl:when test="($InvoicType = 'ZED' or $InvoicType = 'ZED3' or $InvoicType = 'ZED4') and RowType = '0' and number(OrderQuantity) &gt; 0">
									<E1BPSCHDL SEGMENT="1">
										<ITM_NUMBER>
											<xsl:value-of select="ItemNumber"/>
										</ITM_NUMBER>
										<REQ_QTY>
											<xsl:value-of select="translate(OrderQuantity,',','.')"/>
										</REQ_QTY>
									</E1BPSCHDL>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
						<xsl:for-each select="Item">
							<xsl:choose>
								<xsl:when test="RowType = '0'">
									<xsl:if test="number(Price) &gt; 0">
										<E1BPCOND SEGMENT="1">
											<ITM_NUMBER>
												<xsl:value-of select="ItemNumber"/>
											</ITM_NUMBER>
											<xsl:choose>
												<xsl:when test="(../Header/Partner[Role = 'AG']/Number = 'ON00000000') or (../Header/Partner[Role = 'ZI']/Number = 'ZI_ILCIRIX')">
													<COND_TYPE>ZPR1</COND_TYPE>
												</xsl:when>
												<xsl:otherwise>
													<COND_TYPE>ZPR0</COND_TYPE>
												</xsl:otherwise>
											</xsl:choose>
											<COND_VALUE>
												<xsl:value-of select="translate(format-number(Price,'0.0000'),',','.')"/>
											</COND_VALUE>
										</E1BPCOND>
									</xsl:if>
									<xsl:if test="number(Price) &gt; 0 and number(Discount) &gt; 0">
										<E1BPCOND SEGMENT="1">
											<ITM_NUMBER>
												<xsl:value-of select="ItemNumber"/>
											</ITM_NUMBER>
											<COND_TYPE>ZDI1</COND_TYPE>
											<COND_VALUE>
												<xsl:value-of select="translate(format-number(Discount,'0.0000'),',','.')"/>
											</COND_VALUE>
										</E1BPCOND>
									</xsl:if>
								</xsl:when>
							</xsl:choose>
							<!-- 20140822 TKu 8_153 Alunperin Adbasea varten tehdyt hinnoitteluehtolisäykset otetaan mukaan yhteiseen globaaliin malliin KLToimitilat -->
							<xsl:if test="PricingCondition[ConditionType='ZPRB'] and PricingCondition[ConditionType='ZD80']">
								<E1BPCOND SEGMENT="1">
									<ITM_NUMBER>
										<xsl:value-of select="ItemNumber"/>
									</ITM_NUMBER>
									<COND_TYPE>
										<xsl:value-of select="'ZPR0'"/>
									</COND_TYPE>
									<COND_VALUE>
										<xsl:value-of select="translate(format-number(PricingCondition[ConditionType='ZPRB']/Value + PricingCondition[ConditionType='ZD80']/Value,'0.0000'),',','.')"/>
									</COND_VALUE>
								</E1BPCOND>
							</xsl:if>
							<xsl:for-each select="PricingCondition[not(normalize-space(ConditionType)='')]">
								<E1BPCOND SEGMENT="1">
									<ITM_NUMBER>
										<xsl:value-of select="../ItemNumber"/>
									</ITM_NUMBER>
									<COND_TYPE>
										<xsl:value-of select="ConditionType"/>
									</COND_TYPE>
									<COND_VALUE>
										<xsl:value-of select="translate(format-number(Value,'0.0000'),',','.')"/>
									</COND_VALUE>
								</E1BPCOND>
							</xsl:for-each>
						</xsl:for-each>
						<!-- 27.4.16/KJ Lisätty ZED3 luottokorttitilauksen segmentti E1BPCCARD -->
						<!-- 12.5.16/KJ Lisätty ZED4 tilauslajin segmentti E1BPCCARD asiakkaalle FI51 Talentum -->
						<!-- <xsl:if test="$InvoicType='ZED3'"> -->
						<xsl:if test="$InvoicType='ZED3' or ($InvoicType='ZED4' and substring(normalize-space(Header/SenderSystem),1,8) = 'ZI_CRM51' )">
							<E1BPCCARD SEGMENT="1">
								<CC_TYPE>CARD</CC_TYPE>
								<CC_NUMBER>1234567890</CC_NUMBER>
								<CC_VALID_T>20501231</CC_VALID_T>
								<BILLAMOUNT>99999</BILLAMOUNT>
								<AUTH_FLAG>X</AUTH_FLAG>
								<AUTHAMOUNT>99999</AUTHAMOUNT>
								<CURRENCY>EUR</CURRENCY>
								<AUTH_CC_NO>7777777777</AUTH_CC_NO>
								<AUTH_REFNO>987654321</AUTH_REFNO>
								<CC_REACT>A</CC_REACT>
								<CC_STAT_EX>C</CC_STAT_EX>
								<AUTHORTYPE>A</AUTHORTYPE>
							</E1BPCCARD>
						</xsl:if>
						<!-- 2019.10.15 Lisätty ZED5 luottokorttitilauksen segmentti E1BPCCARD -->
						<xsl:if test="$InvoicType='ZED5'">
							<E1BPCCARD SEGMENT="1">
								<CC_TYPE>CRRD</CC_TYPE>
								<CC_NUMBER>1234567890</CC_NUMBER>
								<CC_VALID_T>20501231</CC_VALID_T>
								<BILLAMOUNT>99999</BILLAMOUNT>
								<AUTH_FLAG>X</AUTH_FLAG>
								<AUTHAMOUNT>99999</AUTHAMOUNT>
								<CURRENCY>EUR</CURRENCY>
								<AUTH_CC_NO>7777777777</AUTH_CC_NO>
								<AUTH_REFNO>987654321</AUTH_REFNO>
								<CC_REACT>A</CC_REACT>
								<CC_STAT_EX>C</CC_STAT_EX>
								<AUTHORTYPE>A</AUTHORTYPE>
							</E1BPCCARD>
						</xsl:if>
						<xsl:for-each select="Header/PricingCondition[not(normalize-space(ConditionType)='')]">
							<E1BPCOND SEGMENT="1">
								<COND_TYPE>
									<xsl:value-of select="ConditionType"/>
								</COND_TYPE>
								<COND_VALUE>
									<xsl:value-of select="translate(format-number(Value,'0.0000'),',','.')"/>
								</COND_VALUE>
							</E1BPCOND>
						</xsl:for-each>
						<!-- 20140822 TKu 8_153 -->
						<xsl:for-each select="Header/Text">
							<E1BPSDTEXT SEGMENT="1">
								<ITM_NUMBER>000000</ITM_NUMBER>
								<TEXT_ID>
									<xsl:value-of select="TextID"/>
								</TEXT_ID>
								<FORMAT_COL>
									<xsl:text>*</xsl:text>
								</FORMAT_COL>
								<TEXT_LINE>
									<xsl:value-of select="TextRow"/>
								</TEXT_LINE>
							</E1BPSDTEXT>
						</xsl:for-each>
						<xsl:for-each select="Item/Text">
							<E1BPSDTEXT SEGMENT="1">
								<ITM_NUMBER>
									<xsl:value-of select="ItemNumber"/>
								</ITM_NUMBER>
								<TEXT_ID>
									<xsl:value-of select="TextID"/>
								</TEXT_ID>
								<FORMAT_COL>
									<xsl:text>*</xsl:text>
								</FORMAT_COL>
								<TEXT_LINE>
									<xsl:value-of select="TextRow"/>
								</TEXT_LINE>
							</E1BPSDTEXT>
						</xsl:for-each>
						<!-- 14.12.2015 8_395 Parameter for InvoiceOVT handling -->
						<xsl:if test="normalize-space(Header/InvoiceOVT) != ''">
							<E1BPPAREX SEGMENT="1">
								<STRUCTURE>
									<xsl:value-of select="'ZZOVT'"/>
								</STRUCTURE>
								<VALUEPART1>
									<xsl:value-of select="Header/InvoiceOVT"/>
								</VALUEPART1>
							</E1BPPAREX>
						</xsl:if>
						<!-- Sopimuslaskutus Meediotyyliin globaaliin malliin mukaan Alkalia varten TKu20141013 -->
						<xsl:for-each select="Item">
							<xsl:if test="normalize-space(ContractNumber) != '' or normalize-space(ContractBeginDate) != '' or normalize-space(ContractEndDate) != ''">
								<E1BPPAREX SEGMENT="1">
									<STRUCTURE>
										<xsl:value-of select="'ORDER_ZDATES'"/>
									</STRUCTURE>
									<VALUEPART1>
										<xsl:value-of select="ItemNumber"/>
									</VALUEPART1>
									<VALUEPART2>
										<xsl:value-of select="concat(substring(ContractBeginDate,5,4),substring(ContractBeginDate,3,2),substring(ContractBeginDate,1,2))"/>
									</VALUEPART2>
									<VALUEPART3>
										<xsl:value-of select="concat(substring(ContractEndDate,5,4),substring(ContractEndDate,3,2),substring(ContractEndDate,1,2))"/>
									</VALUEPART3>
									<VALUEPART4>
										<xsl:value-of select="ContractNumber"/>
									</VALUEPART4>
								</E1BPPAREX>
							</xsl:if>
						</xsl:for-each>
						<!-- 03.09.2015 8_346 EndCustomer kentän lisäys -->
						<xsl:for-each select="Item">
							<xsl:if test="normalize-space(EndCustomer) != '' and normalize-space(RowType) = '0'">
								<E1BPPAREX SEGMENT="1">
									<STRUCTURE>LOPPUASIAKAS</STRUCTURE>
									<VALUEPART1>
										<xsl:value-of select="ItemNumber"/>
									</VALUEPART1>
									<VALUEPART2>
										<xsl:value-of select="EndCustomer"/>
									</VALUEPART2>
								</E1BPPAREX>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="Item">
							<xsl:choose>
								<xsl:when test="RowType = '0'">
									<xsl:if test="normalize-space(AccountNumber) != '' or normalize-space(CostCenter) != '' or MaterialNumber/@type = 'External'">
										<Z1ZALMABAPISDITM SEGMENT="1">
											<ITM_NUMBER>
												<xsl:value-of select="ItemNumber"/>
											</ITM_NUMBER>
											<xsl:if test="normalize-space(AccountNumber) != ''">
												<ACCOUNT_NUMBER>
													<xsl:value-of select="AccountNumber"/>
												</ACCOUNT_NUMBER>
											</xsl:if>
											<xsl:if test="normalize-space(CostCenter) != ''">
												<COST_CENTER>
													<xsl:value-of select="format-number(CostCenter,'0000000000')"/>
												</COST_CENTER>
											</xsl:if>
											<xsl:if test="MaterialNumber/@type = 'External'">
												<MATERIAL>
													<xsl:value-of select="MaterialNumber"/>
												</MATERIAL>
											</xsl:if>
										</Z1ZALMABAPISDITM>
									</xsl:if>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</Z1ZALMA_SALESORDERCREATEFRO>
				</IDOC>
			</xsl:for-each>
		</ZALMA_SALESORDERCREATEFROMD201>
	</xsl:template>
	<xsl:template name="calculator">
		<xsl:param name="currSum"/>
		<xsl:param name="count"/>
		<xsl:variable name="itemSum">
			<xsl:value-of select="Item[number($count)]/Price * Item[number($count)]/OrderQuantity"/>
		</xsl:variable>
		<xsl:variable name="cycleSum">
			<xsl:choose>
				<xsl:when test="Item[number($count)]/RowType != '0'">
					<xsl:value-of select="number($currSum)"/>
				</xsl:when>
				<xsl:when test="$itemSum = 'NaN'">
					<xsl:value-of select="number($currSum)"/>
				</xsl:when>
				<xsl:when test="Item[number($count)]/Price/@Sign = '-'">
					<xsl:value-of select="number($currSum - $itemSum)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number($currSum + $itemSum)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="number($count - 1) &gt; 0 ">
				<xsl:call-template name="calculator">
					<xsl:with-param name="currSum" select="$cycleSum"/>
					<xsl:with-param name="count" select="number($count - 1)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$cycleSum"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\XML\as_is_xml_salesorder_eventilla_10049473_181221_033109360_original_schema.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes"
		          profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""
		          validateoutput="no" validator="internal" customvalidator="">
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
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->